import 'package:flutter/material.dart';
import 'package:yamarkets_ios/screens/landing_page.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Gain Market Insights with Trading Central at YaMarkets',
      'image': 'assets/onboarding/yamarkets_onboarding1.png',
      'description':
          'With YaMarkets and Trading Central, you get excellent market insights and trading strategies. These offerings are accessible through our proprietary interfaces.'
    },
    {
      'title': 'Improving Technical Analysis',
      'image': 'assets/onboarding/yamarkets_onboarding2.png',
      'description':
          'By using Trading Central with YaMarkets, you can make more informed decisions based on practical and clear trading plans created by Trading Central\'s expert analysts. This tool combines insights from top analysts with automated algorithms. It provides pattern recognition for potential trading ideas, verified by analysts before release.'
    },
    {
      'title': 'Daily Market Watch: Trading Central Update for Traders',
      'image': 'assets/onboarding/yamarkets_onboarding3.png',
      'description':
          'In today\'s financial landscape, markets are buzzing with activity as investors react to a flurry of economic indicators and geopolitical developments. Amidst this dynamic environment, traders are navigating the twists and turns of global exchanges, seeking opportunities and managing risks.'
    },
  ];

  // PageController to manage page transitions
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(onboardingData[index]['image']!, height: 300),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        onboardingData[index]['title']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        onboardingData[index]['description']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
              (index) => buildDot(index, context),
            ),
          ),
          SizedBox(height: 40),
          _currentIndex == onboardingData.length - 1
              ? TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeView(),
                      ),
                    );
                    // Navigate to home screen or next page
                  },
                  child: Text(
                    'Get Started',
                    style: TextStyle(color: Colors.amber),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeView(),
                          ),
                        );
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(color: Colors.amber),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Move to next page
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                      child: Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
          SizedBox(height: 20),
        ],
      ),
    ));
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: _currentIndex == index ? 20 : 10,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: _currentIndex == index ? Colors.amber : Colors.grey,
      ),
    );
  }
}
