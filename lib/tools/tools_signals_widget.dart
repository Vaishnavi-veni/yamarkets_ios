import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class ToolSignalWidget extends StatefulWidget {
  final String title;
  final String url;
  final String languageCode;

  const ToolSignalWidget(
      {required this.title,
      required this.url,
      Key? key,
      required this.languageCode})
      : super(key: key);

  @override
  _ToolSignalWidgetState createState() => _ToolSignalWidgetState();
}

class _ToolSignalWidgetState extends State<ToolSignalWidget> {
  bool isLandscape = false; // Track the current orientation

  @override
  void initState() {
    super.initState();
    // Enable Hybrid Composition for Android
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  void dispose() {
    // Ensure the app returns to portrait when leaving the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  // Function to toggle the screen orientation
  void _toggleOrientation() {
    if (isLandscape) {
      // Set to portrait mode
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    } else {
      // Set to landscape mode
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    setState(() {
      isLandscape = !isLandscape; // Toggle the flag
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(isLandscape
                ? Icons.screen_lock_rotation
                : Icons.screen_rotation),
            onPressed: _toggleOrientation,
          ),
        ],
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
      body: SafeArea(
        child: SizedBox(
          height: screenHeight - appBarHeight,
          child: WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }
}
