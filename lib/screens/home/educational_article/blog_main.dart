import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import '../../../utils/localization_utils.dart';
import '../../../view/url.dart';
import 'package:http/http.dart'as http;

import 'blog.dart';

class BlogMain extends StatefulWidget {
  const BlogMain({super.key});

  @override
  State<BlogMain> createState() => _BlogMainState();
}

class _BlogMainState extends State<BlogMain> {
  bool isLoading = false;
  List<Map<String, dynamic>> blogData = [];

  @override
  void initState() {
    super.initState();
    BlogData();
  }

  Future<void> BlogData() async {
    setState(() {
      isLoading = true;
    });
    final storage = FlutterSecureStorage();
    print("Storage: $storage" );
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
            blogData = jsonData.cast<Map<String, dynamic>>();
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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    blogData.sort((a, b) {
      DateTime dateA = DateFormat('yyyy-MM-dd').parse(a['date']);
      DateTime dateB = DateFormat('yyyy-MM-dd').parse(b['date']);
      return dateB.compareTo(dateA); // Sort in descending order
    });

    return Scaffold(
      appBar: AppBar(
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
    body: ListView.builder(
    scrollDirection: Axis.vertical,
    itemCount: blogData.length,
    itemBuilder: (context, index) {
      final blog = blogData[index];
      final imageUrl = 'https://yamarkets.com/images/${blog['image']}';
      print('Loading image: $imageUrl');
      return
      GestureDetector(
        onTap: () {
          Navigator.push(
            context, PageTransition(type: PageTransitionType.topToBottom,child: BlogPage(blogId: blog['id']),
            ),
          );
        },
        child:Container(
          margin: EdgeInsets.only(left: screenWidth*0.05,right: screenWidth*0.05,bottom: screenHeight*0.02),
          // height: screenHeight*0.3,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.grey
              ),
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft:Radius.circular(10),topRight: Radius.circular(10)
                ),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: screenHeight * 0.15,  // Adjust the height as needed
                  width: double.infinity,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
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
                      blog['blog_name'] ?? 'No Title',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                )
                ,
              ),
              SizedBox(height: screenHeight*0.005),
              Padding(padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03),child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.edit_note,
                        color: Color(0xfffac211),),
                      Text(
                        blogData[0]['author'] ?? 'No Title',
                        style: TextStyle(
                            fontSize: screenWidth*0.028,
                            fontWeight: FontWeight.bold,
                            color: Color(0xfffac211)
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Image.asset('assets/blog/calendar_yellow-removebg-preview.png',
                        height: screenWidth*0.05,),
                      SizedBox(width: screenWidth*0.01,),
                      Text(
                        DateFormat('dd-MM-yy').format(DateFormat('yyyy-MM-dd').parse(blogData[0]['date'])),
                        style: TextStyle(
                            fontSize: screenWidth*0.028,
                            fontWeight: FontWeight.bold,
                            color: Color(0xfffac211)
                        ),
                      ),
                    ],
                  ),

                ],
              ),)
              ,
              SizedBox(height: screenHeight*0.01),


            ],
          ),
        ) ,
      );

    }
    ),
    );
  }
}
