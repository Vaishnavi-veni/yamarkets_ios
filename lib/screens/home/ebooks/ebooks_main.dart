import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:page_flip/page_flip.dart';
import 'package:pdfx/pdfx.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../utils/localization_utils.dart';
import '../../../view/url.dart';
import 'flipbook.dart';


class Ebooks extends StatefulWidget {
  const Ebooks({super.key});

  @override
  State<Ebooks> createState() => _EbooksState();
}

class _EbooksState extends State<Ebooks> {

  Future<void> _viewPdf(String pdfUrl) async {
    try {
      // Log the URL to ensure it's correct
      print('Attempting to view PDF: $pdfUrl');

      // Navigate to the PDFViewer screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('PDF Viewer'),
            ),
            body: SfPdfViewer.network(pdfUrl), // Use SfPdfViewer.asset for local assets
          ),
        ),
      );
    } catch (e) {
      print('Error loading PDF: $e');
      // Handle the error as needed, e.g., show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading PDF: $e')),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EbooksData();
  }

  Future<List<Map<String, dynamic>>> EbooksData() async {
    print("EBooks started");
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'access_token');
    try {
      final response = await http.get(
        Uri.parse('${MyConstants.baseUrl}/course_api/ebooks'),
        headers: {
          'Authorization': '$accessToken', // Include the access token here
        },
      );
      print("EBooks response:${response.statusCode}");
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print("EBooks successful");
        // Check if jsonData is a list and contains maps
        if (jsonData is List && jsonData.isNotEmpty && jsonData[0] is Map<String, dynamic>) {
          return jsonData.cast<Map<String, dynamic>>();
        } else if (jsonData is List) {
          // If jsonData is a list but doesn't contain maps, you can handle it accordingly
          print('Invalid data format from the API: $jsonData');
          return [];
        } else {
          throw Exception('Invalid data format from the API');
        }
      } else {
        throw Exception('Failed to load course data');
      }
    } catch (e) {
      print('Error fetching course data: $e');
      return [];
    }
  }

  Future<List<int>> _downloadPdf(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to download PDF');
    }
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
      body:
      Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20),
            alignment: Alignment.topLeft,
            child: Text(
              Localization.translate('explore') ?? 'Explore',
              style: TextStyle(
                color: Colors.black,
                fontSize: 38,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              Localization.translate('ebook_data') ??  "Uncover a wealth of trading wisdom through our meticulously selected e-books on financial markets and strategies.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: screenHeight*0.03,),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: EbooksData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: LoadingAnimationWidget.threeArchedCircle(
                    color: Color(0xfffac211),
                    size: 50,
                  ),);
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Column(
                    children: [
                      Image.asset('assets/ebooks/ebook_no-removebg-preview.png'),
                      SizedBox(height: screenWidth*0.1,),
                      Text(
                        Localization.translate('no_ebook') ??  "No E-Books Found!",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth*0.08
                        ),),
                      SizedBox(height: screenWidth*0.02,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: screenWidth*0.1),child:
                      Text(
                        Localization.translate('no_ebook_data') ?? "Currently no e-books are available. You will be able to see them here once they are available.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth*0.04
                        ),)  )


                    ],
                  ));
                } else {
                  final eBooks = snapshot.data!;
                  return ListView.builder(
                    itemCount: eBooks.length,
                    itemBuilder: (context, index) {
                      final ebook = eBooks[index];
                      return GestureDetector(
                          onTap: () async {
                            if (ebook != null && ebook.containsKey('source')) {
                              String pdfUrl = 'https://fxcareers.com/images/${ebook['source']}';
                              final pdfBytes = await _downloadPdf(pdfUrl);

                              // Save the PDF locally
                              final dir = await getApplicationDocumentsDirectory();
                              final pdfPath = '${dir.path}/ebook.pdf';
                              final file = File(pdfPath);
                              await file.writeAsBytes(pdfBytes);

                              // Navigate to the flipbook screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FlipBookScreen(pdfPath: pdfPath),
                                ),
                              );
                            }
                          },
                          child:
                          Padding(
                              padding: EdgeInsets.only(bottom: screenWidth*0.05,left:screenWidth*0.05,right:screenWidth*0.05 ),
                              child:ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child:
                                Image.network(
                                  'https://fxcareers.com/images/${ebook['ebook_image']}',
                                  fit: BoxFit.fill,
                                  height: screenWidth*0.5,
                                ),
                              )
                          )
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}