import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../../utils/localization_utils.dart';
import '../../../view/url.dart';
import 'video_player.dart';

class Video extends StatefulWidget {
  final int id;

  Video({required this.id});

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  List<Map<String, dynamic>> videoData = [];
  bool isLoading = false;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  int? _currentPlayingIndex;
  bool _showVideo = false;

  @override
  void initState() {
    super.initState();
    fetchVideoData();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> fetchVideoData({bool refresh = false}) async {
    if (!isLoading || refresh) {
      setState(() {
        isLoading = true;
      });
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'access_token');
      try {
        final response = await http.get(
          Uri.parse('https://yamarketsacademy.com/api/course_api/series_wise_data/${widget.id}'),
          headers: {
            'Authorization': '$accessToken',
          },
        );
        if (response.statusCode == 200) {
          final List<dynamic> jsonData = json.decode(response.body);
          print('Json data: $jsonData');
          if (jsonData is List && jsonData.isNotEmpty && jsonData[0] is Map<String, dynamic>) {
            setState(() {
              videoData = jsonData.cast<Map<String, dynamic>>();
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

  void handleErrorResponse(http.Response response) {
    final Map<String, dynamic> errorResponse = json.decode(response.body);
    final status = errorResponse['status'];
    final message = errorResponse['message'];
    print('Error: $status, Message: $message');
    setState(() {
      isLoading = false;
    });
  }

  void navigateToVideoPlayer(String videoUrl) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.scale, alignment: Alignment.topLeft,
        child: VideoPlayerScreen(videoUrl: videoUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Localization.translate('topics') ?? 'Topics',
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
      body: isLoading
          ? Center(
        child: LoadingAnimationWidget.threeArchedCircle(
          color: Color(0xff7CBAC3),
          size: 50,
        ),
      )
          : ListView.builder(
        shrinkWrap: true,
        itemCount: videoData.length,
        itemBuilder: (context, index) {
          final course = videoData[index];
          final videoUrl = course['series_video'] ?? '';
          print("Video URL:$videoUrl");
          final thumbnailUrl = course['thumbnail'] ?? '';
          final videoName = course['series_video_name'] ?? 'No Title';
          // final videoName ="ywegdhwdgb,wj,hwiokdhjwleidkjhweiudkjhe"?? 'No Title';

          return Column(
            children: [
              SizedBox(height: screenWidth * 0.08),
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth*0.04),
                height: screenWidth * 0.4,
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
                child:   Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        navigateToVideoPlayer(videoUrl);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.only(left: screenWidth * 0.05, ),
                        width: screenWidth * 0.45,
                        height: screenWidth * 0.35,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: thumbnailUrl.isNotEmpty
                              ? Image.network(
                            '${MyConstants.videoimageUrl}/$thumbnailUrl',
                            fit: BoxFit.contain,
                          )
                              : Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'No Thumbnail',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          navigateToVideoPlayer(videoUrl);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: screenWidth * 0.03,right: screenWidth * 0.03),
                          alignment: Alignment.center,
                          child: Text(
                            videoName,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.w400,
                            ),
                            softWrap: true,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              )
              ,
              SizedBox(height: screenWidth * 0.02),
            ],
          );
        },
      ),
    );
  }
}
