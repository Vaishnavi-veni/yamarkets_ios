import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yamarkets_ios/screens/home/e_learining_courses/category.dart';
import 'package:yamarkets_ios/screens/home/e_learining_courses/model.dart';
import 'package:yamarkets_ios/utils/localization_utils.dart';

class ELearningCourses extends StatefulWidget {
  const ELearningCourses({super.key});

  @override
  State<ELearningCourses> createState() => _ELearningCoursesState();
}

class _ELearningCoursesState extends State<ELearningCourses> {
  String _selectedLanguage = ''; // Default language (initially empty)
  bool _isLanguageLoaded = false; // To track if the language has been loaded

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'en';
      _isLanguageLoaded = true; // Mark language as loaded
      Localization.load(
          _selectedLanguage); // Load localization for the selected language
    });
  }

  String _getVideoUrl({
    required String enUrl,
    required String thUrl,
    required String hiUrl,
    required String arUrl,
  }) {
    if (_selectedLanguage == 'th') {
      return thUrl; // Thai URL
    } else if (_selectedLanguage == 'hi') {
      return hiUrl; // Hindi URL
    } else if (_selectedLanguage == 'ar') {
      return arUrl; // Arabic URL
    } else {
      return enUrl; // Default to English URL
    }
  }

  @override
  Widget build(BuildContext context) {
    return CategoryPage(
      categories: [
        Category(
          title: Localization.translate('beginner') ??
              'Beginner', // Uses current language

          topics: [
            Topic(
              title: Localization.translate('Basic Forex Education') ??
                  'Basic Forex Education',
              subtopics: [
                Subtopic(
                  title: Localization.translate('Why Trade Forex') ??
                      'Why Trade Forex',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/EZn5H624MkKfimIKTyFQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/Rgwres5VUOGojGrXaZicg.m3u8', // Hindi URL
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/olsuZu72xkSQYbK9DirkAA.m3u8', // Arabic URL
                  ),
                ),
                Subtopic(
                  title: Localization.translate('When To Trade Forex') ??
                      'When To Trade Forex',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/7NL0KfxKM06IhlZwCmwNgQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/9k19bg5qjEWgcALgws0lw.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/XWJ361Ov50O4HBCDB2FsMQ.m3u8', // Hindi URL
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/8muLcMh90OAv30pIDMH0g.m3u8', // Arabic URL
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Trading Terminology Or Where Am I Going Long') ??
                      'Trading Terminology Or Where Am I Going Long',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/vMLmqhaaKkaPwEEkJQa2g.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/5j2pL7uDTkug7TBixDqA0Q.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/AuLSAVaAw06OFxBDkKumUg.m3u8', // Hindi URL
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/KyloMqAQLEq8N0rtzCqJYg.m3u8', // Arabic URL
                  ),
                ),
                Subtopic(
                  title: Localization.translate('How To Trade With Leverage') ??
                      'How To Trade With Leverage',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/YQgawliMkky1pZJJdHUDyQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/WPqiFxc5ZEmaWmeTEH64g.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/mWevxwubnUylXTPZzsAsSA.m3u8', // Hindi URL
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/yIZ7H0ptcEat8rZyj5NElw.m3u8', // Arabic URL
                  ),
                ),
                Subtopic(
                  title: Localization.translate('What Is A PIP') ??
                      'What Is A PIP',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/uetTtiMNGEOXOvQGr95qRQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/c6EFB0LOa0aS7o1d8zpVkQ.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/4o63qWWJak2NUPHx4nSvw.m3u8', // Hindi URL
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/E62cGkN8zEWOuVN1sSg.m3u8', // Arabic URL
                  ),
                ),
                Subtopic(
                  title:
                      Localization.translate('How To Place A Trade In Forex') ??
                          'How To Place A Trade In Forex',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/CU4xGFuD0ieMByfg1GWgA.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/iBLlfNCyI0aO7UIOMboPsQ.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/AdEPFxA61kW7PCXntGDq1w.m3u8', // Hindi URL
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/iFcPh6t7ik6cKXcvYcMMBw.m3u8', // Arabic URL
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Types of Forex Orders') ??
                      'Types of Forex Orders',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/UOKNSBrsvUyw92CQC1FxHw.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/aXpxks4rwUCQICCECH5Uiw.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/7BVaIkmzUehkr62Rgb8g.m3u8', // Hindi URL
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/U2jnYAjaskGyecV0L8mY4A.m3u8', // Arabic URL
                  ),
                ),
                Subtopic(
                  title:
                      Localization.translate('Technical Analysis In Forex') ??
                          'Technical Analysis In Forex',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/3Fknl7IhdEalUGTyHn43oA.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/9r3yZ4FvlkyTz0JZmTmTxw.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/wxXZd1yX6EK6ybZQvWyog.m3u8', // Hindi URL
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/XyqMFaxF8EO9fRtoSVhNyQ.m3u8', // Arabic URL
                  ),
                ),
                Subtopic(
                  title:
                      Localization.translate('Fundamental Analysis In Forex') ??
                          'Fundamental Analysis In Forex',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/7Khdqy72fE62Yz4LWxLMRw.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/gL8RvQxc0UWXgQjnR68x6A.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/VbUdDflUkyVQ1PEchhsw.m3u8', // Hindi URL
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/XNnjbE8GhEO3eM58RybWA.m3u8', // Arabic URL
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Types Of Forex Charts') ??
                      'Types Of Forex Charts',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/weZov9IU6J5IvmYcsbdQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/4qDJCjgAvkWwYb8VMENOQ.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/Vbe6KNAKv0qPCXpXW6SNNQ.m3u8', // Hindi URL
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/6ZdJTTMNF0i25pXOs6vTYg.m3u8', // Arabic URL
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Support And Resistance In Forex') ??
                      'Support And Resistance In Forex',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/xnCi0gEadtosigeYR5A.m3u8', // Replace with actual URL
                    thUrl:
                        'https://api.dyntube.com/v1/apps/hls/quiSZYjbHUWckcQcHtps7g.m3u8', // Replace with actual URL
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/yclp3IhbkmH4QnZ9bdCw.m3u8', // Hindi URL
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/4LDiq8ZD00WBrxSM6PhhA.m3u8', // Arabic URL
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Trendlines') ?? 'Trendlines',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/8wFFyJpmTkeLUulHfwcwg.m3u8', // Replace with actual URL
                    thUrl:
                        'https://api.dyntube.com/v1/apps/hls/uX8fRlI0qkyOCHlHEbLB1Q.m3u8', // Replace with actual URL
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/qTEmsnWk20astccuJsBHA.m3u8', // Hindi URL
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/AX4yl5nHIUSuD8Ix8HQvw.m3u8', // Arabic URL
                  ),
                ),
              ],
            ),
            Topic(
              title: Localization.translate('Fibonacci') ?? 'Fibonacci',
              subtopics: [
                Subtopic(
                  title: Localization.translate('Fibonacci') ?? 'Fibonacci',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/PtghRr3NOkyu7C0QKUDqg.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/NNrM433nuUapNYA3umluqQ.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/FJRZVT0JWkimrOGgn1wgAQ.m3u8', // Hindi URL
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/5q3ll3oWmk6fi7rZlaXMUw.m3u8', // Arabic URL
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Forex Fibonacci Extensions') ??
                      'Forex Fibonacci Extensions',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/4WlEpLH09Uu7liX8iw9IsA.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/RMOZxpM7UhlyuMi7A7Eg.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/YHdXmpRFkC2rnFJs4GeJg.m3u8', // Hindi URL
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/mZYyZMXnWUmsJuqhRc2h1w.m3u8', // Arabic URL
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Learn Forex Fibonacci Fan And Arcs') ??
                      'Learn Forex Fibonacci Fan And Arcs',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/PAI9y0YLdEe0X8frVya2FA.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/rpAxcShCcEmM2oWCZJ2tA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/U8rFq5GEEKlrxZw7PMAfQ.m3u8', // Hindi URL
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/hqSN4qMvkuvDXkXl88Lzw.m3u8', // Arabic URL
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Learn Forex Combining Fibonacci With Other Technical Analysis Tools') ??
                      'Learn Forex Combining Fibonacci With Other Technical Analysis Tools',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/xfqSJqShUCDl8RoyipoCw.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/QB9tlOFYL0uM0HEbY59f9A.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/GdoofXoh5ESVcCJ6eqSxVA.m3u8', // Hindi URL
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/DVGgqza0Ke7FqYluSUA.m3u8', // Arabic URL
                  ),
                ),
              ],
            ),
            Topic(
              title: Localization.translate('Understanding Candlesticks') ??
                  'Understanding Candlesticks',
              subtopics: [
                Subtopic(
                  title:
                      Localization.translate('Candlesticks') ?? 'Candlesticks',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/Ct1HhUDYhkygnjTrnUVAHQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/NMvltR0KjkCb17EoTUZJKQ.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/TqlvqeEmlUOHION5eZCOAg.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Doji Candlestick In Forex') ??
                      'Doji Candlestick In Forex',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/IqvKzVjk4UGRgZXRgUVfJg.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/5EodTKNJf0SwWLRM6s7fA.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/5Ol9dFy5UW8gxxdopg9A.m3u8',
                  ),
                ),
                Subtopic(
                  title:
                      Localization.translate('Marubozu Candlestick In Forex') ??
                          'Marubozu Candlestick In Forex',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/nJ2sRqjHO0a44jpCCotbGw.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/kbfqYsTaPkmslzLYcw0f9w.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/FZyjZTKoeUixCkQHnbFhiw.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Hammer And Hanging Man Candlesticks') ??
                      'Hammer And Hanging Man Candlesticks',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/brj4pr3ka0GcW3mEwTm0JQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/giOWjs6ul0K6At5EgQKaEA.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/TbCHNg1mb02JJMEvX79pg.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Shooting Star And Inverted Hammer Candlestick') ??
                      'Shooting Star And Inverted Hammer Candlestick',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/6sKCxKve9kmEi39vD9tbiQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/vj6tKJQ4TEmrcgfwmDnhfw.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/3KVMTJSAEt5rrogSqsgQ.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Bullish Piercing Pattern') ??
                      'Bullish Piercing Pattern',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/vTNieiz5Zk26SCBTxhEA.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/8U6J85UvBkYVorusSmq6w.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/35jUU0yrt0KSXay7vUnSYg.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Dark Cloud Cover Pattern') ??
                      'Dark Cloud Cover Pattern',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/6I16iNXdeUSfirADwI3XQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/PlyKQ79P9UCnQLi54zEjyw.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/n7GkxTDoB0itAzgVwghKFg.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Bullish And Bearish Engulfing Patterns') ??
                      'Bullish And Bearish Engulfing Patterns',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/judvqQ7EESYVZGLVQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/DSzeR5DQvUK76ULNsdfeQ.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/9fvPROlAEC2qk57TI3v1g.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Tweezer Tops And Bottoms') ??
                      'Tweezer Tops And Bottoms',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/1u9jZ7nKE0KQkAHZjEtw.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/fhtuGM7900WyccQJ6O48Tw.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/CKfCY9QaU2TzIBas4q06g.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Morning And Evening Star Patterns') ??
                      'Morning And Evening Star Patterns',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/4YEvvOxukmHJuIlkQ1sSg.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/CIf1gpfMUkqDMjIMKxmRQw.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/DuzTHiNtIkq8EQyxhW74gw.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          '3 White Soldiers 3 Black Crows') ??
                      '3 White Soldiers 3 Black Crows',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/ftP4h6RgeUaMJbrfH8uYw.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/dFJ1RAIjCOg8qIN2mrRmtg.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/9MT1a4a3AcGSVsLeTV5siQ.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          '3 Insideup 3 Inside Down Pattern') ??
                      '3 insideup 3 inside down pattern',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/live/videos/DkRyWwyGd0WOwMdsCAQSBA.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/apps/hls/nrLuywQ4KEeUzmk34v7m3g.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/BmEaXyoEECJdZqVaWThgg.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/WDOQHu2fEa9ZVHYYpcWzw.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Rising And Falling Three Methods') ??
                      'Rising and Falling Three Methods',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/live/videos/JKzOTn3lG0Q1p4hoRpUpw.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/apps/hls/oC8UPkBG0E6WwrnGBxhsg.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/XiPSAH2Wn0qp0eEbePBHLg.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/TqbqBc8zMEy5pAww166frA.m3u8',
                  ),
                ),
              ],
            ),
            Topic(
              title: Localization.translate('More Chart Patterns') ??
                  'Chart Formation Patterns',
              subtopics: [
                Subtopic(
                  title: Localization.translate(
                          'Forex Double Top And Double Bottom Formation Patterns') ??
                      'Forex Rectangle Formation Patterns',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/DMOwVhH5vUSyOgeNp6zytg.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/qTnT5MhL30KBNUuJLId74A.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/XtBcUxJcoUOwv9a9pTHAag.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Learn Forex Head And Shoulders Pattern') ??
                      'Forex Broadening Formation Patterns',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/eVl5FX1lkkincjO2zXvLTQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/Dg8bcxghEGFQA9qJeoIiA.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/afjsI1bRl06aeDJzb7CRA.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Forex Inverse Head And Shoulders Pattern') ??
                      'Forex Triangle Pattern',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/UHIKIaDfgknw5IW4y8g.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/hBOPMS8S00qYhwJeVSoqTg.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/Q1WNulAQLkaMzXItrPLsqA.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Forex Bull Flag Formation Patterns') ??
                      'Forex Rising Channel Patterns',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/R0c80SE0mxvNmtpPeQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/qxH5qAFumUGtk3VuCfeICw.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/Pw9J4bHnTEiW9YqRvwy8BA.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Forex Bear Flag Patterns') ??
                      'Forex Falling Channel Patterns',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/UqE9ylswOEKnnywa53M6lw.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/gjB7wRfEQ06MkgP1cXSWyQ.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/bN6vXKbUqXIiUumEhlOQ.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Forex Bullish And Bearish Pennant Formation') ??
                      'Forex Pennant Patterns',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/JrwNZj3h0GDkpTXCoY1Wg.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/u1ggOg9N50icGovK4wmsvA.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/4zAWC6Cfp0qNLSACbr6Gg.m3u8',
                  ),
                ),
                Subtopic(
                  title:
                      Localization.translate('Forex Falling Wedge Pattern') ??
                          'Forex Ascending Channel',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/SlcIfTWcdkqPHi64jY25A.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/rdz10yjA06caaf1kalwgQ.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/16wmnvsTvkOz0yjF5Nco1w.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Forex Ascending And Descending Triangle Formations') ??
                      'Forex Descending Channel',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/VXKgDhT2xEWBQ95JIBUhw.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/0bWOfGv1kieFSBJthsaA.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/afjsI1bRl06aeDJzb7CRA.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Forex Symmetrical Triangle Pattern') ??
                      'Forex Symmetrical Triangle Pattern',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/YsBEg0DQkCcZChVKlZzw.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/CxuKbPELEuM1GYbKzViVQ.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/YsBEg0DQkCcZChVKlZzw.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Forex Box Range') ??
                      'Forex Box Range',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/1JqM1f5Lp0OWGHdK9yk.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/u1ggOg9N50icGovK4wmsvA.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/4zAWC6Cfp0qNLSACbr6Gg.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Forex Cup And Handle Formation Pattern') ??
                      'Forex Cup And Handle Formation Pattern',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/YsBEg0DQkCcZChVKlZzw.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/rdz10yjA06caaf1kalwgQ.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/XtBcUxJcoUOwv9a9pTHAag.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Forex Inverse Cup And Handle Pattern') ??
                      'Forex Inverse Cup And Handle Pattern',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/EoarG9oPb0ySSGp8SrkDMg.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/apps/hls/2Th9McJSa0q8rEOnOv5mcA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/uLPlb5aWaki3cue9RmyDvw.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/jrs645KBnUiUuGCZ4MIakQ.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Forex Rising Wedge Pattern') ??
                      'Forex Rising Wedge Pattern',
                  videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/2hgKKSsf00yxzXvos9gzSw.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/EChdJcbdi0qzPy2QiXBYA.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/ZASskG2rvUS2gkMNaEeZA.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/zSOsaVLkdkmKSc6kEla1DA.m3u8'),
                ),
              ],
            ),
          ],
        ),
        Category(
            title: Localization.translate('intermediate') ?? 'Intermediate',
            topics: [
              Topic(
                title: Localization.translate('Forex Indicators') ??
                    'Additional Forex Indicators',
                subtopics: [
                  Subtopic(
                    title: Localization.translate('Forex Indicators') ??
                        'Additional Forex Indicators',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/eHKsxkH33ECa69E8OTnHHg.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/X6VudjnTEaqixtR3trJsQ.m3u8', // Updated Hindi URL
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/MhX7l2ftrEuzbqWZNg.m3u8', // Arabic URL
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate(
                            'Forex RSI Stochastic Oscillator') ??
                        'Forex Support and Resistance',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/EGKczgkKk29zGw0irvhLA.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/HEnyNWNGAUDgViDzRa31g.m3u8', // Updated Hindi URL
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/MhX7l2ftrEuzbqWZNg.m3u8', // Arabic URL
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate(
                            'Forex ATR Average True Range') ??
                        'Forex Fibonacci Retracement',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/hzgZauuEipdWuKJZ7OnQ.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/Scy5LFugKkazunehgALEJA.m3u8', // Updated Hindi URL
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/MhX7l2ftrEuzbqWZNg.m3u8', // Arabic URL
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate('Forex Moving Average') ??
                        'Forex Harmonic Patterns',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/cBfct2bjEyP1KRzT47Rg.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/mapNezX2DUqfyrFpZpVG5A.m3u8', // Updated Hindi URL
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/MhX7l2ftrEuzbqWZNg.m3u8', // Arabic URL
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate(
                            'Forex Moving Average Convergence Divergence MACD') ??
                        'Forex Candlestick Patterns',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/tabHCF56UOkKmpGdNx49w.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/0hjPTO7UkuAjwfgrqgH8Q.m3u8', // Updated Hindi URL
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/MhX7l2ftrEuzbqWZNg.m3u8', // Arabic URL
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate(
                            'Forex Average Directional Index ADX') ??
                        'Forex Supply and Demand Zones',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/T41oJPCP6UiRVgITXj6Hw.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/Yk8MjegJ0uO6WxiHUc2cA.m3u8', // Updated Hindi URL
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/MhX7l2ftrEuzbqWZNg.m3u8', // Arabic URL
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate('Forex Bollinger Bands') ??
                        'Forex Elliot Wave Theory',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/6PZtwIk6w0ykNDBQHk9DoQ.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/qvmUkuzAUa93j1TFNwhJg.m3u8', // Updated Hindi URL
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/MhX7l2ftrEuzbqWZNg.m3u8', // Arabic URL
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate('Forex Parabolic SAR') ??
                        'Forex Gann Theory',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/Vhrexejdt0aZ5qmmPnbw4g.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/SFR4AKgqIEWlCFqDYaiyUQ.m3u8', // Updated Hindi URL
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/MhX7l2ftrEuzbqWZNg.m3u8', // Arabic URL
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate('Forex Ichimoku Kinko Hyo') ??
                        'Forex Chart Patterns',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/0WjiXoE8jUqnYdhWI3E2vg.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/exQkMqCG0SIxJLF2NDgQ.m3u8', // Updated Hindi URL
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/MhX7l2ftrEuzbqWZNg.m3u8', // Arabic URL
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate('Forex Pivot Points') ??
                        'Forex Fractals and Timeframes',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/vQw3LYQAoUSVMmhbWFlyA.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/OyangFVUvUSJ9OmDiBgteg.m3u8', // Updated Hindi URL
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/MhX7l2ftrEuzbqWZNg.m3u8', // Arabic URL
                    ),
                  ),
                ],
              ),
              Topic(
                title: Localization.translate('Timing in Forex') ??
                    'Timing In Forex',
                subtopics: [
                  Subtopic(
                    title: Localization.translate(
                            'Timing Your Entries When Trading Forex') ??
                        'Timing Your Entries When Trading Forex',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/YpwsWSo0N06lMnq8dNvTNw.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/2EeR6mcnJUyAo7l6VoTlUA.m3u8', // Hindi URL
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/MhX7l2ftrEuzbqWZNg.m3u8', // Arabic URL
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate(
                            'Timing Your Exits When Trading Forex') ??
                        'Timing Your Exits When Trading Forex',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/XSHg99jGSEa5mDdvPI1a7w.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/T4nHA47SVEq2hr8BNpAByw.m3u8', // Hindi URL
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/MhX7l2ftrEuzbqWZNg.m3u8', // Arabic URL
                    ),
                  ),
                ],
              ),
              Topic(
                title: Localization.translate('MT4') ?? 'MT4',
                subtopics: [
                  Subtopic(
                    title: Localization.translate('Getting Started With MT4') ??
                        'Getting Started With MT4',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/yS9Sa9zRbEqbPVEymdEU8w.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/ofujIYsx1EKUuqbww9At1A.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/lUcopMGTUUmWSYHpHKg1Q.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/tpJySvckkibqGtlouOb5g.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate('Market Watch Basics') ??
                        'Market Watch- Basics',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/mes248cQb0qRCNyEzP8jg.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/cJfL1XQHki0hYGsA53ttQ.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/SqdG4aRuUmDKgJmdSqPYw.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/anPDu1EcktlBkQRWBkXw.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate('Chart Window Basics') ??
                        'Chart Window Basics',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/tS9JROdrWEi8r9XWyAYIsg.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/4zx9pcBeE6fCUNnUoGtMw.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/SqdG4aRuUmDKgJmdSqPYw.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/hU9spHO1AkOFpiBb0VUypA.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate(
                            'Terminal Window Basics - Part 1') ??
                        'Terminal Window Basics - Part 1',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/KNTIG5Yy0SMvIIMIuvzg.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/4fNJpihU7kyCJsZ31Wc2gA.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/R5gYwlWr3US1doyIi6fwOw.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/hP0vBiPZI0ilWTDXChUhGw.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate(
                            'Terminal Window Basics - Part 2') ??
                        'Terminal Window Basics - Part 2',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/Zs97E5RFp0yNLoHVAoLBNQ.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/r8CpcKmiNUOjT1s2zYeLCQ.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/R5gYwlWr3US1doyIi6fwOw.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/mowrDE3L5EKPxthWewvzBQ.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate('Navigator Window Basics') ??
                        'Navigator Window Basics',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/ewrETVlH3EOcWfKmWuUsdQ.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/mXfYgNw5EmpM1y8Eu5cCQ.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/AkqJy8ZQEmBJ2Dr8ZLw3g.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/91zO1bfKEUG63nT463M8qw.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate('Placing Orders') ??
                        'Placing Orders',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/mPoc1SVRj06qesz8BYBOQ.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/dpP01KeXECIY61Q0SpAmg.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/IxkRDlUkSriGxCOJRpTA.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/2dQqTUwKUSe95DOeFuzQ.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate(
                            'Account History - Closed Trades') ??
                        'Account History - Closed Trades',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/IxLCPJXtkOMQxTKdJXYHw.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/oWD4EBD0kOXMVVbui0Jhw.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/GbGPMQoxG02L9UX0HIzA1w.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/fQJqIOmnO0y3S1BvO9Ihvg.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate('Market Watch Detailed') ??
                        'Market Watch Detailed',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/efw6n3peHUWWKL0gEX27Q.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/0nj3M137kKEteARdKslIw.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/DnXSRk9Qpk2CwI5fO4ynzQ.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/BAPaWhKOkKNXVcAGdc5WA.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate('All About Charts') ??
                        'All About Charts',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/dErXY3URkGtXKtTvm4aBw.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/8of2VkEvI0Gjr7Fl7xAw.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/ND0EqpUyH0qCDi7KslaHMw.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/Zd5YEwnHH0mQBr2yDd3N7A.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate('Chart Window Properties') ??
                        'Chart Window Properties',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/0TgpK43ihUuwsZBtb4k83w.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/AfHfkpby5EqgRFYxpl3Q9Q.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/AkqJy8ZQEmBJ2Dr8ZLw3g.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/PRHr0ZYqT4ZDE6XxSAl8hg.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate('Indicators and Scripts') ??
                        'Indicators and Scripts',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/wT0VCKy42k2t2tjzFW1czA.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/rnNi29qDd0uBYQfjsGrEYg.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/AkqJy8ZQEmBJ2Dr8ZLw3g.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/G569yKZ7ykebsbEAHn6pPA.m3u8',
                    ),
                  ),
                ],
              ),
              Topic(
                title: Localization.translate('Cryptocurrencies') ??
                    'Cryptocurrencies',
                subtopics: [
                  Subtopic(
                    title: Localization.translate(
                            'Background - Early Digital Currencies (1980-2009)') ??
                        'Background - Early Digital Currencies (1980-2009)',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/ce6ho74PakuuzFzrl4QXg.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/ywp3wH53lEanjhBxDm0xmg.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/jrPxrnxeWE8h9cmn7VTg.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate(
                            'Evolution Of Blockchain And Cryptocurrencies') ??
                        'Evolution Of Blockchain And Cryptocurrencies',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/gM0TXi8v0iW3CRW5O1jaA.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/Ia2GP7hqAECGVwdyFKk3Q.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/NZPL64snHdNR11RdhXY0A.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/u6fPzpXOYEeavLr8jJKarw.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate(
                            'The Future Of Digital Currencies And Blockchain') ??
                        'The Future Of Digital Currencies And Blockchain',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/QJwclFsx0KjzGqMMVLSg.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/lznsrazaeU4N7MZ5aIuLw.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/4jDlT2pmPsmOktO7x0XZ3.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/uR2crUt4WEesRSgjs64CHA.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate(
                            'Background - Concept Of Owning A Digital Currency') ??
                        'Background - Concept Of Owning A Digital Currency',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/QJwclFsx0KjzGqMMVLSg.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/iUP1kyVEaUWgkfILHjt8Tg.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/Yz9pX2dOzLsYmM8v3QWo.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/ddwO692irkWpVzrTx3RAPQ.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate(
                            'What Are Wallets And How Do They Work') ??
                        'What Are Wallets And How Do They Work',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/J9UC3juOEGF3DHj3qs1vA.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/1eyyXASyOUSQI5mws18og.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/Qr8kV6oPzYxw3Wj4mU7k.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/LnJla48IUub7qEm9hvO2w.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate(
                            'Backups & Offline Storage - Why Is It important, How To Do It') ??
                        'Backups & Offline Storage - Why Is It important, How To Do It',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/J9UC3juOEGF3DHj3qs1vA.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/0gf93eUbkmw1RAaj3ahw.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/Kx1mY7oPzVr9WkX6rUtQ.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/nyPxbYd3ZUmgjPIArdE6w.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate(
                            'Mobile Security - How To Safely Protect Your Mobile Wallet') ??
                        'Mobile Security - How To Safely Protect Your Mobile Wallet',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/J9UC3juOEGF3DHj3qs1vA.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/UU8QZBezzECuPVbVI4WYg.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/Hv6mX9pPyVq2NkY7qUbR.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/5A3YJhZm0GiHb5N3Kk1g.m3u8',
                    ),
                  ),
                  Subtopic(
                    title:
                        Localization.translate('Types Of Crypto Currencies') ??
                            'Types Of Crypto Currencies',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/GLMu0wQQCkqPsRjTsSQ65Q.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/wNEFBlxiukWi0rhudvb9Xg.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/Gn4mY9pNyVq3MjY8sWbH.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/tZO8oJ594kyHtuHVO4Y0Dg.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate('What Is Bitcoin') ??
                        'What Is Bitcoin',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/GLMu0wQQCkqPsRjTsSQ65Q.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/534uu0DvmUuNyPeti9YdMA.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/Kz5mV8lOpRz9Kn3qXcTg.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/Y3vZG8MGO0aXYOl1UJtvDg.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate('The History Of Bitcoin') ??
                        'The History Of Bitcoin',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/GLMu0wQQCkqPsRjTsSQ65Q.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/DfW7LsUjd0unh7dlbGaKKw.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/Qz9mW3nLpRq8Xl6pYtWq.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/wlmHd6iIfkKbmZsIunTQxg.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate(
                            'Ways To Use Bitcoin Besides Investing') ??
                        'Ways To Use Bitcoin Besides Investing',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/GLMu0wQQCkqPsRjTsSQ65Q.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/BuhbuIj4KUUyq1pJlGaJg.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/Qz6tW5pLzWr9PqT4hW8x.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/pWXfD6kki0yhjOnYUyjXdA.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate('How To Invest In Bitcoin') ??
                        'How To Invest In Bitcoin',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/GLMu0wQQCkqPsRjTsSQ65Q.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/PzZbjlbacEyIIcZybcJmWQ.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/Ft9sP8jWzVr6Gx5bKvXj.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/eMK7qE50mMYvQgqT6Lg.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate(
                            'What Are The Risks Involved In Bitcoin Trading') ??
                        'What Are The Risks Involved In Bitcoin Trading',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/wHYHIcBHUKS2KeWpMwENw.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/IDdcYJTF00GMdvLfQtG7bQ.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/Jy8qV7nXzRt9Np2pLqTk.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/H9whABMWZ06qcu0StPUhA.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate('How To Buy Bitcoin') ??
                        'How To Buy Bitcoin',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/ydnDv3B22ESSikc4sLKVZg.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/nfHZNChakqUhC8G8muPXg.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/Yz5wQ8mPzVq7Kr9tRmXl.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/hwaaXgunW0SrcHGbRExhWQ.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate('Why Accept Bitcoin') ??
                        'Why Accept Bitcoin',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/ydnDv3B22ESSikc4sLKVZg.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/X97veqXsUOjjEehVQyO7A.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/Rh4mT7pJzTq9KnX6sV8z.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/psfYts4ZMEueqPM63sEBA.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate(
                            'What Are The Risks Involved In Using Bitcoin') ??
                        'What Are The Risks Involved In Using Bitcoin',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/ydnDv3B22ESSikc4sLKVZg.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/K4k7lCdiyUiN5VosB6kaw.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/Xz5rP9mQyWp4Kn3hVqA7.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/xf8dK9KeI0asNpN61RqZMQ.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate(
                            'How to Accept Bitcoin For Services Or Goods') ??
                        'How to Accept Bitcoin For Services Or Goods',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/ZmthYF75UmpvShFPRYEKg.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/7lkqmtSDI0Wqi9NXltCTig.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/Vy5tW7pKzXw9Pq6rQ8tX.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/Kxy80cNl0O1JqBvtdF4Qw.m3u8',
                    ),
                  ),
                  Subtopic(
                    title: Localization.translate(
                            'Outlook On Taxation, Accounting & Legalities') ??
                        'Outlook On Taxation, Accounting & Legalities',
                    videoUrl: _getVideoUrl(
                      enUrl:
                          'https://api.dyntube.com/v1/apps/hls/D5041hAMKk2SVPMoMd2t8w.m3u8',
                      thUrl:
                          'https://api.dyntube.com/v1/apps/hls/gKtOsqudEUSD5crGJETfg.m3u8',
                      hiUrl:
                          'https://api.dyntube.com/v1/apps/hls/Qx7rT5mPzWp9Xj8bP5vB.m3u8',
                      arUrl:
                          'https://api.dyntube.com/v1/apps/hls/Dt4EkKIEOEerDC6HvWySg.m3u8',
                    ),
                  ),
                ],
              )
            ]),
        Category(
          title: Localization.translate('advanced') ?? 'Advanced',
          topics: [
            Topic(
              title:
                  Localization.translate('Introduction To The Stock Market') ??
                      'Introduction to the stock market',
              subtopics: [
                Subtopic(
                  title: Localization.translate(
                          'Introduction to the stock market') ??
                      'Introduction to the stock market',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/oeFKCJe8Uuu1wb2f4TaSQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/GpRCCUPkLkCo9KwF0Lm7Sw.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/qaSsaZK2kyFeJxTsNA7gg.m3u8', // Updated link
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Can Stock Charts Predict The Future & Trading Systems') ??
                      'Can stock charts predict the future & Trading systems',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/OG0t8serH0ybOryEtqGISA.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/yli9HQQLTE6gK9TxpjlkaA.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/dMjImKn4q02dbKR9dpjFBw.m3u8', // Updated link
                  ),
                ),
                Subtopic(
                  title:
                      Localization.translate('Support And Resistance Levels') ??
                          'Support and resistance levels',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/QSLatMg23kiWdkbOLlyhA.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/PYcytzEYD0qHuPNkU0DQ.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/ezJLUhHJwU2h16qLoVtlMA.m3u8', // Updated link
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'How To Identify A Market Direction - Part 1') ??
                      'How to identify the market direction - Part 1',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/yOr3i6mHEefvlGuvKV0oQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/sXIIEuu6rUyZJpcAEYwl5A.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/EZIxkYqwvkabu1sXyccGjQ.m3u8', // Updated link
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'How To Identify A Market Direction - Part 2') ??
                      'How to identify the market direction - Part 2',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/yOr3i6mHEefvlGuvKV0oQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/sXIIEuu6rUyZJpcAEYwl5A.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/Pl7tEPEuEESjUbAKyIOsUQ.m3u8', // Updated link
                  ),
                ),
                Subtopic(
                  title:
                      Localization.translate('Chart Patterns Introduction') ??
                          'Chart patterns Introduction',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/51GwLEK05kKRqxNFEpjVpA.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/qaSsaZK2ky.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/Ov43X6m0yoV70fonzJOQ.m3u8', // Updated link
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Symmetrical Triangles') ??
                      'Chart patterns Symmetrical triangles',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/51GwLEK05kKRqxNFEpjVpA.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/qaSsaZK2ky.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/yT97CGaMZ06eOP931r37Bg.m3u8', // Updated link
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Symmetrical Triangles Trading Strategy') ??
                      'Chart patterns Symmetrical triangles trading strategy',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/51GwLEK05kKRqxNFEpjVpA.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/qaSsaZK2ky.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/RSHkIhiF3kW1ZSeC8x2MoA.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Flags And Pennants') ??
                      'Chart patterns Flags and pennants',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/51GwLEK05kKRqxNFEpjVpA.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/qaSsaZK2ky.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/1tJPsfMmkNaMWUe7WHeQ.m3u8', // You can continue replacing the rest of the links similarly.
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Ascending Triangles') ??
                      'Ascending triangles',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/Wfng68pTEKIMqvBy9XA.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/apps/hls/ZnsTbWFEskewVVP2cm9P2g.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/XaDlWZIobkd87PGou1S1A.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/eSwQpxcEuzu5QCmF7VlA.m3u8', // Updated link
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Ascending Triangles Trading Strategy') ??
                      'Ascending triangles trading strategy',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/y565qrE2E0qGHIhkoXX4rA.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/apps/hls/lfEjxXlgkuCazXPVw7tQ.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/rgugq1A5U0jsek3rvXH8Q.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/Q3sgUpxL0022YxP8TAopAg.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Volumes And Trends') ??
                      'Volumes and Trends',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/ANdzal8oXU2mi4Kuj4bD6g.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/apps/hls/AfMTDEbXVEmcu152OjTXRw.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/kOp2AHkmgqCqVGKPA.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/wWHKf7xJqUGTVAi2WN1vPQ.m3u8', // You can continue replacing the rest of the links similarly.
                  ),
                ),
                // Continue similarly for other Subtopics...
              ],
            ),
            Topic(
              title: Localization.translate(
                      'Advanced Stock Market Trading - Level 1') ??
                  'Advanced Stock Market Trading - Level 1',
              subtopics: [
                Subtopic(
                  title: Localization.translate('Market Indicators') ??
                      'Market Indicators',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/3i7Y1OPgEeG1SHwzs5Q7w.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/divHxRGLwU2T4FlESR5MUQ.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/jUZDCyNWkCSRgxwqqONUg.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Trading Methodology') ??
                      'Trading Methodology',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/rewYJGwYEaIfjDyZh0Yvw.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/pIgz4GngkCXwiXyzZHJ7Q.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/lZD49AptKEeTuexoWHo7GQ.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Round Numbers') ??
                      'Round Numbers',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/lyPEHJfffUCKPZ4iE3Nl7A.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/87B1rXTQHEqHyPMIt9oaiw.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/VpmG6wmu5Eeufs2jIYCvg.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Setting Up A Trade') ??
                      'Setting Up A Trade',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/tje2aXVCkkurdhRnMHSthA.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/c6GTJqvzEe2hRBEPkMN1w.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/U7ruWkV6AE20RXGtYa39Q.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Technical Analysis For Professional Traders') ??
                      'Technical Analysis For Professional Traders',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/i7NBA3uhLEajhxi6xqZG9A.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/sKXfDRYePE29A4nYiaPJfw.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/wbvW97btXEmZUaOWQsJjdQ.m3u8',
                  ),
                ),
                Subtopic(
                  title:
                      Localization.translate('Practical Technical Analysis') ??
                          'Practical Technical Analysis',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/uhdrkocKUSreMmmln1K5w.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/bEcmq4zV5EeQO4trgT3IbA.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/cMXKDOnKrUq3ub4h2ldrA.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Trading Psychology') ??
                      'Trading Psychology',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/6Gl5FsET0KcXsUURJ9FBA.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/Av2YIqZoVk6gBrjv5C42w.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/qH5eIc2E80iUOP8LtbaabQ.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Risk & Position Management') ??
                      'Risk & Position Management',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/6jK0QIKNY0KtSSYsgf0MuQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/RdqK6Pb8wEo3C4OV46IRA.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/tzweELFc1US1sZp1cS4gFw.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Intra-Day Trading') ??
                      'Intra-Day Trading',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/RyG98SUmNSqasgYuRQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/SC5BCLCHD0eW7GSO6BFJQ.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/phYRzwM8ckqT3LJjPXuAA.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Trading Arbitrage') ??
                      'Trading Arbitrage',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/hvdi25UYmUivonqQMmW8xw.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/y2dfqdpseka6D4TgNEyYgw.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/CO3kCS1nm0K1mM3UoAVUVA.m3u8',
                  ),
                ),
                Subtopic(
                  title:
                      Localization.translate('Trading Preparation & Sectors') ??
                          'Trading Preparation & Sectors',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/0vPsHi0MAEygxudR1g1wg.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/cEM1LP2sF0Gi5OSonJeFRQ.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/tN3c9UJLpEWncBnqrzx3qw.m3u8',
                  ),
                ),
              ],
            ),
            Topic(
              title: Localization.translate(
                      'Advanced Stock Market Trading - Level 2') ??
                  'Advanced Stock Market Trading - Level 2',
              subtopics: [
                Subtopic(
                  title: Localization.translate('Trading Small Caps') ??
                      'Trading Small Caps',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/e9YFPuLaWUiOsJLmCs2ObQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/8dg7bihIiESzIIz9wAJW4A.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/8Ypali7Jp0yEQsrpPPUqOg.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Identifying Institutional Tactics And Copying Them') ??
                      'Identifying Institutional Tactics And Copying Them',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/Zc9iA08m1EuJMRwu20iMSQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/MzYjIMCzEqz1W7tKSqVmw.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/EEgPrUC1q0ePHBoOB6srA.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Using Hot Keys') ??
                      'Using Hot Keys',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/huqH2nQh2k2DQF0JigRqw.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/QipuHiFIUkmshqk5DhBMjg.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/5zxJQCbcoUSXZ8zUvTxS4g.m3u8',
                  ),
                ),
                Subtopic(
                  title:
                      Localization.translate('Advanced Use Of Time & Sale') ??
                          'Advanced Use Of Time & Sale',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/n2HvNbrce0Sq9z5Eb1jgSQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/wrOEmtP6kuRKubhFgN0OQ.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/zNUsHop3nE6unwfPBP3iCA.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Manage “Watch Lists”') ??
                      'Manage “Watch Lists”',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/WXfe74qp5ELVLYkRWfQEQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/5hs0FSFE7EyEtxvTB4Tuew.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/bOTMwFTpukaimiu6PNyqhg.m3u8',
                  ),
                ),
                Subtopic(
                  title:
                      Localization.translate('The Fixed Quantities Paradox') ??
                          'The Fixed Quantities Paradox',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/tMcBKYfupUWcVF4tnYGHdg.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/lcxvSUpYj0qBDlsKnoHQgQ.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/fxNiv5WpAESVR41sMQudBQ.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Identifying “Trade Traps”') ??
                      'Identifying “Trade Traps”',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/mGWYxPTpCkSd3pfEMtuTpA.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/EZBee4lEUEqiD4g0x01mzw.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/KIWAMQRUK0K9FeuXvRjRXQ.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'The “20 20” Method - How Do Experts Read The Chart') ??
                      'Finding Trading Edge',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/Dzbt5f7zkGRfn69VlJJEg.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/K6ETsa33tEayvrd40Toig.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/eQKPxsZ13EOMzuTsKIhiyQ.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'How To Trade Using Failure Patterns') ??
                      'Identifying High Probability Trades',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/Jnd6D1PE9EqGovcVvk0pIw.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/bZmDinKoU06zWOG2UmdI6w.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/3TYP4p4XtEywULoiHDJGA.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Using NRB And WRB Candles') ??
                      'How To Create A Trading Plan',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/3YfT3tjHo0afI9KIsEykaQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/mnsIAgcXTkKkAQqmS32CAg.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/6ozKesjQEJMNHcTRVS7w.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Trading IPOs - Day Trading And Swing Trading') ??
                      'Creating Stock Market Reports',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/qozSAlSTOkeOdKkubLV5A.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/hvdi25UYmUivonqQMmW8xw.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/cEWE74AmSEOYKmGmERxpA.m3u8',
                  ),
                ),
              ],
            ),
            Topic(
              title: Localization.translate(
                      'Advanced trading tools and techniques') ??
                  'Advanced Trading Tools And Techniques',
              subtopics: [
                Subtopic(
                  title: Localization.translate('Introduction to MT5') ??
                      'Introduction To MT5',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/sttHfsNmEm9ppjRSG2IFg.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/apps/hls/ujbCjfIaTE6r2XQqHk9VAw.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/YtUXwzeGGk6XPvkh2RpL7A.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/D4QgDOeJ5Uq9NdtyqGX1RQ.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Forex Markets Basics and Trading Examples') ??
                      'Forex Markets Basics And Trading Examples',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/aFBjeM6A4kSasLgU7eKZg.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/apps/hls/SF3TgJwJ7kuQKUyvFyfS9w.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/8vXsjBgVd0uN8Y2pMztUg.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/vT0tXnqMXEi8Jt9q4R2E0A.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Commodities Markets Basics and Trading Examples') ??
                      'Commodities Markets Basics And Trading Examples',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/zhgf3PW6kSunZMIzzy04g.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/apps/hls/GjzcXE2e06lxvMZroykoA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/Wiz64IEieECBVk8OtlrVQ.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/We1MQ2IyG0iSdZhMdqZTQ.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Trading Global Indices') ??
                      'Trading Global Indices',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/lyB6PVnw4kysUoeJ6g4YrQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/apps/hls/aHsVTSaKuEGWXY8HQpBL3g.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/xTdee46klEubncTOmqVSDQ.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/6cgh9UBT3UygqUCkCSOdow.m3u8',
                  ),
                ),
                Subtopic(
                  title:
                      Localization.translate('Market News Trading Technique') ??
                          'Market News Trading Technique',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/gJ80APwdkm6O0HV6utQ.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/apps/hls/eytJSGSz0GP4YNpcyp9g.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/1HKILtEGlEGuSFWaBchfQ.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/xnwUl4apk6BseBj2XrSQ.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Trend Trading') ??
                      'Trend Trading',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/BsaGF73LeEetYv69s0A.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/apps/hls/5CSdYiZXdEGXUAWBWxc9uw.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/5HejccGcUutisMtsGjLw.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/60t4EVFpuUaIne5gfCNIXA.m3u8',
                  ),
                ),
              ],
            ),
            Topic(
              title: Localization.translate('Top Traders') ?? 'Top Trader',
              subtopics: [
                Subtopic(
                  title: Localization.translate(
                          'Advanced Trading And Technical Analysis') ??
                      'The Rise Of Bitcoin',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/u8oVtdVZHUm0x8zTAautEg.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/sH8mHbj4E60Ia8PRBOWdQ.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/ampfDc0skYRsEiZqBALg.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Advanced Stock Trading Strategies - The Trailing Stop') ??
                      'Bitcoin Halvings & Market Cycles',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/7gocv7VI06SjWBHdTp2Uw.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/live/videos/iuKjEbjHak2AbMxwz3vT0w.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/4Ys769HxzUaiRk0rwvS1tA.m3u8',
                  ),
                ),
                Subtopic(
                  title:
                      Localization.translate('Pivot Points In Stock Trading') ??
                          'Initial Coin Offerings (ICOs)',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/L8Ty7KgSNUmkM5salXqEkw.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/zniUTtngE0GYxuTI6Ijbg.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/UK6Be0SieU2yvZqnpC00CA.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate(
                          'Trade According To Game Theory') ??
                      'Market Regulations',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/6ftNclCVEkVdzZttsHKVA.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/H9W6qsOF8EeMdXfzZJ3kw.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/mRqzIonku9M4W6MEogQ.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Practice VWAP Strategies') ??
                      'New Types Of Trading',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/5CSdYiZXdEGXUAWBWxc9uw.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/live/videos/0Mr5dNsqUeeviPrXXBelA.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/TrFMuKXjEuGFVwDAlEFHA.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/y10whV7cwkKMDmlcR9vChg.m3u8',
                  ),
                ),
                Subtopic(
                  title: Localization.translate('Trade Management') ??
                      'New Types Of Trading',
                  videoUrl: _getVideoUrl(
                    enUrl:
                        'https://api.dyntube.com/v1/apps/hls/5CSdYiZXdEGXUAWBWxc9uw.m3u8',
                    thUrl:
                        'https://api.dyntube.com/v1/apps/hls/aK3bsZ4Iy02bmdIJScOPHw.m3u8',
                    hiUrl:
                        'https://api.dyntube.com/v1/apps/hls/o06YY3BMCExh5Wrrwg4Zw.m3u8',
                    arUrl:
                        'https://api.dyntube.com/v1/apps/hls/c72KuDiWokKf1dvxUR94w.m3u8',
                  ),
                ),
                // Add additional subtopics if needed
              ],
            ),
          ],
        )

        // Add more categories and topics as needed
      ],
    );
  }
}
