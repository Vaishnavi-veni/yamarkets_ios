import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:splash_screen/screen/events/webinar.dart';
// import 'package:splash_screen/screen/home.dart';

import '../home_screen.dart';

class WebinarForm extends StatefulWidget {
  final int id;
  final Function(int, String) onUpdateStatus;

  WebinarForm({required this.id, required this.onUpdateStatus});

  @override
  State<WebinarForm> createState() => _WebinarFormState();
}

class _WebinarFormState extends State<WebinarForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  bool _dataFetched = false;
  String userid = '';

  @override
  void initState() {
    super.initState();
    getUsernameFromToken();
  }

  Future<bool> getUsernameFromToken() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    print("Access tokennnnn: $accessToken");
    if (accessToken != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
      print("decoded tokennnnn: $decodedToken");
      setState(() {
        _nameController.text = decodedToken['username'] ?? '';
        _emailController.text = decodedToken['email'] ?? '';
        _dataFetched = true;
        userid = decodedToken['uid'];
        print("User id llllll$userid");
      });
      return true;
    } else {
      return false;
    }
  }

  void _handleSubmit() async {
    String username = _nameController.text;
    String email = _emailController.text;
    String country = _countryController.text;

    Map<String, dynamic> requestBody = {
      'user_id': userid,
      'webi_id': widget.id.toString(),
      'name': username,
      'email': email,
      'country': country,
    };
    print("Request body:$requestBody");
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

      if (response.statusCode == 201) {
        print('Form submitted successfully');
        widget.onUpdateStatus(widget.id, 'booked');
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
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
        // Navigator.pop(context);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        ),
        leading: BackButton(color: Colors.black),
        title: Text("Book Slot"),
      ),
      body: FutureBuilder(
        future: _dataFetched ? null : getUsernameFromToken(),
        builder: (context, snapshot) {
          return Container(
            height: screenHeight,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: screenWidth,
                    height: 1,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  _buildTextFormField(
                    context,
                    "Full Name",
                    _nameController,
                  ),
                  _buildTextFormField(
                    context,
                    "Email",
                    _emailController,
                  ),
                  _buildTextFormField(
                    context,
                    "Country",
                    _countryController,
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  GestureDetector(
                    onTap: () {
                      _handleSubmit();
                    },
                    child: Container(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.07,
                      decoration: BoxDecoration(
                        color: Color(0xfffac211).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          " Submit ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.045,
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
  }

  Widget _buildTextFormField(BuildContext context, String labelText,
      TextEditingController controller) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              labelText,
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5, left: 0),
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.06,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xfff9CAFAA)),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextFormField(
                controller: controller,
                style: TextStyle(color: Colors.grey.shade700),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: labelText,
                    hintStyle: TextStyle(color: Colors.black),
                    contentPadding: EdgeInsets.only(top: 1, bottom: 10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
