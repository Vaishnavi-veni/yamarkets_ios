import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'localization_utils.dart';

class LocaleProvider with ChangeNotifier {

  Locale _locale = const Locale('en'); // Default locale
  bool _isLoading = true;

  Locale get locale => _locale;
  bool get isLoading => _isLoading;

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  LocaleProvider() {
    _fetchLanguageCode();

  }

  Future<void> _fetchLanguageCode() async {
    try {
      // Retrieve the stored language code
      String? storedCode = await storage.read(key: 'code');
      print("Stored code locale: $storedCode");

      // Directly call setLocale with the retrieved language code
      setLocale(Locale(storedCode ?? 'en')); // Default to 'en' if storedCode is null

    } catch (e) {
      print("Error fetching language code: $e");
    } finally {
      // Set the loading state to false after fetching
      _isLoading = false;
      notifyListeners();
    }
  }



  Future<void> setLocale(Locale locale) async {
    print('SetLocale');
   {
      _locale = locale;
      print("Updated languagecode:$locale");
      await Localization.load(locale.languageCode);
      notifyListeners();
    }
  }
}

