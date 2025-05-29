import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yamarkets_ios/screens/profile/profile_screen.dart';

import '../../utils/localization_utils.dart';

class Languages extends StatefulWidget {
  const Languages({super.key});

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  String _selectedLanguage = 'en'; // Default selected language
  final storage = FlutterSecureStorage();
  bool _isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    String? storedLanguage = await storage.read(key: 'code');
    if (storedLanguage != null) {
      _selectedLanguage = storedLanguage;
    }
    await Localization.load(_selectedLanguage);
    setState(() {});
  }

  void _updateSelectedLanguage(String languageCode) async {
    setState(() {
      _isLoading = true; // Start loading
    });
    await storage.write(key: "code", value: languageCode);
    await Localization.load(languageCode);
    setState(() {
      _selectedLanguage = languageCode;
      _isLoading = false; // Stop loading
    });
    _showConfirmationDialog(); // Show confirmation dialog
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Change Language"),
          content: Text(
            "Are you sure you want to change the language?",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              child: Text("YES"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MyProfile(languageCode: _selectedLanguage
                            // languageCode: _selectedLanguage
                            ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required String languageCode,
    required String imagePath,
    required String countryName,
    required String languageName,
  }) {
    bool isSelected = _selectedLanguage == languageCode;
    return GestureDetector(
      onTap: () {
        _updateSelectedLanguage(languageCode);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade200,
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
            Text(
              countryName,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
            Spacer(),
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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          'Languages',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.03),
                    _buildLanguageOption(
                      languageCode: 'en',
                      imagePath: 'assets/flags/uk.png',
                      countryName: 'English',
                      languageName: '(UK)',
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    _buildLanguageOption(
                      languageCode: 'hi',
                      imagePath: 'assets/flags/india.png',
                      countryName: 'India',
                      languageName: '(हिंदी)',
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    _buildLanguageOption(
                      languageCode: 'ar',
                      imagePath: 'assets/flags/uae_flag.jpeg',
                      countryName: 'Arabic',
                      languageName: '(عربي)',
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
