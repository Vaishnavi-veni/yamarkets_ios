import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoScreen extends StatefulWidget {
  final String videoLink;

  const VideoScreen({super.key, required this.videoLink});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late final String videoLink;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily News Video'),
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
      body: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.55,
              child: WebView(
                initialUrl: widget.videoLink,
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (_) {
                  setState(() {
                    _isLoading = false;
                  });
                },
              ),
            ),
          ),
          _isLoading
              ? Center(
                  child: LoadingAnimationWidget.threeArchedCircle(
                    color: Color(0xffE5CFE5),
                    size: 50,
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
