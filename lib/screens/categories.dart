import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class Categories extends StatefulWidget {
  final String apiUrl;
  final String appbarTitle;

  Categories({required this.apiUrl, required this.appbarTitle});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  late Future<String> _urlFuture;
  // late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _urlFuture = _fetchUrl(); // Initialize _urlFuture in initState
  }

  Future<String> _fetchUrl() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');

    final url = widget.apiUrl;

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': '$accessToken'
      }, // Include 'Bearer' before the token
    );

    print("Response Body: ${response.body}");
    print("Response Body Type: ${response.body.runtimeType}");

    if (response.statusCode == 200) {
      final decodedResponse =
          json.decode(response.body); // The response body is already a string
      print("Decoded response: $decodedResponse");

      return decodedResponse; // Directly return the response body
    } else {
      throw Exception('Failed to fetch URL');
    }
  }

  // void _loadUrl(String url) async {
  //   try {
  //     await _webViewController.loadUrl(url);
  //   } catch (e) {
  //     print('Error loading URL: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          widget.appbarTitle,
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
      body: FutureBuilder<String>(
        future: _urlFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                color: Colors.black,
                size: 50,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Stack(
                children: [
                  WebView(
                    initialUrl: widget.apiUrl,
                    javascriptMode: JavascriptMode.unrestricted,
                    onPageFinished: (_) {
                      // setState(() {
                      //   _isLoading = false;
                      // });
                    },
                  ),
                  // if (_isLoading)
                  //   Center(
                  //     child:LoadingAnimationWidget.threeArchedCircle(
                  //       color: Colors.black,
                  //       size: 50,
                  //     ),
                  //   ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            return WebView(
              initialUrl: snapshot.data!,
              javascriptMode: JavascriptMode.unrestricted,
              // onWebViewCreated: (controller) {
              //   _webViewController = controller;
              //   _loadUrl(snapshot.data!);
              // },
            );
          } else {
            return Center(
              child: Text('No data found'),
            );
          }
        },
      ),
    );
  }
}
