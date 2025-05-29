import 'dart:async';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
//
import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:splash_screen/view/url.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../view/url.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  List<String> imageUrls = [];
  int _currentPage = 0;
  final storage = FlutterSecureStorage();
  Timer? _logoutTimer, timer;

  @override
  void initState() {
    super.initState();
    initializeLogoutTimer();
    fetchData();
    startTimer();
  }
  // void initState() {
  //   super.initState();
  //   // fetchData();
  //   startTimer();
  // }

  void logout() {
    // Add the logic to perform logout actions here
    clearLoginStatus();
    Navigator.pushNamed(context, '/login');
    // Additional logout actions...
    // Navigate to the login screen after logout
  }

  void clearLoginStatus() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('isLoggedIn');
      // Clear the access token or other user data when logging out
      storage.delete(key: 'access_token');
    });
  }

  void initializeLogoutTimer() {
    const logoutDuration = Duration(days: 7);

    _logoutTimer = Timer(logoutDuration, () {
      // Logout the user after the timer expires
      logout();
    });
  }

  Future<void> login(String email, password) async {
    try {
      final response = await http.post(
        Uri.parse('${MyConstants.baseUrl}/login'),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        initializeLogoutTimer();
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Response data: $responseData');

        if (responseData.containsKey('access_token')) {
          final String accessToken = responseData['access_token'];

          // Store the access token securely
          await storage.write(key: 'access_token', value: accessToken);

          print('Response data: $responseData');
          Fluttertoast.showToast(
            msg: "Login successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xffffc400),
            textColor: Colors.black,
            fontSize: 16.0,
          );

          // _startLogoutTimer();

          // Delayed logout after 5 seconds
          // Navigate to the home page
          Navigator.pushNamed(context, '/home');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _startLogoutTimer(context);
          });
        } else {
          // Check if the response is empty, indicating token expiration
          if (responseData.isEmpty) {
            // Log out the user
            logout();
            // Navigate back to the login page
            Navigator.pushNamed(context, '/login');
          } else {
            Fluttertoast.showToast(
              msg: "Login failed: Access token not found",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        }
      } else {
        Fluttertoast.showToast(
          msg: "Login failed: Server error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print(e.toString());

      Fluttertoast.showToast(
        msg: "Login failed ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xffffc400),
        textColor: Colors.black,
        fontSize: 16.0,
      );
    }
  }

  void _startLogoutTimer(BuildContext context) {
    // Set the duration for automatic logout (5 seconds in this case)
    const logoutDuration = Duration(days: 7);

    // Create a new timer
    _logoutTimer = Timer(logoutDuration, () {
      // Logout the user after the timer expires
      logout();
    });
  }

  void startTimer() {
    // Start a new timer
    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      // Call fetchData() method
      // fetchData();
      authToken();
    });
  }

  void stopTimer() {
    // Cancel the timer if it's running
    if (timer != null) {
      timer!.cancel();
    }
  }

  // void clearLoginStatus() {
  //   SharedPreferences.getInstance().then((prefs) {
  //     prefs.remove('isLoggedIn');
  //     // Clear the access token or other user data when logging out
  //     storage.delete(key: 'access_token');
  //   });
  // }

  // void startTimer() {
  //   // Start a new timer
  //   timer = Timer.periodic(const Duration(seconds: 12), (Timer t) {
  //     // Call fetchData() method
  //     authToken();
  //     // fetchData();
  //   });
  // }

  // void stopTimer() {
  //   // Cancel the timer if it's running
  //   if (timer != null) {
  //     timer!.cancel();
  //   }
  // }

  Future<void> fetchData() async {
    final storage = FlutterSecureStorage();

    // Fetch access token from storage
    final accessToken = await storage.read(key: 'access_token');

    final apiUrl = 'https://yamarketsacademy.com/api/course_api/slider_api';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': '$accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(data);

        // Ensure that 'data' is a list
        if (data is List) {
          final List<String> urls =
              data.map((item) => item['image'].toString()).toList();

          setState(() {
            imageUrls = urls;
          });
        } else if (response.statusCode == 401) {
          final Map<String, dynamic> errorResponse = json.decode(response.body);
          final status = errorResponse['status'];
          final message = errorResponse['message'];
          print('Error: $status, Message: $message');

          // Navigate to login page or handle error message accordingly

          clearLoginStatus();
          stopTimer();
          Navigator.pushReplacementNamed(context, '/login');
          return; // Stop further execution
        } else {
          // Handle other HTTP errors
          print('Error: ${response.statusCode}');
        }
      } else {
        // Handle error
        // print('Error: ${response.statusCode}');
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        final status = errorResponse['status'];
        final message = errorResponse['message'];
        print('Error: $status, Message: $message');

        // Navigate to login page or handle error message accordingly
        clearLoginStatus();
        stopTimer();
        Navigator.pushReplacementNamed(
            context, '/login'); // Replace '/login' with your login page route
        return;
      }
    } catch (error) {
      // Handle error
      print('Error: $error');
    }
  }

  // token

  Future<void> authToken() async {
    final storage = FlutterSecureStorage();

    // Fetch access token from storage
    final accessToken = await storage.read(key: 'access_token');

    final apiUrl = 'https://yamarketsacademy.com/api/course_api/slider_api';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': '$accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(data);

        // Ensure that 'data' is a list
        if (data is List) {
          final List<String> urls =
              data.map((item) => item['image'].toString()).toList();

          setState(() {
            imageUrls = urls;
          });
        } else if (response.statusCode == 401) {
          final Map<String, dynamic> errorResponse = json.decode(response.body);
          final status = errorResponse['status'];
          final message = errorResponse['message'];
          print('Error: $status, Message: $message');

          // Navigate to login page or handle error message accordingly

          clearLoginStatus();
          stopTimer();
          Navigator.pushReplacementNamed(context, '/login');
          return; // Stop further execution
        } else {
          // Handle other HTTP errors
          print('Error: ${response.statusCode}');
        }
      } else {
        // Handle error
        // print('Error: ${response.statusCode}');
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        final status = errorResponse['status'];
        final message = errorResponse['message'];
        print('Error: $status, Message: $message');

        // Navigate to login page or handle error message accordingly
        clearLoginStatus();
        stopTimer();
        Navigator.pushReplacementNamed(
            context, '/login'); // Replace '/login' with your login page route
        return;
      }
    } catch (error) {
      // Handle error
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      final bool isLandscape = orientation == Orientation.landscape;
      if (imageUrls.isEmpty) {
        // Handle the case when imageUrls is empty, for example, display a loading indicator or placeholder.
        return Center(
          child: LoadingAnimationWidget.threeArchedCircle(
            color: Colors.black,
            size: 50,
          ),
        );
      }

      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: screenHeight * .26,
        child: Column(
          children: [
            CarouselSlider.builder(
              itemCount: imageUrls.length,
              options: CarouselOptions(
                height: screenHeight*0.2,

                // height: screenHeight*0.24,
                initialPage: _currentPage,
                viewportFraction: 1.0,
                onPageChanged: onPageChanged,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 2),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
              ),
              itemBuilder: (BuildContext context, int index, realIndex) {
                return ClipRRect(
                  // padding: EdgeInsets.symmetric(),
                  // child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    // width: screenWidth*,
                    child: Image.network(
                      '${MyConstants.imageUrl}/${imageUrls[index]}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // ),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            DynamicRoundIcons(
              itemCount: imageUrls.length,
              currentPage: _currentPage,
            ),
          ],
        ),
      );
    });
  }

  void onPageChanged(int page, CarouselPageChangedReason reason) {
    setState(() {
      _currentPage = page;
    });
  }
}

class DynamicRoundIcons extends StatelessWidget {
  final int itemCount; // Ensure that itemCount is of type int
  final int currentPage; // Ensure that currentPage is of type int

  DynamicRoundIcons({
    required this.itemCount,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      final bool isLandscape = orientation == Orientation.landscape;
      final screenWidth = MediaQuery.sizeOf(context).width;
      final screenHeight = MediaQuery.sizeOf(context).height;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(itemCount, (int index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            width: screenWidth * .02,
            height: screenHeight * .01,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  currentPage == index ? const Color(0xffffc400) : Colors.grey,
            ),
          );
        }),
      );
    });
  }
}
