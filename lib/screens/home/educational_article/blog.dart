import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../utils/localization_utils.dart';
import '../../../view/url.dart';
import 'package:http/http.dart'as http;
import 'package:html/parser.dart' as html_parser;


class BlogPage extends StatefulWidget {
  final String blogId;

  BlogPage({required this.blogId});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {

  bool isLoading = false;
  List<Map<String, dynamic>> blogData = [];

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
        print("Json Data: $jsonData");
        if (jsonData is List) {
          final blog = jsonData.cast<Map<String, dynamic>>().firstWhere(
                (element) => element['id'] == widget.blogId,
            orElse: () => {},
          );
          setState(() {
            blogData = [blog];
          });
        } else {
          handleErrorResponse(response);
        }
      } else {
        handleErrorResponse(response);
      }
    } catch (e) {
      print('Error fetching blog data: $e');
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

  String parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    final String parsedString = html_parser.parse(document.body?.text).documentElement?.text ?? '';
    return parsedString;
  }

  @override
  void initState() {
    super.initState();
    BlogData(); // Fetch blog data when the widget is initialized
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
        title: Text(
          Localization.translate('edu') ?? 'Educational Article',
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
          ? Center(child:LoadingAnimationWidget.threeArchedCircle(
        color: Color(0xfffac211),
        size: 50,
      ),)
          : blogData.isNotEmpty
          ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left:25,right:25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  blogData[0]['blog_name'] ?? 'No Title',
                  style: TextStyle(
                    fontSize: screenWidth*0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ) ,
              )
             ,
              SizedBox(height: screenHeight*0.005),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [

                      Text(
                        blogData[0]['author'] ?? 'No Title',
                        style: TextStyle(
                            fontSize: screenWidth*0.03,
                            color: Color(0xfffac211)
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10,),
                  Icon(Icons.circle,
                  size: 5,
                  color: Color(0xfffac211),),
                  SizedBox(width: 10,),

                  Row(
                    children: [
                      Image.asset('assets/blog/calendar_yellow-removebg-preview.png',
                        height: screenWidth*0.04,),
                      SizedBox(width: screenWidth*0.01,),
                      Text(
                        DateFormat('dd-MM-yy').format(DateFormat('yyyy-MM-dd').parse(blogData[0]['date'])),
                        style: TextStyle(
                            fontSize: screenWidth*0.03,
                            color: Color(0xfffac211)
                        ),
                      ),
                    ],
                  ),

                ],
              ),
              SizedBox(height: screenHeight*0.02),
          ClipRRect(
            borderRadius: BorderRadius.all( Radius.circular(10),
            ),
             child: CachedNetworkImage(
                imageUrl: 'https://yamarkets.com/images/${blogData[0]['image']}',
                height: screenHeight * 0.15,  // Adjust the height as needed
                width: double.infinity,
                fit: BoxFit.fill,
                placeholder: (context, url) => Center(child:LoadingAnimationWidget.threeArchedCircle(
                  color: Color(0xfffac211),
                  size: 50,
                ),),
                errorWidget: (context, url, error) {
                  print('Failed to load image: $url');
                  return Center(child: Icon(Icons.error));
                },
              ),
          ),
              SizedBox(height: screenHeight*0.02),
              Text(
                parseHtmlString(blogData[0]['long_desc'] ?? 'No Description'),
                style: TextStyle(
                    fontSize: screenWidth*0.04,
                    color: Colors.black54,
                  fontWeight: FontWeight.w500
                ),
              ),
              // Add more widgets here to display other blog details
            ],
          ),
        ),
      )
          : Center(child: Text('No data available')),
    );
  }
}