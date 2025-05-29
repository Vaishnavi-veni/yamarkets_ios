import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gradient_icon/gradient_icon.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:yamarkets_ios/screens/categories.dart';
import 'package:yamarkets_ios/screens/profile/delete.dart';
import 'dart:convert';
import 'package:page_transition/page_transition.dart';

import '../../utils/localization_utils.dart';
import '../../view/url.dart';
import '../home/home_screen.dart';
import '../login.dart';
import '../trade/trade_screen.dart';
import 'edit_profile.dart';
import 'package:yamarkets_ios/screens/home/educational_article/blog_main.dart';

import 'language.dart';

class MyProfile extends StatefulWidget {
  final String languageCode;
  const MyProfile({super.key, required this.languageCode});

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
          MaterialPageRoute(
              builder: (context) => HomePage(
                    languageCode: widget.languageCode,
                  )),
        );
      }
      if (_selectedIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlogMain(),
          ),
        );
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
  // File? _pickedImage;
  String userName = '';
  String user = '';

  @override
  void initState() {
    super.initState();
    // Initialize the controllers
    fetchCourseData();
    Localization.load(widget.languageCode); // Load the selected language
  }

  void clearLoginStatus() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('isLoggedIn');
      // Clear the access token or other user data when logging out
      storage.delete(key: 'access_token');
    });
  }

  // Future<File?> _pickImage() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile? pickedFile = await _picker.pickImage(
  //     source: ImageSource.gallery,
  //   );
  //
  //   // if (pickedFile != null) {
  //   //   setState(() {
  //   //     _pickedImage = File(pickedFile.path);
  //   //   });
  //   //   return _pickedImage!;
  //   // }
  //
  //   return null;
  // }

  Future<Map<String, dynamic>> getUsernameFromStorage() async {
    // Fetch the username and mobile number from storage
    String? username = await storage.read(key: 'username');

    // Return a map with the retrieved values
    return {
      'username': username,
    };
  }

  Future<Map<String, dynamic>> fetchCourseData() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    if (accessToken != null) {
      // Decode the access token to get user information
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);

      user = decodedToken['uid'] ?? ''; // Assu

      print('D: $decodedToken');
    }

    try {
      final response = await http.get(
        Uri.parse(
            'https://yamarketsacademy.com/api/course_api/user_data/$user'),
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
          user = responseData['uid'] ?? '';
          userName = responseData['username'];

          print("Email: $email");
          print("user id: $user");

          // Set the values to the corresponding TextEditingController

          // Rest of your code...
        } else if (responseData is int) {
          // Handle the case where the response is an unexpected integer
          print('Unexpected response format: $responseData');
          return {};
        }
      }

      throw Exception(
          'Failed to fetch course data. Status code: ${response.statusCode}');
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
      body: _buildBody(currentIndex, context, getUsernameFromToken),
    );
  }

  Widget _buildBody(
      int currentIndex, BuildContext context, getUsernameFromToken) {
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
        return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: Localization.translate('home') ?? "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.article),
                  label: Localization.translate('edu') ?? "Education Article",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: Localization.translate('profile') ?? "Profile",
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
              title: Text(
                Localization.translate('myprofile') ?? "My Profile",
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.amber,
                    ],
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
                child: Container(
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
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: LoadingAnimationWidget.threeArchedCircle(
                                  color: Color(0xfffac211),
                                  size: 50,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // Check if the 'username' key is present
                              bool hasUsername =
                                  snapshot.data?.containsKey('username') ??
                                      false;

                              // Display the username or an empty string
                              String username = hasUsername
                                  ? snapshot.data!['username'] ?? ''
                                  : '';

                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // _pickImage().then((pickedImage) {
                                      //   if (pickedImage != null) {
                                      //     // Handle the picked image (e.g., upload it to the server)
                                      //   }
                                      // });
                                    },
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        image:
                                            // _pickedImage != null
                                            //     ? DecorationImage(
                                            //   image: FileImage(_pickedImage!),
                                            //   fit: BoxFit.fill,
                                            // )
                                            //     :
                                            const DecorationImage(
                                          image: AssetImage(
                                              "assets/home/profile_human.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userName,
                                        style: const TextStyle(
                                            color: Color(0xFF222222),
                                            fontSize: 18,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w700,
                                            height: 0,
                                            decoration: TextDecoration.none),
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                  ),
                                ],
                              );
                            }
                          })),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 428,
                      height: screenHeight * 0.9,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Localization.translate('settings') ?? "Settings",
                            style: TextStyle(
                                color: Color(0xFF222222),
                                fontSize: 18,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.bold,
                                height: 0,
                                decoration: TextDecoration.none),
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
                                          PageTransition(
                                            type: PageTransitionType.scale,
                                            alignment: Alignment.bottomLeft,
                                            child: EditProfilePage(),
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
                                              bottom: BorderSide(
                                                //                   <--- right side
                                                color: Colors.grey,
                                                width: 1.0,
                                              ),
                                            )),
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
                                            Text(
                                              Localization.translate('edit') ??
                                                  "Edit Profile",
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
                                // Column(
                                //   mainAxisSize: MainAxisSize.min,
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     GestureDetector(
                                //       onTap: () {
                                //         Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //             builder: (context) => Categories(
                                //                 apiUrl:
                                //                 'https://yamarkets.com/about-app', appbarTitle: 'About Us',),
                                //           ),
                                //         );
                                //       },
                                //       child: Container(
                                //         width: double.infinity,
                                //         height: 60,
                                //         padding: const EdgeInsets.symmetric(
                                //             horizontal: 16, vertical: 10),
                                //         decoration: BoxDecoration(
                                //             color: Colors.white,
                                //             border: Border(
                                //               bottom: BorderSide( //                   <--- right side
                                //                 color: Colors.grey,
                                //                 width: 1.0,
                                //               ),
                                //             )
                                //         ),
                                //         child: Row(
                                //           mainAxisSize: MainAxisSize.min,
                                //           mainAxisAlignment:
                                //           MainAxisAlignment.start,
                                //           crossAxisAlignment:
                                //           CrossAxisAlignment.center,
                                //           children: [
                                //             Container(
                                //               // width: 24,
                                //               // height: 24,
                                //               clipBehavior: Clip.antiAlias,
                                //               decoration: const BoxDecoration(),
                                //               child: const Stack(
                                //                 children: [
                                //                   Positioned(
                                //                     // left: 2.60,
                                //                     // top: 2,
                                //                     child: SizedBox(
                                //                       // width: 18.80,
                                //                       height: 150,
                                //                       child: Stack(children: [
                                //                         GradientIcon(
                                //                           icon: Icons.info,
                                //                           gradient:
                                //                           LinearGradient(
                                //                             colors: [
                                //                               Color(0xfffb8500),
                                //                               Color(0xfffac211)
                                //                             ],
                                //                             begin: Alignment
                                //                                 .topLeft,
                                //                             end: Alignment
                                //                                 .bottomRight,
                                //                           ),
                                //                           size: 30,
                                //                         )
                                //                       ]),
                                //                     ),
                                //                   ),
                                //                 ],
                                //               ),
                                //             ),
                                //             const SizedBox(width: 12),
                                //             const Text(
                                //               'About Us',
                                //               style: TextStyle(
                                //                   color: Colors.black,
                                //                   fontSize: 20,
                                //                   fontFamily: 'SF Pro',
                                //                   fontWeight: FontWeight.w400,
                                //                   height: 0,
                                //                   decoration:
                                //                   TextDecoration.none),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //     )
                                //   ],
                                // ),

                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.scale,
                                            alignment: Alignment.bottomLeft,
                                            child: Categories(
                                              apiUrl:
                                                  'https://yamarketsacademy.com/privacy-policy-app',
                                              appbarTitle:
                                                  Localization.translate(
                                                          'privacy') ??
                                                      "Privacy Policy",
                                            ),
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
                                              bottom: BorderSide(
                                                //                   <--- right side
                                                color: Colors.grey,
                                                width: 1.0,
                                              ),
                                            )),
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
                                            Text(
                                              Localization.translate(
                                                      'privacy') ??
                                                  "Privacy Policy",
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
                                          PageTransition(
                                            type: PageTransitionType.scale,
                                            alignment: Alignment.bottomLeft,
                                            child: Categories(
                                              apiUrl:
                                                  'https://yamarketsacademy.com/disclaimer-app',
                                              appbarTitle:
                                                  Localization.translate(
                                                          'disclaimer') ??
                                                      "Disclaimer",
                                            ),
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
                                              bottom: BorderSide(
                                                //                   <--- right side
                                                color: Colors.grey,
                                                width: 1.0,
                                              ),
                                            )),
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
                                            Text(
                                              Localization.translate(
                                                      'disclaimer') ??
                                                  "Disclaimer",
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
                                // Column(
                                //   mainAxisSize: MainAxisSize.min,
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     GestureDetector(
                                //       onTap: () async {
                                //         await _sendEmail();
                                //       },
                                //
                                //       child: Container(
                                //         width: double.infinity,
                                //         height: 60,
                                //         padding: const EdgeInsets.symmetric(
                                //             horizontal: 16, vertical: 10),
                                //         decoration: BoxDecoration(
                                //             color: Colors.white,
                                //             border: Border(
                                //               bottom: BorderSide( //                   <--- right side
                                //                 color: Colors.grey,
                                //                 width: 1.0,
                                //               ),
                                //             )
                                //         ),
                                //         child: Row(
                                //           mainAxisSize: MainAxisSize.min,
                                //           mainAxisAlignment:
                                //           MainAxisAlignment.start,
                                //           crossAxisAlignment:
                                //           CrossAxisAlignment.center,
                                //           children: [
                                //             Container(
                                //               // width: 24,
                                //               // height: 24,
                                //               clipBehavior: Clip.antiAlias,
                                //               decoration: const BoxDecoration(),
                                //               child: const Stack(
                                //                 children: [
                                //                   Positioned(
                                //                     // left: 2.60,
                                //                     // top: 2,
                                //                     child: SizedBox(
                                //                       // width: 18.80,
                                //                       height: 150,
                                //                       child: Stack(children: [
                                //                         GradientIcon(
                                //                           icon: Icons.contact_mail,
                                //                           gradient:
                                //                           LinearGradient(
                                //                             colors: [
                                //                               Color(0xfffb8500),
                                //                               Color(0xfffac211)
                                //                             ],
                                //                             begin: Alignment
                                //                                 .topLeft,
                                //                             end: Alignment
                                //                                 .bottomRight,
                                //                           ),
                                //                           size: 30,
                                //                         )
                                //                       ]),
                                //                     ),
                                //                   ),
                                //                 ],
                                //               ),
                                //             ),
                                //             const SizedBox(width: 12),
                                //             const Text(
                                //               'Support us',
                                //               style: TextStyle(
                                //                   color: Colors.black,
                                //                   fontSize: 20,
                                //                   fontFamily: 'SF Pro',
                                //                   fontWeight: FontWeight.w400,
                                //                   height: 0,
                                //                   decoration:
                                //                   TextDecoration.none),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //     )
                                //   ],
                                // ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.scale,
                                            alignment: Alignment.bottomLeft,
                                            child: Categories(
                                              apiUrl:
                                                  'https://yamarketsacademy.com/refund-policy-app',
                                              appbarTitle:
                                                  Localization.translate(
                                                          'terms') ??
                                                      "Terms & Conditions",
                                            ),
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
                                              bottom: BorderSide(
                                                //                   <--- right side
                                                color: Colors.grey,
                                                width: 1.0,
                                              ),
                                            )),
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
                                                              .sticky_note_2_outlined,
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
                                            Text(
                                              Localization.translate('terms') ??
                                                  "Terms & Conditions",
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
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Languages()),
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
                                              bottom: BorderSide(
                                                //                   <--- right side
                                                color: Colors.grey,
                                                width: 1.0,
                                              ),
                                            )),
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
                                                          icon: Icons.language,
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
                                            Text(
                                              Localization.translate(
                                                      'languages') ??
                                                  'Languages',
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
                                              bottom: BorderSide(
                                                //                   <--- right side
                                                color: Colors.grey,
                                                width: 1.0,
                                              ),
                                            )),
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
                                            Text(
                                              Localization.translate(
                                                      'logout') ??
                                                  "Log Out",
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
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                Localization.translate(
                                                        'delete') ??
                                                    "Delete Account",
                                              ),
                                              content: Text(
                                                Localization.translate(
                                                        'delete_account') ??
                                                    "Are you sure you want to delete account?",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AccountDeletionPage(
                                                                languageCode: widget
                                                                    .languageCode,
                                                              )),
                                                    );
                                                  },
                                                  child: Text(
                                                    Localization.translate(
                                                            'yes') ??
                                                        "Yes",
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    Localization.translate(
                                                            'no') ??
                                                        "No",
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
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
                                              bottom: BorderSide(
                                                //                   <--- right side
                                                color: Colors.grey,
                                                width: 1.0,
                                              ),
                                            )),
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
                                                          icon: Icons.delete,
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
                                            Text(
                                              Localization.translate(
                                                      'delete') ??
                                                  "Delete Account",
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
            )));

      default:
        return Container();
    }
  }
}
