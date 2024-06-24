import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:lottie/lottie.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:splash_screen/config/responsive.dart';
// import 'package:splash_screen/screen/basics/benefits_of_trading_Forex.dart';
// import 'package:splash_screen/screen/basics/forex_market_history.dart';
// import 'package:splash_screen/screen/basics/trading_strategies_forex.dart';
// import 'package:splash_screen/screen/basics/what_is_forex.dart';
// import 'package:splash_screen/screen/calender.dart';
// import 'package:splash_screen/screen/events/webinar.dart';
// import 'package:splash_screen/screen/ideas.dart';
// import 'package:splash_screen/screen/slider.dart';
// import 'package:splash_screen/screen/trade.dart';
// import 'package:splash_screen/screen/video_series.dart';
// import 'package:splash_screen/screen/web_tv.dart';
// import 'package:splash_screen/screen/web_view/demo_account.dart';
// import 'package:splash_screen/screen/web_view/prop_trade.dart';
// import 'package:splash_screen/screen/web_view/real_account.dart';
// import 'package:splash_screen/screen/web_view/trade.dart';
// import 'package:video_player/video_player.dart';
// import 'package:splash_screen/screen/profile.dart';
//
// import 'events/webinar_form.dart';
// import 'insights.dart';
// import 'introduction.dart';
// import 'news.dart';
import 'package:http/http.dart' as http;
import 'package:yamarkets_ios/screens/home/educational_article/blog_main.dart';
import 'package:yamarkets_ios/view/url.dart';

import '../categories.dart';
import '../profile/profile_screen.dart';
import '../trade/trade_screen.dart';
import 'educational_article/blog.dart';
import 'educational_videos/video_series.dart';
import 'events/webinar.dart';
import 'imageslider.dart';
import 'package:html/parser.dart' show parse;

// import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late VideoPlayerController _controller;

  int _selectedIndex = 0;
  String userName = '';
  String? UserName = '';
  String user = '';
  final storage = FlutterSecureStorage();
  String selectedFilter = '';

  List<Map<String, dynamic>> courseData = [];
  bool isLoading = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomePage()),
        // );
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyProfile()),
        );
      }
    });
  }

  int _backButtonCount = 0;

  void _showSnackBarOrCloseApp() {
    if (_backButtonCount == 1) {
      // Show Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Press back again to exit')),
      );
    } else if (_backButtonCount == 2) {
      // Close the application
      SystemNavigator.pop(); // Close the entire application
    }
  }

  void _handleBackButtonClicked() {
    // Increment back button count
    _backButtonCount++;

    // Show snackbar or close app based on count
    _showSnackBarOrCloseApp();
  }

  void _handleOtherButtonClicked() {
    // Reset back button count
    _backButtonCount = 0;
  }

  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.network(
    //     'https://api.dyntube.com/v1/apps/hls/ewyyU2lA0fSfl5lZiRQ.m3u8')
    //   ..initialize().then((_) {
    //     setState(() {});
    //   });
    fetchCourseData();
    BlogData();
    _loadUserDetails();
  }

  @override
  void dispose() {
    super.dispose();
    // _controller.dispose();
  }

  Future<Map<String, dynamic>> fetchCourseData() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    if (accessToken != null) {
      // Decode the access token to get user information
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);

      user = decodedToken['uid'] ?? ''; // Assu

      print('User id: $user');
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
          String phoneNumber = responseData['mobile_no'] ?? '';
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

  Future<void> BlogData() async {
    setState(() {
      isLoading = true;
    });
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    try {
      final response = await http.get(
        Uri.parse('${MyConstants.baseUrl}/course_api/blog'),
        headers: {
          'Authorization': '$accessToken',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print("Json Data:$jsonData");
        if (jsonData is List &&
            jsonData.isNotEmpty &&
            jsonData[0] is Map<String, dynamic>) {
          setState(() {
            courseData = jsonData.cast<Map<String, dynamic>>();
          });
        } else {
          handleErrorResponse(response);
        }
      } else {
        handleErrorResponse(response);
      }
    } catch (e) {
      print('Error fetching course data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleErrorResponse(http.Response response) {
    final Map<String, dynamic> errorResponse = json.decode(response.body);
    final status = errorResponse['status'];
    final message = errorResponse['message'];
    print('Error: $status, Message: $message');
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      UserName = prefs.getString('userName');
    });
  }

  String getShortDescription(String description) {
    final document = parse(description);
    final String parsedString = parse(document.body!.text).documentElement!.text;
    List<String> words = parsedString.split(' ');
    if (words.length > 10) {
      return words.take(3).join(' ') + '...';
    }
    return parsedString;
  }
  String getShortName(String description) {
    List<String> words = description.split(' ');
    if (words.length > 9) {
      return words.take(8).join(' ') + '...';
    }
    return description;
  }
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      int _selectedTabIndex = 0;
      List<bool> _selections = [true, false, false];

      List<String> buttonInfo = [
        "Button 1 Info",
        "Button 2 Info",
        "Button 3 Info",
      ];

      courseData.sort((a, b) {
        DateTime dateA = DateFormat('yyyy-MM-dd').parse(a['date']);
        DateTime dateB = DateFormat('yyyy-MM-dd').parse(b['date']);
        return dateB.compareTo(dateA); // Sort in descending order
      });

      final bool isLandscape = orientation == Orientation.landscape;
      double screenHeight = MediaQuery.of(context).size.height;
      double screenWidth = MediaQuery.of(context).size.width;
      return WillPopScope(
        // Return false to disable the back button
          onWillPop: () async {
            _handleBackButtonClicked();

            // Prevent default back button behavior
            return false;
          },
          child: Scaffold(
              backgroundColor: Colors.white,
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.white,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.article),
                    label: 'Article',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
                selectedItemColor: Color(0xFFFAC211),
                unselectedItemColor: Colors.grey,
                onTap: _onItemTapped,
              ),
              body: SingleChildScrollView(
                child: Stack(
                  children: [
                    // Background image

                    // Your content
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(top: 30, left: 25),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/home/dp.png',
                                // Change this to your image path
                                width: isLandscape
                                    ? screenWidth * 0.1
                                    : screenWidth * 0.17,
                              ),
                              SizedBox(width: 10),
                              FutureBuilder<Map<String, dynamic>>(
                                future: fetchCourseData(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
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
                                    bool hasUsername = snapshot.data
                                        ?.containsKey('username') ??
                                        false;

                                    // Display the username or an empty string
                                    String username = hasUsername
                                        ? snapshot.data!['username'] ?? ''
                                        : '';
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

                        SizedBox(
                          height: screenHeight * 0.03,
                        ),

                        Container(
                            height: isLandscape
                                ? screenHeight * 0.5
                                : screenHeight * 0.25,
                            width: isLandscape
                                ? screenWidth * 0.8
                                : screenWidth * 0.9,
                            child: ImageSlider()),

                        SizedBox(height: screenHeight * 0.02),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Categories",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: isLandscape
                                      ? screenWidth * 0.04
                                      : screenWidth * 0.055,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.02),
                                    child: GestureDetector(
                                      onTap: () {
                                        _handleOtherButtonClicked();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Categories(appbarTitle:'Introduction',apiUrl:'https://yamarketsacademy.com/api/course_api/introduction_api/$user',),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [

                                          Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xfffac211)
                                                  .withOpacity(0.2),
                                              borderRadius:
                                              BorderRadius.circular(12),
                                            ),
                                            width: isLandscape
                                                ? screenWidth * 0.2
                                                : screenWidth * 0.27,
                                            height: isLandscape
                                                ? screenWidth * 0.2
                                                : screenWidth * 0.27,
                                            child: Center(
                                              child: Container(
                                                  width: screenWidth * 0.19,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Image.asset(
                                                        "assets/home/categories/intro_yellow.png",
                                                        fit: BoxFit.contain,
                                                      ),
                                                      Text(
                                                        "Introduction",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: isLandscape
                                                                ? screenWidth *
                                                                0.03
                                                                : screenWidth *
                                                                0.03,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500),
                                                      )
                                                    ],
                                                  )),
                                            ),
                                          ),

                                          SizedBox(
                                              height: screenHeight * 0.015),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.02),
                                      child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Categories(appbarTitle:'Insights',apiUrl: 'https://yamarketsacademy.com/api/course_api/insights_api/$user'),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.indigo
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                  BorderRadius.circular(12),
                                                ),
                                                width: isLandscape
                                                    ? screenWidth * 0.2
                                                    : screenWidth * 0.27,
                                                height: isLandscape
                                                    ? screenWidth * 0.2
                                                    : screenWidth * 0.27,
                                                child: Center(
                                                  child: Container(
                                                      width: screenWidth * 0.19,
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Image.asset(
                                                            "assets/home/categories/insights_indigo.png",
                                                            fit: BoxFit.contain,
                                                          ),
                                                          Text(
                                                            "Insights",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: isLandscape
                                                                    ? screenWidth *
                                                                    0.03
                                                                    : screenWidth *
                                                                    0.03,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.015,
                                              ),
                                            ],
                                          ))),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.02),
                                      child: GestureDetector(
                                          onTap: () {
                                            _handleOtherButtonClicked();

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Categories(appbarTitle: 'Calendar',apiUrl: 'https://yamarketsacademy.com/api/course_api/financialnews_api/$user',),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.blue
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                  BorderRadius.circular(12),
                                                ),
                                                width: isLandscape
                                                    ? screenWidth * 0.2
                                                    : screenWidth * 0.27,
                                                height: isLandscape
                                                    ? screenWidth * 0.2
                                                    : screenWidth * 0.27,
                                                child: Center(
                                                  child: Container(
                                                      width: screenWidth * 0.19,
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Image.asset(
                                                            "assets/home/categories/calendar_blue.png",
                                                            fit: BoxFit.contain,
                                                          ),
                                                          Text(
                                                            "Calendar",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: isLandscape
                                                                    ? screenWidth *
                                                                    0.03
                                                                    : screenWidth *
                                                                    0.03,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.015,
                                              ),
                                            ],
                                          ))),
                                  SizedBox(height: screenHeight * 0.01),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.02),
                                          child: GestureDetector(
                                              onTap: () {
                                                _handleOtherButtonClicked();

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Categories(apiUrl: 'https://yamarketsacademy.com/api/course_api/refinedtechnicals_api/$user', appbarTitle: 'Feature Ideas'),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.green
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          12),
                                                    ),
                                                    width: isLandscape
                                                        ? screenWidth * 0.2
                                                        : screenWidth * 0.27,
                                                    height: isLandscape
                                                        ? screenWidth * 0.2
                                                        : screenWidth * 0.27,
                                                    child: Center(
                                                      child: Container(
                                                          width: screenWidth *
                                                              0.19,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Image.asset(
                                                                "assets/home/categories/bulb-removebg-preview.png",
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                              Text(
                                                                "Ideas",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: isLandscape
                                                                        ? screenWidth *
                                                                        0.03
                                                                        : screenWidth *
                                                                        0.03,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              )
                                                            ],
                                                          )),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                    screenHeight * 0.015,
                                                  ),
                                                ],
                                              ))),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.02),
                                          child: GestureDetector(
                                              onTap: () {
                                                _handleOtherButtonClicked();

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Categories(apiUrl: 'https://iframe.dacast.com/playlist/7229776f9656c6b83137ccbac35f8fe6/08e45fc9-0b25-919d-b8d5-c19b3c35db7e', appbarTitle: 'Web TV'),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.orange
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          12),
                                                    ),
                                                    width: isLandscape
                                                        ? screenWidth * 0.2
                                                        : screenWidth * 0.27,
                                                    height: isLandscape
                                                        ? screenWidth * 0.2
                                                        : screenWidth * 0.27,
                                                    child: Center(
                                                      child: Container(
                                                          width: screenWidth *
                                                              0.19,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Image.asset(
                                                                "assets/home/categories/web_tv-removebg-preview.png",
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                              ),
                                                              Text(
                                                                "Web TV",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: isLandscape
                                                                        ? screenWidth *
                                                                        0.03
                                                                        : screenWidth *
                                                                        0.03,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              )
                                                            ],
                                                          )),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                    screenHeight * 0.015,
                                                  ),
                                                ],
                                              ))),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.02),
                                          child: GestureDetector(
                                              onTap: () {
                                                _handleOtherButtonClicked();

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Categories(apiUrl: 'https://videos.dyntube.com/iframes/channels/8VlK9M6nUKVcOEjQ9jm5w', appbarTitle: 'News'),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.red
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          12),
                                                    ),
                                                    width: isLandscape
                                                        ? screenWidth * 0.2
                                                        : screenWidth * 0.27,
                                                    height: isLandscape
                                                        ? screenWidth * 0.2
                                                        : screenWidth * 0.27,
                                                    child: Center(
                                                      child: Container(
                                                          width: screenWidth *
                                                              0.19,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Image.asset(
                                                                "assets/home/categories/news_red1.png",
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                              Text(
                                                                "News",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: isLandscape
                                                                        ? screenWidth *
                                                                        0.03
                                                                        : screenWidth *
                                                                        0.03,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              )
                                                            ],
                                                          )),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                    screenHeight * 0.015,
                                                  ),
                                                ],
                                              ))),
                                    ],
                                  ),
                                ],
                              ),
                            )),

                        SizedBox(height: screenHeight * 0.02),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            "Events",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: isLandscape
                                  ? screenWidth * 0.04
                                  : screenWidth * 0.055,
                            ),
                          ),
                        ),



                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Webinar(),
                              ),
                            );
                          },
                          child: Container(
                            width: screenWidth * 0.9,
                            height: screenHeight * 0.12,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                // SizedBox(width: screenWidth * 0.0,),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Container(
                                    width: isLandscape
                                        ? screenWidth * 0.17
                                        : screenWidth * 0.4,
                                    height: isLandscape
                                        ? screenHeight * 0.25
                                        : screenWidth * 0.35,
                                    child: Image.asset(
                                      'assets/home/events/webinar1-removebg-preview.png',
                                      // fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.02,
                                ),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          child: Text(
                                            "Webinar",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: isLandscape
                                                    ? screenWidth * 0.04
                                                    : screenWidth * 0.05,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const Text(
                                          "Join our live, interactive webinar.",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 15,
                                          ),
                                          // fontSize: screenWidth * 0.04,
                                          // color: Colors.black54,
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Coming soon!"),
                                  content: Text(
                                    "Trading Seminars and Workshops for Traders",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            // margin: EdgeInsets.symmetric(horizontal: 20),
                            // color: Colors.white,
                            width: screenWidth * 0.9,
                            height: screenHeight * 0.12,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                // SizedBox(width: screenWidth * 0.0,),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Container(
                                    width: isLandscape
                                        ? screenWidth * 0.17
                                        : screenWidth * 0.4,
                                    height: isLandscape
                                        ? screenHeight * 0.25
                                        : screenWidth * 0.35,
                                    child: Image.asset(
                                      'assets/home/events/s-removebg-preview.png',
                                      // fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.02,
                                ),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          child: Text(
                                            "Seminar",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: isLandscape
                                                    ? screenWidth * 0.04
                                                    : screenWidth * 0.05,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const Text(
                                          "YaMarkets places attention on training.",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 15,
                                          ),
                                          // fontSize: screenWidth * 0.04,
                                          // color: Colors.black54,
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: screenHeight * 0.02,
                        ),

                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Coming soon!"),
                                  content: Text(
                                    "#SikhoPhirTradeKaro \nA ONE DAY FINANCIAL EDUCATION WORKSHOP",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            width: screenWidth * 0.9,
                            height: screenHeight * 0.12,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                // SizedBox(width: screenWidth * 0.0,),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Container(
                                    width: isLandscape
                                        ? screenWidth * 0.17
                                        : screenWidth * 0.4,
                                    height: isLandscape
                                        ? screenHeight * 0.25
                                        : screenWidth * 0.35,
                                    child: Image.asset(
                                      'assets/home/events/education-removebg-preview.png',

                                      // fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.02,
                                ),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          child: Text(
                                            "Workshop",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: isLandscape
                                                    ? screenWidth * 0.04
                                                    : screenWidth * 0.05,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const Text(
                                          "Provides training on currency trading.",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 15,
                                          ),
                                          // fontSize: 15.0,
                                          // color: Colors.black54,
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: screenHeight * 0.02,
                        ),

                        Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(left: 25, top: 10),
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Educational Video",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: screenWidth * 0.055),
                                  ),
                                )),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => VideoSeries()),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(2, 2),
                                      color: Colors.grey,
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                ),
                                width: screenWidth * 0.9,
                                height: screenHeight * 0.2,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Image.asset(
                                    'assets/home/vector242-01.png',
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ) ,
                            )


                          ],
                        ),

                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(left: 25, top: 10,right: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Educational Article",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: screenWidth * 0.055),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BlogMain(),
                                          ),
                                        );//
                                      },
                                      child:  Text(
                                        "See all",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                            fontSize: screenWidth * 0.03),
                                      ),
                                    )

                                  ],
                                )
                               ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            GestureDetector(
                              onTap: () {

                              },
                              child: isLoading
                                  ? Center(child: LoadingAnimationWidget.threeArchedCircle(
                                color: Color(0xfffac211),
                                size: 50,
                              ),)
                                  : Container(
                                height: screenHeight * 0.26,  // Adjust the height as needed

                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: courseData.length,
                                  itemBuilder: (context, index) {
                                    final course = courseData[index];
                                    final imageUrl = 'https://yamarkets.com/images/${course['image']}';
                                    print('Loading image: $imageUrl');
                                    return Padding(
                                      padding: EdgeInsets.only(left: screenWidth * 0.05, bottom: 10),
                                      child: Container(
                                        width: screenWidth * 0.6,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(2, 2),
                                              color: Colors.grey,
                                              blurRadius: 5.0,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: imageUrl,
                                                height: screenHeight * 0.15,  // Adjust the height as needed
                                                width: double.infinity,
                                                fit: BoxFit.fill,
                                                placeholder: (context, url) => Center(child: LoadingAnimationWidget.threeArchedCircle(
                                                  color: Color(0xfffac211),
                                                  size: 50,
                                                ),),
                                                errorWidget: (context, url, error) {
                                                  print('Failed to load image: $url');
                                                  return Center(child: Icon(Icons.error));
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left:screenWidth * 0.03,top:screenWidth * 0.03),
                                              child:Container(
                                                // height:screenHeight*0.05 ,
                                    alignment:Alignment.topLeft,
                                    child:Text(
                                      getShortName(course['blog_name'] ?? 'No Title'),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                    )
                                              ,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: screenWidth * 0.01, left: screenWidth * 0.03),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Icon(Icons.calendar_month, color: Color(0xfffac211)),
                                                      SizedBox(width: screenWidth * 0.02),
                                                      Text(
                                                        DateFormat('dd-MM-yy').format(DateFormat('yyyy-MM-dd').parse(course['date'])),
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          color: Color(0xfffac211),
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(

                                                          builder: (context) => BlogPage(blogId: course['id']),
                                                        ),
                                                      );// Handle the tap event here
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right: 17.0),
                                                      child: Container(
                                                        height: screenWidth * 0.05,
                                                        width: screenWidth * 0.05,
                                                        decoration: BoxDecoration(
                                                          color: Color(0xfffac211),
                                                          borderRadius: BorderRadius.circular(50),
                                                        ),
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.arrow_forward_ios,
                                                            color: Colors.white,
                                                            size: screenWidth * 0.03,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                            ),




                          ],
                        ),


                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                      ],
                    )
                  ],
                ),
              )));
    });
  }

  Widget buildFilterChip(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selectedFilter == label ? Color(0xfffac211) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 5, // Spread radius
              blurRadius: 7, // Blur radius
              offset: Offset(6, 6), // Offset
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selectedFilter == label ? Colors.white : Color(0xfffac211),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final double fontSize;
  final Color color;

  ExpandableText({
    required this.text,
    required this.fontSize,
    required this.color,
  });

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _expanded = !_expanded;
        });
      },
      child: Text(
        _expanded ? widget.text : _getTrimmedText(),
        style: TextStyle(
          color: widget.color,
          fontSize: widget.fontSize,
        ),
      ),
    );
  }

  String _getTrimmedText() {
    final int maxLength = 50;
    if (widget.text.length <= maxLength) {
      return widget.text;
    } else {
      return widget.text.substring(0, maxLength) + '...';
    }
  }
}
