import 'package:flutter/material.dart';

class WhiteBox extends StatelessWidget {
  final String imagePath;
  final String text;
  final String text2;

  const WhiteBox({Key? key, required this.imagePath, required this.text, required this.text2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenWidth*0.3,
      width: screenWidth*0.3,
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color(0xffF8E8EE),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: screenWidth*0.1,
            width: screenWidth*0.1,
          ),
          SizedBox(height: 7.0),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: screenWidth*0.04,
            ),
          ),
          Text(
            '($text2)',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: screenWidth*0.04,
            ),
          ),
        ],
      ),
    );
  }
}
