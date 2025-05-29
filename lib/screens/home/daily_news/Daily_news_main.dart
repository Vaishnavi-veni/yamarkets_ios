import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import '../../../design/daily_news.dart';
import 'daily_news_video.dart';

class DailyNews extends StatefulWidget {
  const DailyNews({super.key});

  @override
  State<DailyNews> createState() => _DailyNewsState();
}

class _DailyNewsState extends State<DailyNews> {
  List<dynamic>? _videoData;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchData(String language) async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');

    final url = 'https://yamarketsacademy.com/api/course_api/dailynews/$language';

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': '$accessToken'},
    );

    print("Response Body of daily news: ${response.body}");

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      print("Decoded response: $decodedResponse");
      setState(() {
        _videoData = decodedResponse as List<dynamic>;
        if (_videoData != null && _videoData!.isNotEmpty) {
          String videoLink = _videoData![0]['iframe_links'];
          // Navigate to the video screen with the video link
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.scale, alignment: Alignment.topCenter,
              child: VideoScreen(videoLink: videoLink),
            ),
          );
        }
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Color(0xffE5CFE5),
              ],
        
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "In which language would you prefer to read news?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.055,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.7,
                decoration: BoxDecoration(
                  color: Color(0xffE5CFE5),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _fetchData('English');
                          },
                          child: WhiteBox(
                            imagePath: 'assets/daily_news/letter_a.png',
                            text: 'English',
                            text2: 'US',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _fetchData('Arabic');
                          },
                          child: WhiteBox(
                            imagePath: 'assets/daily_news/sheen_arabic.png',
                            text: 'Arabic',
                            text2: 'عربي',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _fetchData('Chinese');
                          },
                          child: WhiteBox(
                            imagePath: 'assets/daily_news/Chinese.png',
                            text: 'Chinese',
                            text2: '中国人',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _fetchData('Hindi');
                          },
                          child: WhiteBox(
                            imagePath: 'assets/daily_news/letter-hindi-a.png',
                            text: 'Hindi',
                            text2: 'हिंदी',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _fetchData('Thai');
                          },
                          child: WhiteBox(
                            imagePath: 'assets/daily_news/Thai.png',
                            text: 'Thai',
                            text2: 'แบบไทย',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
