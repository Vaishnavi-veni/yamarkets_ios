import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:splash_screen/screen/profile.dart';
import 'package:http/http.dart'as http;
import 'package:page_transition/page_transition.dart';
import 'package:yamarkets_ios/screens/categories.dart';

import '../../config/responsive.dart';
import '../../view/url.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
// import 'package:splash_screen/screen/web_view/demo_account.dart';
// import 'package:splash_screen/screen/web_view/prop_trade.dart';
// import 'package:splash_screen/screen/web_view/real_account.dart';
// import 'package:splash_screen/screen/web_view/trade.dart';
//
// import '../config/responive.dart';
// import '../view/url.dart';
// import 'home.dart';
class TradeMainPage extends StatefulWidget {
  const TradeMainPage({super.key, required String languageCode});

  @override
  State<TradeMainPage> createState() => _TradeMainPageState();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50); // Start from bottom-left
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50); // Circular top
    path.lineTo(size.width, 0); // Finish at top-right
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _TradeMainPageState extends State<TradeMainPage> {
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 1;
    String userName='';
    String user='';
    bool isLoading = false;

    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
        if (_selectedIndex == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(languageCode: 'en',)),
          );
        }
        if (_selectedIndex == 1) {

        }
        if (_selectedIndex == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyProfile(languageCode: 'en',)),
          );
        }
      });
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
              userName = jsonData['username'] ?? '';
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

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
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
        body:SingleChildScrollView(
            child:
            Stack(
                children: [
                  // Background image

                  // Your content
                  Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(top:30,left:25),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/home/dp.png',
                                // Change this to your image path
                                width:screenWidth * 0.15,
                              ),
                              SizedBox(width:10),
                              FutureBuilder<Map<String, dynamic>>(
                                future: fetchCourseData(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Text(
                                      'Hello,',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: screenWidth * 0.05,
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    // Check if the 'username' key is present
                                    bool hasUsername = snapshot.data?.containsKey('username') ?? false;

                                    // Display the username or an empty string
                                    String username = hasUsername ? snapshot.data!['username'] ?? '' : '';
                                    print("Username: $username");
                                    return Text(
                                      'Hello, $userName',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: screenWidth * 0.05,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight*0.08,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Yellow container with text and "Trade Now" below it
                                Container(
                                  width: screenWidth * 0.45,
                                  height: screenHeight*0.265,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(170),
                                      topRight: Radius.circular(170),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    color: Color(0xfffac211).withOpacity(0.8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 50,),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10,),
                                        child: Text(
                                          "Buy, sell, exchange assets for profit or investment.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      // Add space between text and "Trade Now"
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, PageTransition(type: PageTransitionType.scale, alignment: Alignment.topRight, child:
                                                      Categories(
                                                        apiUrl: 'https://secure.yamarkets.com/', appbarTitle: 'Trade',)));
                                        },
                                        child:
                                        Container(
                                          width: screenWidth * 0.38,
                                          height: screenHeight * 0.06,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            "Trade Now",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: screenWidth * 0.04,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                // Grey circular container positioned above the yellow box
                                Positioned(
                                  left: screenWidth * 0.1, // Adjust the left position to center the grey circle horizontally
                                  top: -25, // Adjust the top position to move the grey circle partially outside from top
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(
                                              0.1),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0,
                                              3), // changes the position of the shadow
                                        ),
                                      ],
                                    ),
                                    child:Padding(
                                      padding: EdgeInsets.only(top: 10, bottom: 10),
                                      child: Center(
                                        child: Container(
                                          width:  Responsive.isSmallScreen(context) ? screenWidth / 10 : screenWidth / 15,
                                          height: screenWidth * 0.13,
                                          child: Image.asset(
                                            "assets/trade/stock.png",
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Yellow container with text and "Trade Now" below it
                                Container(
                                  width: screenWidth * 0.45,
                                  height: screenHeight*0.265,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(170),
                                      topRight: Radius.circular(170),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    color: Color(0xfffac211).withOpacity(0.8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 50,),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10,),
                                        child: Text(
                                          "Practice trading without risk using simulated money in demos.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, PageTransition(type: PageTransitionType.scale, alignment: Alignment.topRight, child:
                                                    Categories(
                                                      apiUrl: 'https://secure.yamarkets.com/register-demo', appbarTitle: 'Demo Account',
                                                    ),));
                                        },
                                        child:// Add space between text and "Trade Now"
                                        Container(
                                          width: screenWidth * 0.38,
                                          height: screenHeight * 0.06,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            "Demo Account",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: screenWidth * 0.04,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                // Grey circular container positioned above the yellow box
                                Positioned(
                                  left: screenWidth * 0.1, // Adjust the left position to center the grey circle horizontally
                                  top: -25, // Adjust the top position to move the grey circle partially outside from top
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.white,
                                    ),
                                    child:Padding(
                                      padding: EdgeInsets.only(left: 0, top: 0, bottom: 10),
                                      child: Center(
                                        child: Container(
                                          width:  Responsive.isSmallScreen(context) ? screenWidth / 10 : screenWidth / 15,
                                          height: screenWidth * 0.13,
                                          child: Image.asset(
                                            "assets/trade/demo.png",
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 50,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Yellow container with text and "Trade Now" below it
                                Container(
                                  width: screenWidth * 0.45,
                                  height: screenHeight*0.265,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(170),
                                      topRight: Radius.circular(170),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    color: Color(0xfffac211).withOpacity(0.8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 50,),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10,),
                                        child: Text(
                                          "Actual trading account using real money for transactions.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, PageTransition(type: PageTransitionType.scale, alignment: Alignment.topRight, child:
                                                    Categories(
                                                      apiUrl: 'https://secure.yamarkets.com/register', appbarTitle: 'Real Account',
                                                    ),));
                                        },
                                        child:// Add space between text and "Trade Now"
                                        Container(
                                          width: screenWidth * 0.38,
                                          height: screenHeight * 0.06,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            "Real Account",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: screenWidth * 0.04,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                // Grey circular container positioned above the yellow box
                                Positioned(
                                  left: screenWidth * 0.1, // Adjust the left position to center the grey circle horizontally
                                  top: -25, // Adjust the top position to move the grey circle partially outside from top
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 0, top: 0, bottom: 10),
                                      child: Center(
                                        child: Container(
                                          width:  Responsive.isSmallScreen(context) ? screenWidth / 10 : screenWidth / 15,
                                          height: screenWidth * 0.13,
                                          child: Image.asset(
                                            "assets/trade/add-photo.png",
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Yellow container with text and "Trade Now" below it
                                Container(
                                  width: screenWidth * 0.45,
                                  height: screenHeight * 0.265,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(170),
                                      topRight: Radius.circular(170),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    color: Color(0xfffac211).withOpacity(0.8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 50,),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10,),
                                        child: Text(
                                          "Proprietary trading using firm's capital for investment gains.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, PageTransition(type: PageTransitionType.scale, alignment: Alignment.topRight, child:
                                                    Categories(
                                                      apiUrl: 'https://prop.yatrader.io/signup', appbarTitle: 'Prop Trade',
                                                    ),));
                                        },
                                        child:// Add space between text and "Trade Now"
                                        Container(
                                          width: screenWidth * 0.38,
                                          height: screenHeight * 0.06,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            "Prop Trade",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: screenWidth * 0.04,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                // Grey circular container positioned above the yellow box
                                Positioned(
                                  left: screenWidth * 0.1, // Adjust the left position to center the grey circle horizontally
                                  top: -25, // Adjust the top position to move the grey circle partially outside from top
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10, bottom: 10),
                                      child: Center(
                                        child: Container(
                                          width:  Responsive.isSmallScreen(context) ? screenWidth / 10 : screenWidth / 15,
                                          height: screenWidth * 0.13,
                                          child: Image.asset(
                                            "assets/trade/mobile.png",
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ]
                  )
                ]
            )
        )
    );
  }
}
