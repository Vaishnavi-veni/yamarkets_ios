import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:async';
import 'package:flutter_animated_button/flutter_animated_button.dart';

// import '../features/home_feature/presentation/screens/home_view.dart';
// import 'register.dart';
// import 'home.dart';
import 'package:yamarkets_ios/view/url.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin{
  late AnimationController _animationController;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  SharedPreferences? prefs;
  Timer? _logoutTimer;

  void saveLoginStatus() async {
    prefs = await SharedPreferences.getInstance();
    await prefs?.setBool('isLoggedIn', true);
  }

  final storage = FlutterSecureStorage();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController _textEditingController = TextEditingController();
  bool isInputValid = false;

  bool _obscureText = true;


  @override
  void initState() {
    super.initState();
    initializeLogoutTimer();
    // checkLoginStatus();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  void initializeLogoutTimer() {
    const logoutDuration = Duration(days: 30);

    _logoutTimer = Timer(logoutDuration, () {
      // Logout the user after the timer expires
      logout();
    });
  }

  void logout() {
    // Add the logic to perform logout actions here
    clearLoginStatus();
  }

  void clearLoginStatus() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('isLoggedIn');
      // Clear the access token or other user data when logging out
      storage.delete(key: 'access_token');
    });
  }


  // void checkLoginStatus() async {
  //   prefs = await SharedPreferences.getInstance();
  //   bool isLoggedIn = prefs?.getBool('isLoggedIn') ?? false;
  //
  //   if (isLoggedIn) {
  //     // User is already logged in, navigate to the next screen
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => HomePage()),
  //     );
  //     _startLogoutTimer(context);
  //   }
  // }



  void _validateInput(String text) {
    setState(() {
      isInputValid = text.isNotEmpty;
    });
  }


  Future<void> login(String email, password) async {
    try {
      final response = await http.post(
        Uri.parse('${MyConstants.baseUrl}/login'),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        initializeLogoutTimer();
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Response data: $responseData');

        if (responseData.containsKey('access_token')) {
          final String accessToken = responseData['access_token'];

          // Store the access token securely
          await storage.write(key: 'access_token', value: accessToken);

          print('Response data: $responseData');
          Fluttertoast.showToast(
            msg: "Login successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xffffc400),
            textColor: Colors.black,
            fontSize: 16.0,
          );

          Navigator.pushNamed(
              context,'/home');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _startLogoutTimer(context);
          });
        } else {
          Fluttertoast.showToast(
            msg: "Login failed: Access token not found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Login failed.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print(e.toString());

      Fluttertoast.showToast(
        msg: "Login failed ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xffffc400),
        textColor: Colors.black,
        fontSize: 16.0,
      );
    }
  }

  Future<void> displayTokenDetails() async {
    final accessToken = await storage.read(key: 'access_token');
    if (accessToken != null) {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
      print(accessToken);
      print('Decoded token: $decodedToken');

      // Example: Display the user's name from the decoded token
      final String userName = decodedToken['username'];

      Fluttertoast.showToast(
        msg: 'Welcome! $userName',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xffffc400),
        textColor: Colors.black,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Enter correct details!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _startLogoutTimer(BuildContext context) {
    // Set the duration for automatic logout (5 seconds in this case)
    const logoutDuration = Duration(hours: 2);

    // Create a new timer
    _logoutTimer = Timer(logoutDuration, () {
      // Logout the user after the timer expires
      logout();
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation)
    {
      final bool isLandscape = orientation == Orientation.landscape;
      double screenHeight = MediaQuery
          .of(context)
          .size
          .height;
      double screenWidth = MediaQuery
          .of(context)
          .size
          .width;
      return WillPopScope(
          onWillPop: () async {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) =>
            //       HomeView()),
            // );
            return true;
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
                backgroundColor: Colors.white.withOpacity(0.95),
                body: Container(
                    width: screenWidth,
                    height: screenHeight,

                    child: SingleChildScrollView(
                      child: Center(
                          child:
                          Column(
                            children: [
                              SizedBox(height: isLandscape
                                  ? screenHeight * 0.1
                                  : screenHeight * 0.2,),
                              Image.asset(
                                'assets/logo/yamarketsacademy-removebg-preview.png',
                                // Change this to your image path
                                width: isLandscape
                                    ? screenWidth * 0.2
                                    : screenWidth * 0.6,

                              ),
                              SizedBox(height: isLandscape
                                  ? screenHeight * 0.04
                                  : screenHeight * 0.11,),
                              Container(
                                alignment: Alignment.bottomCenter,
                                decoration: BoxDecoration(

                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(50),topLeft:Radius.circular(50))
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: screenHeight*0.08,),

                                    Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(left: 35),
                                        child:Text("Login",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize:isLandscape
                                                ? screenWidth * 0.03
                                                : screenWidth * 0.07,
                                          ),)
                                    ),

                                    SizedBox(
                                      height: screenHeight * 0.015,
                                    ),
                                    SizedBox(
                                      height: isLandscape
                                          ? screenWidth * 0.05
                                          : screenHeight * 0.08,
                                      width: isLandscape
                                          ? screenWidth * 0.7
                                          : screenWidth * 0.9,
                                      child: Container(
                                        child:
                                        Container(
                                          width: screenWidth * 0.65,
                                          // margin: EdgeInsets.only(left: 00,top:0 ),
                                          // Adjust width as needed
                                          child: TextField(
                                            controller: emailController,
                                            style: TextStyle(color: Colors.black),
                                            decoration: const InputDecoration(
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.grey), // Color of the line
                                                ),
                                                hintText: 'Email',
                                                contentPadding: EdgeInsets.only(left:15)
                                            ),
                                          ),
                                        ),

                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: screenHeight * 0.02,
                                    // ),
                                    SizedBox(
                                      height: isLandscape ? screenWidth * 0.05 : screenHeight * 0.065,
                                      width: isLandscape ? screenWidth * 0.7 : screenWidth * 0.9,
                                      child: Container(
                                        child: Stack(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    style: TextStyle(color: Colors.black),
                                                    controller: passwordController,
                                                    obscureText: _obscureText,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: 'Password',
                                                      contentPadding: EdgeInsets.only(left: 15),
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    _obscureText ? Icons.visibility_off : Icons.visibility,
                                                    color: Colors.grey,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      _obscureText = !_obscureText;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                height: 1,
                                                color: Colors.grey, // Color of the line
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),


                                    SizedBox(
                                      height: screenHeight * 0.07,
                                    ),
                                    AnimatedButton(
                                      onPress: () {
                                        saveLoginStatus();

                                        Future.delayed(Duration(seconds: 0), () {
                                          login(emailController.text.toString(),
                                              passwordController.text.toString());
                                        });

                                        Future.delayed(Duration(seconds: 2), () {
                                          displayTokenDetails();
                                        });

                                        initializeLogoutTimer();
                                      },
                                      height: isLandscape
                                          ? screenWidth * 0.05
                                          : screenHeight * 0.065,
                                      width: isLandscape
                                          ? screenWidth * 0.7
                                          : screenWidth * 0.75,
                                      text: 'Login',
                                      isReverse: true,
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: isLandscape
                                            ? screenWidth * 0.025
                                            : screenWidth * 0.05,
                                      ),
                                      selectedTextColor: Colors.black,
                                      transitionType: TransitionType.LEFT_TO_RIGHT,
                                      // textStyle: submitTextStyle,
                                      backgroundColor: Color(0xFFFAC211).withOpacity(0.7),
                                      selectedBackgroundColor: Colors.white,
                                      borderColor: Colors.transparent,
                                      borderRadius: 10,
                                      borderWidth: 2,
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.04,
                                    ),

                                    Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Don't have an account?",
                                            style: TextStyle(
                                                fontSize: screenWidth*0.04
                                            ),),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context,'/register'
                                                // MaterialPageRoute(
                                                //     builder: (context) =>
                                                //         Register()),
                                              );
                                              // Add your onTap logic here
                                            },
                                            child: Text(" Register",
                                              style: TextStyle(
                                                  fontSize: screenWidth*0.04,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.blueAccent.shade700
                                              ),),
                                          )
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: screenHeight*0.1,)

                                  ],
                                ),
                              )
                              // SizedBox(
                              //   height: screenHeight * 0.02,
                              // ),
                              // AnimatedButton(
                              //   onPress: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(builder: (context) =>
                              //           Register()),
                              //     );
                              //   },
                              //   height: isLandscape
                              //       ? screenWidth * 0.05
                              //       : screenHeight * 0.065,
                              //   width: isLandscape
                              //       ? screenWidth * 0.7
                              //       : screenWidth * 0.9,
                              //   text: 'Create new account',
                              //   isReverse: true,
                              //   textStyle: TextStyle(
                              //       color: Colors.grey.shade700,
                              //       fontSize: isLandscape
                              //           ? screenWidth * 0.025
                              //           : screenWidth * 0.05,
                              //       fontWeight: FontWeight.w500
                              //   ),
                              //   selectedTextColor: Colors.white,
                              //   transitionType: TransitionType.LEFT_TO_RIGHT,
                              //   // textStyle: submitTextStyle,
                              //   backgroundColor: Colors.transparent,
                              //   selectedBackgroundColor: Colors.black,
                              //   borderColor: Colors.transparent,
                              //   borderRadius: 10,
                              //   borderWidth: 2,
                              // ),
                            ],
                          )
                      )
                      ,
                    )

                )),

          )

      );
    }
    );
  }
}
