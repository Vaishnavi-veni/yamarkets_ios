import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_flip/page_flip.dart';
import 'package:pdfx/pdfx.dart';

class FlipBookScreen extends StatelessWidget {
  final String pdfPath;

  const FlipBookScreen({Key? key, required this.pdfPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: FutureBuilder<List<Image>>(
        future: _convertPdfToImages(pdfPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LoadingAnimationWidget.threeArchedCircle(
              color: Colors.black,
              size: 50,
            ),);
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final images = snapshot.data!;
            return PageFlipWidget(
              children: images.map((image) => Center(child: image)).toList(),
            );
          }
        },
      ),
    );
  }

  Future<List<Image>> _convertPdfToImages(String pdfPath) async {
    final document = await PdfDocument.openFile(pdfPath);
    final List<Image> images = [];

    for (int i = 1; i <= document.pagesCount; i++) {
      final page = await document.getPage(i);
      final pageImage = await page.render(
        width: page.width,
        height: page.height,
        format: PdfPageImageFormat.png,
      );
      images.add(Image.memory(pageImage!.bytes));
      await page.close();
    }

    await document.close();
    return images;
  }
}