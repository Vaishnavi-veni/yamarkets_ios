import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'video.dart';

class VideoSeries extends StatefulWidget {
  const VideoSeries({super.key});

  @override
  State<VideoSeries> createState() => _VideoSeriesState();
}

class _VideoSeriesState extends State<VideoSeries> {
  List<Map<String, dynamic>> courseData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchSeriesData();
  }

  Future<void> fetchSeriesData({bool refresh = false}) async {
    if (!isLoading || refresh) {
      setState(() {
        isLoading = true;
      });
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'access_token');
      try {
        final response = await http.get(
          Uri.parse('https://yamarketsacademy.com/api/course_api/series_data'),
          headers: {
            'Authorization': '$accessToken',
          },
        );
        if (response.statusCode == 200) {
          final List<dynamic> jsonData = json.decode(response.body);
          print('Json data: $jsonData');
          if (jsonData is List && jsonData.isNotEmpty && jsonData[0] is Map<String, dynamic>) {
            // Fetch topic count for each series
            for (var series in jsonData) {
              series['topic_count'] = await fetchTopicCount(series['id'], accessToken);
            }
            setState(() {
              courseData = jsonData.cast<Map<String, dynamic>>();
              isLoading = false;
            });
          } else {
            handleErrorResponse(response);
          }
        } else {
          handleErrorResponse(response);
        }
      } catch (e) {
        print('Error fetching course data: $e');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<int> fetchTopicCount(String seriesId, String? accessToken) async {
    try {
      final response = await http.get(
        Uri.parse('https://yamarketsacademy.com/api/course_api/series_wise_data/$seriesId'),
        headers: {
          'Authorization': '$accessToken',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.length;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error fetching topic count: $e');
      return 0;
    }
  }

  void handleErrorResponse(http.Response response) {
    final Map<String, dynamic> errorResponse = json.decode(response.body);
    final status = errorResponse['status'];
    final message = errorResponse['message'];
    print('Error: $status, Message: $message');
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      final bool isLandscape = orientation == Orientation.landscape;
      double screenHeight = MediaQuery.of(context).size.height;
      double screenWidth = MediaQuery.of(context).size.width;
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Video Series"),
          leading: BackButton(
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
            return Container(
              margin: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01,
                  horizontal: screenWidth * 0.05),
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
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/video_series/folder_video.png',
                        width: screenWidth * 0.2,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course['series_name'],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.05,
                            ),
                            maxLines: null,
                            overflow: TextOverflow.visible,
                          ),
                          Text(
                            '${course['topic_count']} videos',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        int selectedId = int.parse(course['id']);
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: Video(id: selectedId),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 17.0),
                        child: Container(
                          height: screenWidth * 0.1,
                          width: screenWidth * 0.1,
                          decoration: BoxDecoration(
                            color: Color(0xfffac211),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
