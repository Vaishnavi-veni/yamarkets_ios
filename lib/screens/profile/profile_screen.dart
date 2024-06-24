import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gradient_icon/gradient_icon.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:yamarkets_ios/screens/categories.dart';
import 'dart:convert';

import '../../view/url.dart';
import '../home/home_screen.dart';
import '../login.dart';
import '../trade/trade_screen.dart';
import 'edit_profile.dart';


class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
      if (_selectedIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TradeMainPage(),
          ),);
      }
      if (_selectedIndex == 2) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => MyProfile()),
        // );
      }
    });
  }

  Future<int> _sendEmail() async {
    final Email email = Email(
      body: 'Email body text',
      subject: 'Facing an issue',
      recipients: ['support@yamarkets.com'],

      isHTML: false, // Set to true if you are sending HTML content
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      print('Error sending email: $error');
    }
    return 0;
  }
  final storage = FlutterSecureStorage();
  File? _pickedImage;
  String userName='';
  String user='';
  String phoneNumber='';

  @override
  void initState() {
    super.initState();
    // Initialize the controllers
    fetchCourseData();
  }

  void clearLoginStatus() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('isLoggedIn');
      // Clear the access token or other user data when logging out
      storage.delete(key: 'access_token');
    });
  }

  Future<File?> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
      return _pickedImage!;
    }

    return null;
  }

  Future<Map<String, dynamic>> getUsernameFromStorage() async {
    // Fetch the username and mobile number from storage
    String? username = await storage.read(key: 'username');
    String? mobileNumber = await storage.read(key: 'mobile_no');

    // Return a map with the retrieved values
    return {
      'username': username,
      'mobile_no': mobileNumber,
    };
  }

  Future<Map<String, dynamic>> fetchCourseData() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    if (accessToken != null) {
      // Decode the access token to get user information
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);

      user= decodedToken['uid'] ?? ''; // Assu

      print('D: $decodedToken');
    }

    try {
      final response = await http.get(
        Uri.parse('https://yamarketsacademy.com/api/course_api/user_data/$user'),
        headers: {
          'Authorization': '$accessToken', // Include the access token here
        },
      );
      print('${MyConstants.baseUrl}/course_api/user_data/$user');
      print('Res: $response');
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print("new data: $responseData");

        if (responseData is List) {
          // Handle the case where the response is a list
          // For example, you might want to extract data from the first item
          if (responseData.isNotEmpty) {
            final Map<String, dynamic> jsonData = responseData[0];

            // Extracting specific data
            String firstName = jsonData['firstname'] ?? '';
            String lastName = jsonData['lastname'] ?? '';
            userName = jsonData['username'];
            phoneNumber=jsonData['mobile_no'];
            // Print or use the extracted data
            print("First Name: $firstName");
            print("Last Name: $lastName");

            // Set the values to the corresponding TextEditingController
            // Rest of your code...
          }
        } else if (responseData is Map<String, dynamic>) {
          // Handle the case where the response is a map
          String firstName = responseData['firstname'] ?? '';
          String lastName = responseData['lastname'] ?? '';
          String email = responseData['email'] ?? '';
          String phoneNumber = responseData['mobile_no'] ?? '';
          user = responseData['uid'] ?? '';
          userName=responseData['username'];

          print("Email: $email");
          print("user id: $user");

          // Set the values to the corresponding TextEditingController

          // Rest of your code...
        }
        else if (responseData is int) {
          // Handle the case where the response is an unexpected integer
          print('Unexpected response format: $responseData');
          return {};
        }

      }

      throw Exception('Failed to fetch course data. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error fetching course data: $e');
      // Return an empty map or throw an exception based on your requirements
      return {};
    }
  }


  @override
  Widget build(BuildContext context) {
    int currentIndex = 2;


    Future<Map<String, dynamic>> getUsernameFromToken() async {
      // Fetch the access token from storage (assuming you have stored it)
      final storage = const FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'access_token');

      if (accessToken != null) {
        // Decode the access token to get user information
        Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);

        // Extract the username (replace 'username_key' with the actual key in your token)
        return decodedToken;
      }
      return {}; // Return an empty string if the username cannot be obtained
    }


    return Scaffold(


      body: _buildBody(currentIndex,context,getUsernameFromToken),


    );


  }


  Widget _buildBody(int currentIndex,BuildContext context,getUsernameFromToken) {
    final double screenHeight = MediaQuery.of(context).size.height;

    switch (currentIndex) {

      case 0:
        return const SingleChildScrollView(
          // Your favorites content goes here
        );

      case 1:
        return const SingleChildScrollView(
          // Your favorites content goes here
        );

      case 3:
        return const SingleChildScrollView(
          // Your favorites content goes here
        );

      case 2:
        return  Scaffold(
            bottomNavigationBar:   BottomNavigationBar(
              backgroundColor: Colors.white,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.auto_graph),
                  label: 'Trade',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Color(0xFFFAC211),
              unselectedItemColor: Colors.grey,
              onTap: _onItemTapped,
            ),
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: const BackButton(
                color: Colors.black,
              ),
              title:

              const Text('My Profile',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black
                ),),

              backgroundColor:  Colors.white,

            ),

            body:SingleChildScrollView(
                child:Container(
                  width: 1000,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                          width: 428,
                          height: 116,
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: FutureBuilder<Map<String, dynamic>>(
                              future: fetchCourseData(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return  Center(
                                    child: LoadingAnimationWidget.threeArchedCircle(
                                      color: Color(0xfffac211),
                                      size: 50,
                                    ),
                                  );
                                } else
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  // Check if the 'username' key is present
                                  bool hasUsername = snapshot.data?.containsKey('username') ?? false;

                                  // Display the username or an empty string
                                  String username = hasUsername ? snapshot.data!['username'] ?? '' : '';

                                  // Display the mobile number if available
                                  String mobileNumber = snapshot.data?['mobile_no'] ?? '';

                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _pickImage().then((pickedImage) {
                                            if (pickedImage != null) {
                                              // Handle the picked image (e.g., upload it to the server)
                                            }
                                          });
                                        },
                                        child:Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            image: _pickedImage != null
                                                ? DecorationImage(
                                              image: FileImage(_pickedImage!),
                                              fit: BoxFit.fill,
                                            )
                                                : const DecorationImage(
                                              image: AssetImage(
                                                  "assets/home/dp.png"),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userName,
                                            style: const TextStyle(
                                                color: Color(0xFF222222),
                                                fontSize: 18,
                                                fontFamily: 'SF Pro',
                                                fontWeight: FontWeight.w700,
                                                height: 0,
                                                decoration: TextDecoration.none
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            phoneNumber,
                                            style: const TextStyle(
                                                color: Color(0xA3222222),
                                                fontSize: 14,
                                                fontFamily: 'SF Pro',
                                                fontWeight: FontWeight.bold,
                                                height: 0,
                                                decoration: TextDecoration.none
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }
                              }
                          )


                      ),



                      GestureDetector(
                        onTap: () {

                        },
                        child:  Container(
                          width: 428,
                          height: screenHeight*0.9,
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Settings',
                                style: TextStyle(
                                    color: Color(0xFF222222),
                                    fontSize: 18,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.bold,
                                    height: 0,
                                    decoration: TextDecoration.none
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: screenHeight * 0.8,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditProfilePage(),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 60,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border(
                                                  bottom: BorderSide( //                   <--- right side
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                )
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  // width: 24,
                                                  // height: 24,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: const BoxDecoration(),
                                                  child: const Stack(
                                                    children: [
                                                      Positioned(
                                                        // left: 2.60,
                                                        // top: 2,
                                                        child: SizedBox(
                                                          // width: 18.80,
                                                          height: 150,
                                                          child: Stack(children: [
                                                            GradientIcon(
                                                              icon: Icons.person,
                                                              gradient:
                                                              LinearGradient(
                                                                colors: [
                                                                  Color(0xfffb8500),
                                                                  Color(0xfffac211)
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                              ),
                                                              size: 30,
                                                            )
                                                          ]),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                const Text(
                                                  'Edit Profile',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontFamily: 'SF Pro',
                                                      fontWeight: FontWeight.w400,
                                                      height: 0,
                                                      decoration:
                                                      TextDecoration.none),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Categories(
                                                    apiUrl:
                                                    'https://yamarkets.com/about-app', appbarTitle: 'About Us',),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 60,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border(
                                                  bottom: BorderSide( //                   <--- right side
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                )
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  // width: 24,
                                                  // height: 24,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: const BoxDecoration(),
                                                  child: const Stack(
                                                    children: [
                                                      Positioned(
                                                        // left: 2.60,
                                                        // top: 2,
                                                        child: SizedBox(
                                                          // width: 18.80,
                                                          height: 150,
                                                          child: Stack(children: [
                                                            GradientIcon(
                                                              icon: Icons.info,
                                                              gradient:
                                                              LinearGradient(
                                                                colors: [
                                                                  Color(0xfffb8500),
                                                                  Color(0xfffac211)
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                              ),
                                                              size: 30,
                                                            )
                                                          ]),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                const Text(
                                                  'About Us',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontFamily: 'SF Pro',
                                                      fontWeight: FontWeight.w400,
                                                      height: 0,
                                                      decoration:
                                                      TextDecoration.none),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),

                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Categories(
                                                    apiUrl:
                                                    'https://yamarkets.com/privacy-policy-app', appbarTitle: 'Privacy Policy',),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 60,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border(
                                                  bottom: BorderSide( //                   <--- right side
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                )
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  // width: 24,
                                                  // height: 24,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: const BoxDecoration(),
                                                  child: const Stack(
                                                    children: [
                                                      Positioned(
                                                        // left: 2.60,
                                                        // top: 2,
                                                        child: SizedBox(
                                                          // width: 18.80,
                                                          height: 150,
                                                          child: Stack(children: [
                                                            GradientIcon(
                                                              icon:
                                                              Icons.privacy_tip,
                                                              gradient:
                                                              LinearGradient(
                                                                colors: [
                                                                  Color(0xfffb8500),
                                                                  Color(0xfffac211)
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                              ),
                                                              size: 30,
                                                            )
                                                          ]),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                const Text(
                                                  'Privacy Policy',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontFamily: 'SF Pro',
                                                      fontWeight: FontWeight.w400,
                                                      height: 0,
                                                      decoration:
                                                      TextDecoration.none),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),

                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Categories(
                                                    apiUrl:
                                                    'https://yamarkets.com/disclaimer-app', appbarTitle: 'Disclaimer',),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 60,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border(
                                                  bottom: BorderSide( //                   <--- right side
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                )
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  // width: 24,
                                                  // height: 24,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: const BoxDecoration(),
                                                  child: const Stack(
                                                    children: [
                                                      Positioned(
                                                        // left: 2.60,
                                                        // top: 2,
                                                        child: SizedBox(
                                                          // width: 18.80,
                                                          height: 150,
                                                          child: Stack(children: [
                                                            GradientIcon(
                                                              icon: Icons.warning,
                                                              gradient:
                                                              LinearGradient(
                                                                colors: [
                                                                  Color(0xfffb8500),
                                                                  Color(0xfffac211)
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                              ),
                                                              size: 30,
                                                            )
                                                          ]),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                const Text(
                                                  'Disclaimer',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontFamily: 'SF Pro',
                                                      fontWeight: FontWeight.w400,
                                                      height: 0,
                                                      decoration:
                                                      TextDecoration.none),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            await _sendEmail();
                                          },

                                          child: Container(
                                            width: double.infinity,
                                            height: 60,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border(
                                                  bottom: BorderSide( //                   <--- right side
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                )
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  // width: 24,
                                                  // height: 24,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: const BoxDecoration(),
                                                  child: const Stack(
                                                    children: [
                                                      Positioned(
                                                        // left: 2.60,
                                                        // top: 2,
                                                        child: SizedBox(
                                                          // width: 18.80,
                                                          height: 150,
                                                          child: Stack(children: [
                                                            GradientIcon(
                                                              icon: Icons.contact_mail,
                                                              gradient:
                                                              LinearGradient(
                                                                colors: [
                                                                  Color(0xfffb8500),
                                                                  Color(0xfffac211)
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                              ),
                                                              size: 30,
                                                            )
                                                          ]),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                const Text(
                                                  'Support us',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontFamily: 'SF Pro',
                                                      fontWeight: FontWeight.w400,
                                                      height: 0,
                                                      decoration:
                                                      TextDecoration.none),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Categories(
                                                    apiUrl:
                                                    'https://yamarkets.com/refund-policy-app', appbarTitle: 'Refund Policy',),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 60,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border(
                                                  bottom: BorderSide( //                   <--- right side
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                )
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  // width: 24,
                                                  // height: 24,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: const BoxDecoration(),
                                                  child: const Stack(
                                                    children: [
                                                      Positioned(
                                                        // left: 2.60,
                                                        // top: 2,
                                                        child: SizedBox(
                                                          // width: 18.80,
                                                          height: 150,
                                                          child: Stack(children: [
                                                            GradientIcon(
                                                              icon: Icons.refresh,
                                                              gradient:
                                                              LinearGradient(
                                                                colors: [
                                                                  Color(0xfffb8500),
                                                                  Color(0xfffac211)
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                              ),
                                                              size: 30,
                                                            )
                                                          ]),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                const Text(
                                                  'Refund Policy',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontFamily: 'SF Pro',
                                                      fontWeight: FontWeight.w400,
                                                      height: 0,
                                                      decoration:
                                                      TextDecoration.none),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),

                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            clearLoginStatus();
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Login()),
                                            );
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 60,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border(
                                                  bottom: BorderSide( //                   <--- right side
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                )
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  // width: 24,
                                                  // height: 24,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: const BoxDecoration(),
                                                  child: const Stack(
                                                    children: [
                                                      Positioned(
                                                        // left: 2.60,
                                                        // top: 2,
                                                        child: SizedBox(
                                                          // width: 18.80,
                                                          height: 150,
                                                          child: Stack(children: [
                                                            GradientIcon(
                                                              icon: Icons
                                                                  .power_settings_new,
                                                              gradient:
                                                              LinearGradient(
                                                                colors: [
                                                                  Color(0xfffb8500),
                                                                  Color(0xfffac211)
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                              ),
                                                              size: 30,
                                                            )
                                                          ]),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                const Text(
                                                  'Log Out',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontFamily: 'SF Pro',
                                                      fontWeight: FontWeight.w400,
                                                      height: 0,
                                                      decoration:
                                                      TextDecoration.none),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )

            )
        );

      default:
        return Container();
    }
  }
}