import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/localization_utils.dart';
import 'login.dart';
// import 'package:splash_screen/screen/login.dart';
// import 'package:splash_screen/screen/register.dart';

// import 'package:blobs/blobs.dart';
// import '../../../../config/themes/app_theme.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin{
  late AnimationController _animationController;
  int _currentIndex = 0;
  String code='';
  final storage = FlutterSecureStorage();


  fetchLanguageCode() async {
    String? storedCode = await storage.read(key: 'code');
    setState(() {
      code = storedCode ?? '';
    });
    print("Selected language homepage: $code");
  }


  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    super.initState();
    fetchLanguageCode();
    Localization.load(code); // Load the selected language
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final List<String> _images = [
    'assets/images/img5.jpeg',
    'assets/images/img2.jpeg',
    'assets/images/img7.png',
    'assets/images/img4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation)
    {
      final bool isLandscape = orientation == Orientation.landscape;
      double screenHeight = MediaQuery
          .of(context)
          .size
          .height;
      double screenWidth = MediaQuery
          .of(context)
          .size
          .width;
      return WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop(); // Close the entire application
            return false;
          },
          child:

          MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
                backgroundColor:Colors.white,
                body: SingleChildScrollView(
                  child: Container(
                      child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Positioned(
                            //   bottom: 0,
                            //   left: 0,
                            //   child: Blob.random(
                            //     size: 200,
                            //     edgesCount: 5,
                            //     minGrowth: 4,
                            //     styles:
                            //     BlobStyles(color: Colors.white),
                            //   ),
                            // ),
                            // Positioned(
                            //   top: 0,
                            //   right: 0,
                            //   child: Blob.random(
                            //     size: 300,
                            //     edgesCount: 9,
                            //     minGrowth: 3,
                            //     styles:
                            //     BlobStyles(color: Colors.white),
                            //   ),
                            // ),
                            Positioned(
                              left: -screenWidth * 0.2,
                              top: screenHeight * 0.1,
                              child: RotationTransition(
                                turns: const AlwaysStoppedAnimation(45 / 360),
                                child: Container(
                                  width: screenWidth * 0.5,
                                  height: screenHeight / 1.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                                child:
                                Column(
                                    children: [
                                      SizedBox( height: isLandscape
                                          ? screenHeight * 0.1
                                          : screenHeight * 0.3,),
                                      Image.asset(
                                        'assets/logo/yamarketsacademy-removebg-preview.png',
                                        // Change this to your image path
                                        width: isLandscape
                                            ? screenWidth * 0.3
                                            : screenWidth * 0.5,

                                      ),

                                      SizedBox(height: isLandscape
                                          ? screenWidth * 0.1
                                          : screenHeight * 0.03,),
                                      Padding(padding: EdgeInsets.only(
                                          left: 20,right:20), child:
                                      Column(
                                        children: [
                                          Text(
                                            Localization.translate('academic_hub') ?? 'An Academic Hub for Traders',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: isLandscape
                                                    ? screenWidth * 0.035
                                                    : screenWidth * 0.04,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black
                                            ),),
                                          SizedBox(height: isLandscape
                                              ? screenWidth * 0.1
                                              : screenHeight * 0.03,),
                                          Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.5), // Shadow color
                                                      spreadRadius: 5, // Spread radius
                                                      blurRadius: 7, // Blur radius
                                                      offset: Offset(6, 6), // Offset
                                                    ),
                                                  ],
                                                ),
                                                child:
                                                AnimatedButton(
                                                  onPress: () {
                                                    _animationController.forward(
                                                        from: 0.0);
                                                    Future.delayed(Duration(
                                                        milliseconds: 500), () {
                                                      Navigator.pushNamed(
                                                        context, '/login'
                                                        // MaterialPageRoute(
                                                        //     builder: (context) =>
                                                        //         Login()
                                                        // ),
                                                      );
                                                    });
                                                  },

                                                  height: isLandscape
                                                      ? screenWidth * 0.06
                                                      : screenHeight * 0.07,
                                                  width: isLandscape
                                                      ? screenWidth * 0.45
                                                      : screenWidth * 0.8,
                                                  text: 'Login',
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: screenWidth*0.05
                                                  ),
                                                  isReverse: true,
                                                  selectedTextColor: Colors.black,
                                                  transitionType: TransitionType
                                                      .LEFT_TO_RIGHT,
                                                  // textStyle: submitTextStyle,
                                                  backgroundColor: Colors.white,
                                                  selectedBackgroundColor: Color(
                                                      0xFFFAC211),
                                                  // borderColor: Colors.white,
                                                  borderRadius: 10,
                                                  borderWidth: 2,

                                                ),
                                              ),
                                              SizedBox(
                                                height:  isLandscape
                                                    ? screenWidth * 0.02
                                                    : screenWidth * 0.06,),
                                              Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.5), // Shadow color
                                                      spreadRadius: 5, // Spread radius
                                                      blurRadius: 7, // Blur radius
                                                      offset: Offset(6, 6), // Offset
                                                    ),
                                                  ],
                                                ),
                                                child:
                                                AnimatedButton(
                                                  onPress: () {
                                                    _animationController.forward(
                                                        from: 0.0);
                                                    Future.delayed(Duration(
                                                        milliseconds: 500), () {
                                                      Navigator.pushNamed(
                                                        context,'/register'
                                                        // MaterialPageRoute(
                                                        //     builder: (context) =>
                                                        //         Register()),
                                                      );
                                                    });
                                                  },
                                                  height: isLandscape
                                                      ? screenWidth * 0.06
                                                      : screenHeight * 0.07,
                                                  width: isLandscape
                                                      ? screenWidth * 0.45
                                                      : screenWidth * 0.8,
                                                  text: 'Register',
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: screenWidth*0.05
                                                  ),
                                                  isReverse: true,
                                                  selectedTextColor: Colors.black,
                                                  transitionType: TransitionType
                                                      .LEFT_TO_RIGHT,
                                                  // textStyle: submitTextStyle,
                                                  backgroundColor: Color(0xfffac211),
                                                  selectedBackgroundColor: Colors.white,
                                                  // borderColor: Color(0xfffac211),
                                                  borderRadius: 10,
                                                  borderWidth: 2,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      ),
                                      SizedBox(height: screenHeight*0.2,)
                                    ]
                                )
                            )
                          ]
                      )
                  ),

                )
            ),
          )
      );
    }
    );
  }
}
