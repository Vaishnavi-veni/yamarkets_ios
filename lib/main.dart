import 'dart:io';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yamarkets_ios/screens/home/home_screen.dart';
import 'package:yamarkets_ios/screens/login.dart';
import 'package:yamarkets_ios/screens/onboarding/onboarding_screen.dart';
import 'package:yamarkets_ios/screens/register.dart';
import 'package:yamarkets_ios/utils/app_localizations.dart';
import 'package:yamarkets_ios/utils/locale_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    static FirebaseAnalyticsObserver observer =
    FirebaseAnalyticsObserver(analytics: analytics);


  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  void initState() {
    super.initState();
    fetchLanguageCode();

    // Log an event when the app starts
    analytics.logEvent(name: "app_opened");
  }

  String code = '';
  final storage = FlutterSecureStorage();

  fetchLanguageCode() async {
    String? storedCode = await storage.read(key: 'code');
    setState(() {
      code = storedCode ?? '';
    });
    print("Selected language homepage: $code");

    // Log selected language
    analytics.logEvent(
      name: "selected_language",
      parameters: {"language_code": code},
    );
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
          return ChangeNotifierProvider(
            create: (_) => LocaleProvider(),
            child: Consumer<LocaleProvider>(
              builder: (context, localeProvider, child) {
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    navigatorObservers: [observer], // Add Analytics Observer
                    routes: {
                      '/login': (context) => const Login(),
                      '/register': (context) => Register(),
                      '/home': (context) => HomePage(languageCode: code),
                    },
                    locale: localeProvider.locale,
                    supportedLocales: const [
                      Locale('en'),
                      Locale('hi'),
                      Locale('ar'),
                    ],
                    localizationsDelegates: [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    home: AnimatedSplashScreen(
                      duration: 3000,
                      splash: Image.asset(
                          'assets/logo/yamarketsacademy-removebg-preview.png'),
                      nextScreen: loggedIn
                          ? HomePage(languageCode: code)
                          : OnboardingScreen(),
                      splashTransition: SplashTransition.fadeTransition,
                      backgroundColor: Colors.white,
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}