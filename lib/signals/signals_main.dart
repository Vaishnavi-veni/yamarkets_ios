import 'package:flutter/material.dart';
import 'package:yamarkets_ios/tools/tool_signal_design.dart';
import 'package:yamarkets_ios/utils/localization_utils.dart';

import '../tools/tools_signals_widget.dart';
class SignalsMain extends StatefulWidget {
  final String languageCode;

  const SignalsMain({required this.languageCode});

  @override
  State<SignalsMain> createState() => _SignalsMainState();
}

class _SignalsMainState extends State<SignalsMain> {
  @override
  void initState() {
    super.initState();
    Localization.load(widget.languageCode); // Load the selected language
  }

  final List<Map<String, dynamic>> tools = [
    {
      "title": Localization.translate('technical') ?? "Technical Indicator",
      "icon": Icons.drag_indicator,
      "url": "https://widgets.fxsignals.ae/technicalindicators.html"
    },
    {
      "title": Localization.translate('market') ?? "Market Signal",
      "icon": Icons.signal_cellular_0_bar,
      "url": "https://widgets.fxsignals.ae/marketsignals.html"
    },
  ];

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
    return false; // Return false to prevent the default back navigation
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Signals'),
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
          body: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: tools.length,
            itemBuilder: (context, index) {
              final tool = tools[index];
              return ToolSignalCard(
                title: tool["title"],
                icon: tool["icon"],
                onTap: () {
                  // Navigate to ToolSignalWidget with the title and url of the selected tool
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ToolSignalWidget(
                        title: tool[
                            "title"], // Pass the title of the selected tool
                        url: tool["url"], // Pass the URL of the selected tool
                        languageCode: widget.languageCode,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }
}
