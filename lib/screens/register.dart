import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:page_transition/page_transition.dart';
import '../view/url.dart';
// import 'home.dart';
import 'login.dart';

class Register extends StatefulWidget {

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>{
  late AnimationController _animationController;
  bool _obscureText = true;
  bool isEmailValid = true;
  bool isPasswordValid = true;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final storage = FlutterSecureStorage();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

  TextEditingController _textEditingController = TextEditingController();

  bool isInputValid = false;

  void _validateInput() {
    setState(() {
      bool isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text);
      bool isPasswordValid = passwordController.text.isNotEmpty && passwordController.text.length >= 8;

      isInputValid = firstnameController.text.isNotEmpty &&
          lastnameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty ;
    });
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
        msg: 'Enter all details correctly!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }


  Future<void> registerUser() async {
    final url = Uri.parse('${MyConstants.baseUrl}/register');

    try {
      final response = await http.post(
        url,
        body: {
          'firstname': firstnameController.text,
          'lastname': lastnameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'mobile_no':'1234567890'
        },
      );

      print('Response Status Code: ${response.statusCode}');

      print('Response Body: ${response.body}');

      // Check if registration is successful
      if (response.statusCode == 200) {
        // Parse the user information from the response
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Response Data: $responseData');


        if (responseData.containsKey('access_token')) {
          final String accessToken = responseData['access_token'];

          // Store the access token securely
          await storage.write(key: 'access_token', value: accessToken);

          // Save additional user information (e.g., username, mobile number)
          await storage.write(key: 'username', value: responseData['username']);
          print('Stored Access Token: $accessToken');
          print('Stored Username: ${responseData['username']}');

          await login(emailController.text, passwordController.text);
        }
        await Future.delayed(Duration(milliseconds: 500));

        // Navigate to the next screen
        Navigator.pushNamed(
            context,'/home'
        );
      } else  if (response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: 'Please enter correct informations in all fields.',
          gravity: ToastGravity.BOTTOM,
        );
      }
      else {
      }
      // Handle the response based on the status code and response body
    } catch (error) {
      // Handle any error that might occur during the HTTP request
      print('Error: $error');
      // Handle the error message or show it to the user
      Fluttertoast.showToast(
        msg: 'Please enter correct informations in all fields.',
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> login(String email, password) async {
    try {
      final response = await http.post(
        Uri.parse('${MyConstants.baseUrl}/login'),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
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
          msg: "Login failed: Server error",
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

  // Method to validate the email the take
// the user email as an input and
// print the bool value in the console.
  void Validate(String email) {
    bool isvalid = EmailValidator.validate(email);
    print(isvalid);
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
      return
        Scaffold(
            backgroundColor: Colors.white.withOpacity(0.95),
            body: SingleChildScrollView(
              child: Container(
                  child: Center(
                    child:
                    Column(
                      children: [
                        SizedBox(height: isLandscape
                            ? screenHeight * 0.05
                            : screenHeight * 0.05,),
                        Image.asset(
                          'assets/logo/yamarketsacademy-removebg-preview.png',
                          // Change this to your image path
                          width: isLandscape
                              ? screenWidth * 0.2
                              : screenWidth * 0.45,

                        ),
                        SizedBox(height: isLandscape
                            ? screenHeight * 0.02
                            : screenHeight * 0.02,),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 50),child:          Text("Hi, Let's Make a Journey with Us",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            // fontWeight: FontWeight.w500,
                            fontSize: isLandscape
                                ? screenWidth * 0.03
                                : screenWidth * 0.08,
                          ),),)
                        ,


                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)
                          ),
                          width: screenWidth,
                          child: Column(
                            children: [
                              SizedBox(height: screenHeight*0.02,),
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(left: 35),
                                child:Text("Register",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize:isLandscape
                                        ? screenWidth * 0.03
                                        : screenWidth * 0.06,
                                  ),) ,
                              )
                              ,
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              SizedBox(
                                height: isLandscape
                                    ? screenWidth * 0.04
                                    : screenHeight * 0.065,
                                width: isLandscape
                                    ? screenWidth * 0.5
                                    : screenWidth * 0.9,
                                child: Container(
                                  child:
                                  Container(
                                    width: screenWidth * 0.65,
                                    margin: EdgeInsets.only(left: 0),
                                    // Adjust width as needed
                                    child: TextField(
                                      controller: firstnameController,
                                      style: TextStyle(color: Colors.black),
                                      decoration: const InputDecoration(
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey), // Color of the line
                                          ),
                                          hintText: 'First Name ',
                                          contentPadding: EdgeInsets.only(left:15)
                                      ),
                                    ),
                                  ),

                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              SizedBox(
                                height: isLandscape
                                    ? screenWidth * 0.04
                                    : screenHeight * 0.065,
                                width: isLandscape
                                    ? screenWidth * 0.5
                                    : screenWidth * 0.9,
                                child: Container(
                                  child:
                                  Container(
                                    width: screenWidth * 0.6,
                                    margin: EdgeInsets.only(left: 0),
                                    // Adjust width as needed
                                    child: TextField(
                                      controller: lastnameController,
                                      style: TextStyle(color: Colors.black),
                                      decoration: const InputDecoration(
                                          border:UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey), // Color of the line
                                          ),
                                          hintText: 'Last Name',
                                          contentPadding: EdgeInsets.only(left:15)
                                      ),
                                    ),
                                  ),

                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              SizedBox(
                                height: isLandscape
                                    ? screenWidth * 0.04
                                    : screenHeight * 0.065,
                                width: isLandscape
                                    ? screenWidth * 0.5
                                    : screenWidth * 0.9,
                                child: Container(
                                  child:
                                  Container(
                                    width: screenWidth * 0.65,
                                    margin: EdgeInsets.only(left: 0),
                                    // Adjust width as needed
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: emailController,
                                          style: TextStyle(color: Colors.black),
                                          decoration: const InputDecoration(
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.grey), // Color of the line
                                            ),
                                            hintText: 'Email',
                                            contentPadding: EdgeInsets.only(left: 15),
                                          ),
                                          onChanged: (value) {
                                            // Update the validity of the email whenever it changes
                                            setState(() {
                                              isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
                                            });
                                          },
                                        ),
                                        // Add some space below the TextField

                                      ],
                                    ),
                                  ),


                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              SizedBox(
                                height: isLandscape ? screenWidth * 0.05 : screenHeight * 0.063,
                                width: isLandscape ? screenWidth * 0.7 : screenWidth * 0.9,
                                child: Container(
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child:
                                            TextField(
                                              style: TextStyle(color: Colors.black),
                                              controller: passwordController,
                                              obscureText: _obscureText,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Password',
                                                contentPadding: EdgeInsets.only(left: 15),
                                              ),
                                              onChanged: (value) {
                                                if (value.length < 8) {
                                                  isPasswordValid = value.isNotEmpty && value.length >= 8;
                                                }
                                                else{
                                                  isPasswordValid=true;
                                                }
                                              },
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
                                height: screenHeight * 0.02,
                              ),

                              SizedBox(
                                height: screenHeight * 0.03,
                              ),
                              AnimatedButton(
                                onPress: () async {
                                  (() => Validate(emailController.text));
                                  await registerUser();
                                  Future.delayed(const Duration(seconds: 2), () {
                                    displayTokenDetails();
                                  });
                                } ,
                                height: isLandscape
                                    ? screenWidth * 0.04
                                    : screenHeight * 0.065,
                                width: isLandscape
                                    ? screenWidth * 0.5
                                    : screenWidth * 0.75,
                                text: 'Register',
                                isReverse: true,
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: isLandscape
                                      ? screenWidth * 0.02
                                      : screenWidth * 0.05,
                                ),
                                selectedTextColor: Colors.black,
                                transitionType: TransitionType.LEFT_TO_RIGHT,
                                // textStyle: submitTextStyle,
                                backgroundColor: Color(0xFFFAC211).withOpacity(0.8),
                                selectedBackgroundColor: Colors.white,
                                borderColor: Colors.transparent,
                                borderRadius: 10,
                                borderWidth: 2,
                              ),
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Have an account?",
                                      style: TextStyle(
                                          fontSize: screenWidth*0.04,
                                          color: Colors.black
                                      ),),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => Login()),
                                        );
                                        // Add your onTap logic here
                                      },
                                      child: Text(" Login",
                                        style: TextStyle(
                                            fontSize: screenWidth*0.04,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xfffac211)
                                        ),),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                isEmailValid ? '' : 'Please enter a valid email',
                                style: TextStyle(color: Colors.red),
                              ),
                              Text(
                                isPasswordValid ? '' : 'Password should be minimum 8 characters',
                                style: TextStyle(color: Colors.red),
                              ),
                              SizedBox(
                                height: screenWidth * 0.22,
                              ),

                            ],
                          ),
                        ),

                      ],
                    ),

                  )

              ),
            )
        );
    }
    );
  }
  Widget _buildTextField(String hintText, TextEditingController controller) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.9,
      // height: 50,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(
            color: Colors.grey,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: (text) {
                  _validateInput();
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Padding(
        padding: EdgeInsets.only(left: width*0.05,right: width*0.05),
        child:
        Row(
          children: [
            SizedBox(
              // width: width * 0.10,
              height: height * .06,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                child: const Text(
                  '+91',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: SizedBox(
                height: height * 0.06,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isInputValid ? const Color(0xffffc400) : Colors.grey,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                  ),
                ),
              ),
            ),





          ],
        )
    );
  }

}





