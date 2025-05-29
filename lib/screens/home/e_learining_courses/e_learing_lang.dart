import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yamarkets_ios/screens/home/e_learining_courses/e_learning_courses_main.dart';

class ELearningLang extends StatefulWidget {
  const ELearningLang({super.key});

  @override
  State<ELearningLang> createState() => _ELearningLangState();
}

class _ELearningLangState extends State<ELearningLang> {
  Future<void> _setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', languageCode);
  }

  Widget _buildLanguageOption({
    required String languageCode,
    required String imagePath,
    required String languageName,
  }) {
    return GestureDetector(
      onTap: ()  async {
          await _setLanguage(languageCode);
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: const ELearningCourses(),
            ),
          );
        },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.width * 0.03),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.width * 0.1,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.05),
              child: Text(
                languageName,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageContainer(
      String language, String languageCode, String flagAsset) {
    return GestureDetector(
      onTap: () async {
        await _setLanguage(languageCode);
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: const ELearningCourses(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.orange.shade100,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(flagAsset),
            ),
            const SizedBox(height: 10),
            Text(
              language,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.orange,
              ],
            ),
          ),
        ),
        title: const Text('Select Language'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Center(
            child: Column(
          children: [
            _buildLanguageOption(
                languageName: 'English',
                languageCode: 'en',
                imagePath: 'assets/flags/uk.png'),
            _buildLanguageOption(
                languageName: 'ภาษาไทย',
                languageCode: 'th',
                imagePath:
                    'assets/flags/thai.jpg'),
            _buildLanguageOption(
                languageName: 'हिन्दी',
                languageCode: 'hi',
                imagePath: 'assets/flags/india.png'),
            _buildLanguageOption(
                languageName: 'العربية',
                languageCode: 'ar',
                imagePath: 'assets/flags/uae_flag.jpeg'),
          ],
        )),
      ),
    );
  }
}
