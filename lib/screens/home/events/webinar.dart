import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:yamarkets_ios/screens/home/home_screen.dart';
import 'package:yamarkets_ios/utils/localization_utils.dart';
import 'package:yamarkets_ios/view/url.dart';
import 'package:url_launcher/url_launcher.dart';
 // Add this import for date formatting

class Webinar extends StatefulWidget {
  final String languageCode;
  final String userId;

  const Webinar({Key? key, required this.languageCode, required this.userId})
      : super(key: key);

  @override
  State<Webinar> createState() => _WebinarState();
}

class _WebinarState extends State<Webinar> {
  bool isBookingDone = false;
  List<Map<String, dynamic>> courseData = [];
  final storage = FlutterSecureStorage();
  Timer? timer;
  bool isLoading = false;
  String? accessToken = '';
  String email = '';
  String phoneNumber = '';
  String name = '';
  String message = '';
  bool _dataFetched = false;
  late int webinarId;

  @override
  void initState() {
    super.initState();
    getUsernameFromToken();
    fetchCourseData();
    Localization.load(widget.languageCode); // Load the selected language
  }

  Future<bool> getUsernameFromToken() async {
    final storage = FlutterSecureStorage();
    accessToken = await storage.read(key: 'access_token');
    print("Access token3333: $accessToken");
    if (accessToken != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken!);
      print("decoded token1111111: $decodedToken");
      setState(() {
        print("set state4444");
        name = decodedToken['username'] ?? '';
        email = decodedToken['email'] ?? '';
        phoneNumber = decodedToken['mobile_no'] ?? '';
        _dataFetched = true;
        // userid = decodedToken['uid'];
        // print("User id llllll$userid");
      });
      // print("User id 2222$userid");

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

  void _handleSubmit(int selectedId) async {
    Map<String, dynamic> requestBody = {
      'user_id': widget.userId,
      'webi_id': selectedId.toString(), // Pass the selectedId here
      'name': name,
      'email': email,
      'mobile': phoneNumber,
      'country': "country",
    };
    print("Request body5555:$requestBody");

    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    Map<String, String> headers = {
      'Authorization': '$accessToken',
    };

    try {
      http.Response response = await http.post(
        Uri.parse('https://yamarketsacademy.com/api/course_api/book_webinar'),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        print('Form submitted successfully, ${response.body}');
        print("Selected id for webinar:$selectedId");
        _updateStatus(selectedId, 'booked');

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text(
                "Form submitted successfully!",
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Webinar(
                                languageCode: widget.languageCode,
                                userId: widget.userId,
                              )),
                    );
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
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
          print("Webinar: $jsonData");
          if (jsonData is List &&
              jsonData.isNotEmpty &&
              jsonData[0] is Map<String, dynamic>) {
            setState(() {
              courseData =
                  jsonData.cast<Map<String, dynamic>>().where((course) {
                String courseDateStr = course['date'];
                DateTime courseDate =
                    DateFormat('yyyy-MM-dd').parse(courseDateStr);
                DateTime currentDate = DateTime.now();

                // Compare the course date with the current date
                return courseDate.isAfter(currentDate) ||
                    courseDate.isAtSameMomentAs(currentDate);
              }).map((course) {
                course['isBooked'] = false;
                message = course['mail_meaasage'];
                course['zoomLink'] = extractZoomLink(message);
                print(
                    "messageeeeee:${extractZoomLink(message)}"); // Initialize isBooked to false
                return course;
              }).toList();
            });
            for (var i = 0; i < courseData.length; i++) {
              webinarId = int.parse(courseData[i]['id'].toString());
              await fetchBookData(
                  webinarId, i); // Pass index to update specific course item
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

  Future<void> fetchBookData(int webinarId, int index,
      {bool refresh = false}) async {
    String? accessToken = await storage.read(key: 'access_token');
    try {
      final response = await http.get(
        Uri.parse(
            '${MyConstants.baseUrl}/course_api/booked_data/$webinarId/${widget.userId}'),
        headers: {
          'Authorization': '$accessToken',
        },
      );
      print(
          'API URL: ${MyConstants.baseUrl}/course_api/booked_data/$webinarId/${widget.userId}');
      print('Book data response: ${response.statusCode} ${response.body}');
      print("api prior");

      final jsonData = json.decode(response.body);
      print("api working");
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
      // } else {
      //   handleErrorResponse(response);
      // }
    } catch (e) {
      print('Error fetching booking data: $e');
    }
  }

  void _updateStatus(int id, String status) {
    print("status of courts ${status}");
    setState(() {
      for (var i = 0; i < courseData.length; i++) {
        if (courseData[i]['id'] == id.toString()) {
          courseData[i]['status'] = status;
          print("Update status: ${courseData[i]}");
          break;
        }
      }
    });
  }

  String extractZoomLink(String mailMessage) {
    final zoomLinkPattern =
        RegExp(r'https://us06web\.zoom\.us/j/\d+\?pwd=[\w\d]+');
    final match = zoomLinkPattern.firstMatch(mailMessage);
    return match != null ? match.group(0)! : '';
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(languageCode: widget.languageCode)));
    return false; // Return false to prevent the default back behavior
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: OrientationBuilder(builder: (context, orientation) {
        final bool isLandscape = orientation == Orientation.landscape;
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
        return Scaffold(
          appBar: AppBar(
 flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.amber,
              ],
            ),
          ),
        ),            title: Text(
              Localization.translate('webinar') ?? 'Webinar',
              style: TextStyle(color: Colors.black),
            ),
            leading: BackButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomePage(languageCode: widget.languageCode)));
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
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: courseData.length,
                  itemBuilder: (context, index) {
                    final course = courseData[index];

                    // Assuming the date is stored as a string in 'yyyy-MM-dd' format
                    String originalDateStr = courseData[index]['date'];
                    String originalTimeStr = course['time']; // 'HH:mm'

                    DateTime webinarDateTime = DateFormat('yyyy-MM-dd HH:mm')
                        .parse('$originalDateStr $originalTimeStr');

                    DateTime currentTime = DateTime.now();
                    print("Time : $currentTime");

                    Duration difference =
                        webinarDateTime.difference(currentTime);

                    print("Difference:$difference");

                    // Parse the original date string
                    DateTime parsedDate =
                        DateFormat('yyyy-MM-dd').parse(originalDateStr);

                    // Format the date to 'dd-MM-yyyy'
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(parsedDate);

                    bool isBooked = course['isBooked'] ?? false;

                    Widget actionButton;
                    if (!isBooked) {
                      // If not booked, show "Book Slot"
                      actionButton = GestureDetector(
                        onTap: () {
                          if (course != null && course.containsKey('id')) {
                            int selectedId = int.parse(course['id']);

                            // Show confirmation dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Slot Booking'),
                                  content: Text(
                                    'Do you want to book this webinar slot?',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        // Close the dialog without doing anything
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // Proceed with booking logic if the user confirms
                                        Navigator.of(context)
                                            .pop(); // Close the dialog

                                        // Call the _handleSubmit with selectedId
                                        _handleSubmit(selectedId);
                                      },
                                      child: Text('Confirm'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: _buildButton(
                          text: Localization.translate('book_slot') ??
                              'Book Slot',
                          color: Color(0xfffac211),
                          isLandscape: isLandscape,
                          screenWidth: screenWidth,
                        ),
                      );
                    } else if (isBooked && difference <= Duration(hours: 1)) {
                      // If booked and within 1 hour of the webinar, show "Join Now"
                      actionButton = GestureDetector(
                        onTap: () {
                          _launchURL(course['zoomLink']);
                        },
                        child: _buildButton(
                          text: Localization.translate('join') ?? 'Join Now',
                          color: Color(0xfffac211),
                          isLandscape: isLandscape,
                          screenWidth: screenWidth,
                        ),
                      );
                    } else {
                      // If booked but not within 1 hour, show "Booked"
                      actionButton = _buildButton(
                        text: Localization.translate('booked') ?? 'Booked',
                        color: Colors.grey.shade400,
                        isLandscape: isLandscape,
                        screenWidth: screenWidth,
                      );
                    }

                    return Padding(
                      padding: EdgeInsets.only(
                        top: isLandscape
                            ? screenWidth * 0.01
                            : screenWidth * 0.03,
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
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              // Date and Time Row
                              _buildDateTimeRow(
                                formattedDate: formattedDate,
                                time: course['time'],
                                isLandscape: isLandscape,
                                screenWidth: screenWidth,
                              ),
                              // Webinar Topic
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 10,
                                  left: 10,
                                  right: 10,
                                  bottom: 10,
                                ),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    course['topic'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: isLandscape
                                          ? screenWidth * 0.025
                                          : screenWidth * 0.05,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              // Speaker Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildSpeakerRow(
                                    speaker: course['speaker'],
                                    screenHeight: screenHeight,
                                    screenWidth: screenWidth,
                                    isLandscape: isLandscape,
                                  ),
                                  // Action Button (Book Slot, Join Now, or Booked)
                                  actionButton,
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      }),
    );
  }

  Widget _buildButton(
      {required String text,
      required Color color,
      required bool isLandscape,
      required double screenWidth}) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
        color: color,
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
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: isLandscape ? screenWidth * 0.025 : screenWidth * 0.04,
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeRow({
    required String formattedDate,
    required String time,
    required bool isLandscape,
    required double screenWidth,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month),
              SizedBox(width: 10),
              Text(
                formattedDate,
                style: TextStyle(
                  color: Colors.black,
                  fontSize:
                      isLandscape ? screenWidth * 0.025 : screenWidth * 0.03,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.timer_outlined),
              SizedBox(width: 10),
              Text(
                time,
                style: TextStyle(
                  color: Colors.black,
                  fontSize:
                      isLandscape ? screenWidth * 0.025 : screenWidth * 0.03,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakerRow({
    required String speaker,
    required double screenHeight,
    required double screenWidth,
    required bool isLandscape,
  }) {
    return Row(
      children: [
        Container(
          height: screenHeight * 0.03,
          padding: EdgeInsets.only(left: screenWidth * 0.02, right: 5),
          child: Icon(Icons.volume_up),
        ),
        Container(
          height: screenHeight * 0.03,
          padding: EdgeInsets.only(right: 10),
          child: Text(
            speaker,
            style: TextStyle(
              color: Colors.black,
              fontSize: isLandscape ? screenWidth * 0.025 : screenWidth * 0.04,
            ),
          ),
        ),
      ],
    );
  }
}
