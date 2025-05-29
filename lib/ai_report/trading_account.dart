import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:yamarkets_ios/utils/localization_utils.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../../main.dart';

import 'package:share_plus/share_plus.dart';

class TradingAccount extends StatefulWidget {
  final String languageCode;

  const TradingAccount({required this.languageCode});

  @override
  _TradingAccountState createState() => _TradingAccountState();
}

class _TradingAccountState extends State<TradingAccount> {
  final TextEditingController _accountIdController = TextEditingController();
  String? _pdfLink;
  String? _jsonResponse;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    Localization.load(widget.languageCode); // Load the selected language
  }

  Future<void> _requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      // The permission is granted
    } else {
      // The permission is denied
      _showErrorDialog(Localization.translate('storage') ??
          'Storage permission is required to download the PDF.');
    }
  }

  void _submit() async {
    final accountId = _accountIdController.text;

    if (accountId.isEmpty) {
      _showErrorDialog(Localization.translate('account_id_empty') ??
          'Account ID cannot be empty');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await fetchReport(accountId);

    setState(() {
      _isLoading = false;
    });

    if (response != null) {
      setState(() {
        _pdfLink = response['reportLink'];
        _jsonResponse = jsonEncode(response);
      });

      // Open the PDF directly after getting a valid response
      if (_pdfLink != null) {
        _openPDF(_pdfLink!);
      }
    } else {
      _showErrorDialog(Localization.translate('account_id_invalid') ??
          'Account ID is not valid');
    }
  }

  Future<Map<String, dynamic>?> fetchReport(String accountId) async {
    final queryParams = {
      'brokerName': 'YaMarkets',
      'userEmail': 'eliot.corley@hoc-trade.com',
      'platform': 'mt5',
      'server': 'liveserver1',
      'accountId': accountId,
      'language': 'eng',
    };

    final uri = Uri.https(
      'trade-medic.hoc-trade.com',
      '/api/broker-reports',
      queryParams,
    );

    final response = await http.get(
      uri,
      headers: {
        'x-api-key': 'e877ce9b09fb6a1a91d40e5b8ba87881c5b0a111',
        'x-api-secret': 'e877ce9b09fb6a1a91d40e5b8ba87881c5b0a111',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final body = jsonDecode(data['body']);
      return body;
    } else {
      return null;
    }
  }

  void _openPDF(String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(
          url: url,
          onDownload: _downloadPDF,
        ),
      ),
    );
  }

  void _downloadPDF(String url) async {
    try {
      // Request permissions first
      await _requestPermissions();

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Directory? directory;

        if (Platform.isAndroid) {
          directory = Directory('/storage/emulated/0/Download');
          if (!directory.existsSync()) {
            directory.createSync(recursive: true);
          }
        } else if (Platform.isIOS) {
          directory = await getApplicationDocumentsDirectory(); // iOS sandboxed
        }

        if (directory != null) {
          String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          final filePath = '${directory.path}/report_$timestamp.pdf';
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          // Show a success toast message
          Fluttertoast.showToast(
            msg: "PDF downloaded successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.amber,
            textColor: Colors.black,
          );

          // On iOS, share the file to let the user choose where to save it
          if (Platform.isIOS) {
            Share.shareXFiles([XFile(filePath)], text: 'Download the PDF file');
          }
        } else {
          _showErrorDialog(
              Localization.translate('download_directory_failed') ??
                  'Failed to get the download directory.');
        }
      } else {
        _showErrorDialog(
            'Failed to load PDF. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog(Localization.translate('download_failed') ??
          'Failed to download the PDF: $e');

      // Show a failure toast message
      Fluttertoast.showToast(
        msg: "Failed to download PDF",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(Localization.translate('error') ?? 'Error'),
        content: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(Localization.translate('ok') ?? 'OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            Localization.translate('ya_trading_ai_report') ??
                'Ya Trading AI Report Fetcher',
            style: TextStyle(color: Colors.black)),
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
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _accountIdController,
              decoration: InputDecoration(
                labelText: Localization.translate('enter_account_id') ??
                    'Enter Account ID',
                labelStyle: TextStyle(color: Colors.black),
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                      ),
                      child: Text(
                        Localization.translate('submit') ?? 'Submit',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
            if (_pdfLink != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Localization.translate('report_is_ready') ??
                        'Report is ready!',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String? url;
  final String? filePath;
  final Function(String)? onDownload;

  PDFViewerScreen({this.url, this.filePath, this.onDownload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Localization.translate('trade_report') ?? 'Trade Report'),
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
      body: filePath != null
          ? SfPdfViewer.file(File(filePath!)) // Open the local PDF file
          : SfPdfViewer.network(url!), // Open the PDF from a URL
      floatingActionButton: url != null
          ? FloatingActionButton(
              onPressed: () => onDownload!(url!),
              child: const Icon(Icons.download),
              backgroundColor: Colors.amber,
            )
          : null,
    );
  }
}
