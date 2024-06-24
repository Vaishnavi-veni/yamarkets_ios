import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:yamarkets_ios/screens/home/events/webinar_form.dart';

import '../../../view/url.dart';
import '../home_screen.dart';
// import 'package:splash_screen/screen/events/webinar_form.dart';
// import 'package:splash_screen/screen/home.dart';
// import '../../view/url.dart';
// import '../login.dart';

class Webinar extends StatefulWidget {
  const Webinar({Key? key}) : super(key: key);

  @override
  State<Webinar> createState() => _WebinarState();
}

class _WebinarState extends State<Webinar> {
  List<Map<String, dynamic>> courseData = [];
  final storage = FlutterSecureStorage();
  Timer? timer;
  bool isLoading = false;
  String userid = '';

  @override
  void initState() {
    super.initState();
    fetchCourseData();
    getUsernameFromToken();
  }

  Future<bool> getUsernameFromToken() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    if (accessToken != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
      setState(() {
        userid = decodedToken['uid'];
      });
      return true;
    } else {
      return false;
    }
  }

  void clearLoginStatus() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('isLoggedIn');
      storage.delete(key: 'access_token');
    });
  }

  Future<void> fetchCourseData({bool refresh = false}) async {
    if (!isLoading || refresh) {
      setState(() {
        isLoading = true;
      });
      String? accessToken = await storage.read(key: 'access_token');
      try {
        final response = await http.get(
          Uri.parse('${MyConstants.baseUrl}/course_api/webinar'),
          headers: {
            'Authorization': '$accessToken',
          },
        );
        if (response.statusCode == 200) {
          final List<dynamic> jsonData = json.decode(response.body);
          if (jsonData is List && jsonData.isNotEmpty && jsonData[0] is Map<String, dynamic>) {
            setState(() {
              courseData = jsonData.cast<Map<String, dynamic>>().map((course) {
                course['isBooked'] = false; // Initialize isBooked to false
                return course;
              }).toList();
            });
            for (var i = 0; i < courseData.length; i++) {
              int webinarId = int.parse(courseData[i]['id'].toString());
              await fetchBookData(webinarId, i); // Pass index to update specific course item
            }
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
  }

  void handleErrorResponse(http.Response response) {
    final Map<String, dynamic> errorResponse = json.decode(response.body);
    final status = errorResponse['status'];
    final message = errorResponse['message'];
    print('Error: $status, Message: $message');
    clearLoginStatus();

    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> fetchBookData(int webinarId, int index, {bool refresh = false}) async {
    String? accessToken = await storage.read(key: 'access_token');
    try {
      final response = await http.get(
        Uri.parse('${MyConstants.baseUrl}/course_api/booked_data/$webinarId/$userid'),
        headers: {
          'Authorization': '$accessToken',
        },
      );
      print('API URL: ${MyConstants.baseUrl}/course_api/booked_data/$webinarId/$userid');
      print('Book data response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        print("Json book:$jsonData");
        if (jsonData is List && jsonData.isNotEmpty) {
          setState(() {
            courseData[index]['isBooked'] = true;
          });
        } else if (jsonData is int) {
          setState(() {
            courseData[index]['isBooked'] = false;
          });
        } else {
          setState(() {
            courseData[index]['isBooked'] = false;
          });
        }
      } else {
        handleErrorResponse(response);
      }
    } catch (e) {
      print('Error fetching booking data: $e');
    }
  }

  void _updateStatus(int id, String status) {
    setState(() {
      for (var i = 0; i < courseData.length; i++) {
        if (courseData[i]['id'] == id.toString()) {
          courseData[i]['status'] = status;
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      final bool isLandscape = orientation == Orientation.landscape;
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Webinar",
            style: TextStyle(color: Colors.black),
          ),
          leading: BackButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            color: Colors.black,
          ),
        ),
        body: isLoading
            ? Center(
          child: LoadingAnimationWidget.threeArchedCircle(
            color: Color(0xfffac211),
            size: 50,
          ),
        )
            :
        ListView.builder(
          shrinkWrap: true,
          itemCount: courseData.length,
          itemBuilder: (context, index) {
            final course = courseData[index];
            return Padding(
              padding: EdgeInsets.only(
                top: isLandscape ? screenWidth * 0.01 : screenWidth * 0.03,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                bottom: screenWidth * 0.03,
              ),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  width: screenWidth * 0.9,
                  child: Padding(padding: EdgeInsets.all(10),
                    child:
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: isLandscape ? screenWidth * 0.01 : screenWidth * 0.05,
                            // left: screenWidth * 0.005,
                          ),
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 10, left: 10, bottom: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_month),
                                      SizedBox(width: 10),
                                      Text(
                                        courseData[index]['date'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: isLandscape
                                                ? screenWidth * 0.025
                                                : screenWidth * 0.03,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.timer_outlined),
                                      SizedBox(width: 10),
                                      Text(
                                        courseData[index]['time'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: isLandscape
                                                ? screenWidth * 0.025
                                                : screenWidth * 0.03,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 10),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              courseData[index]['topic'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: isLandscape
                                      ? screenWidth * 0.025
                                      : screenWidth * 0.05,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: screenHeight * 0.03,
                                  padding: EdgeInsets.only(
                                    // top: 10,
                                      left: screenWidth * 0.02,
                                      right: 5,
                                      bottom: 0),
                                  child:
                                  Icon(Icons.volume_up),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: screenHeight * 0.046,
                                      padding: EdgeInsets.only(
                                          right: 10,
                                          bottom: 0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          courseData[index]['speaker'],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: isLandscape
                                                ? screenWidth * 0.025
                                                : screenWidth * 0.04,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            course['isBooked'] ?
                            Container(
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Booked',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: isLandscape
                                        ? screenWidth * 0.025
                                        : screenWidth * 0.04,
                                  ),
                                ),
                              ),
                            )
                                :GestureDetector(
                              onTap: () {
                                if (course != null &&
                                    course.containsKey('id')) {
                                  int selectedId =
                                  int.parse(course['id']);
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.fade,
                                        child: WebinarForm(
                                          id: selectedId,
                                          onUpdateStatus: _updateStatus,
                                        ),
                                      ));
                                }
                              },
                              child: Container(
                                margin:  EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  color: Color(0xfffac211),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Book Slot ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: isLandscape
                                          ? screenWidth * 0.025
                                          : screenWidth * 0.04,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
              ),
            );
          },
        ),
      );
    });
  }
}
