import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yamarkets_ios/screens/home/home_screen.dart';
import 'package:yamarkets_ios/screens/landing_page.dart';
import 'package:yamarkets_ios/screens/login.dart';
import 'package:yamarkets_ios/screens/register.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          bool loggedIn = snapshot.data ?? false;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: {
              '/login': (context) => const Login(),
              '/register': (context) => Register(),
              '/home': (context) => HomePage(),
            },
            home: AnimatedSplashScreen(
              duration: 3000,
              splash: Image.asset('assets/logo/yamarketsacademy-removebg-preview.png'),
              nextScreen: loggedIn ? HomePage() : HomeView(),
              splashTransition: SplashTransition.fadeTransition,
              backgroundColor: Colors.white,
            ),
          );
        }
      },
    );
  }
}
