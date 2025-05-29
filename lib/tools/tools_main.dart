import 'package:flutter/material.dart';
import 'package:yamarkets_ios/tools/tool_signal_design.dart';
import '../utils/localization_utils.dart';
import 'tools_signals_widget.dart';

class ToolsMain extends StatefulWidget {
  final String languageCode;

  const ToolsMain({required this.languageCode});

  @override
  State<ToolsMain> createState() => _ToolsMainState();
}

class _ToolsMainState extends State<ToolsMain> {
  @override
  void initState() {
    super.initState();
    Localization.load(widget.languageCode); // Load the selected language
  }

  final List<Map<String, dynamic>> tools = [
    {
      "title": Localization.translate('currency') ??
          'Currency Converter', // New option
      "icon": Icons.attach_money,
      "url": "https://widgets.fxsignals.ae/currencyconverter.html"
    },
    {
      "title": Localization.translate('fx') ?? "FX Cross Rate",
      "icon": Icons.swap_horiz,
      "url": "https://widgets.fxsignals.ae/fxcrossrates.html"
    },
    {
      "title": Localization.translate('pip') ?? "PIP Calculator",
      "icon": Icons.calculate,
      "url": "https://widgets.fxsignals.ae/pipcalculator.html"
    },
    {
      "title": Localization.translate('forex_market') ?? "Forex Market Hours",
      "icon": Icons.access_time,
      "url": "https://widgets.fxsignals.ae/forexmarkethours.html"
    },
    {
      "title": Localization.translate('profit') ?? "Profit Calculator",
      "icon": Icons.monetization_on,
      "url": "https://widgets.fxsignals.ae/profitcalculator.html"
    },
    {
      "title": Localization.translate('margin') ?? "Margin Requirement",
      "icon": Icons.balance,
      "url": "https://widgets.fxsignals.ae/marginrequirements.html"
    },
    {
      "title": Localization.translate('overnight') ?? "Overnight Swaps",
      "icon": Icons.nightlight_round,
      "url": "https://widgets.fxsignals.ae/overnightswaps.html"
    },
    {
      "title":
          Localization.translate('position_size') ?? "Position Size Calculator",
      "icon": Icons.rule,
      "url": "https://widgets.fxsignals.ae/positionsizecalculator.html"
    },
  ];

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
    return false; // Return false to prevent the default back behavior
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tools'),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ToolSignalWidget(
                      title: tool["title"], // Passing the title
                      url: tool["url"], // Passing the corresponding URL
                      languageCode: widget.languageCode,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
