import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfViewer extends StatelessWidget {
  const PdfViewer({
    Key? key,
    required this.title,
    required this.fileUrl,
  }) : super(key: key);
  final String title;

  final String fileUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
        centerTitle: true,
      ),
      body: const PDF(
        autoSpacing: false,
        nightMode: false,
      ).cachedFromUrl(
        fileUrl,
        placeholder: (progress) => Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              progress == 0
                  ? SizedBox(
                      height: 64,
                      width: 64,
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        backgroundColor: Colors.blue.shade50,
                      ),
                    )
                  : SizedBox(
                      height: 64,
                      width: 64,
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        backgroundColor: Colors.blue.shade50,
                        value: progress / 100,
                      ),
                    ),

              //
              Text(
                '${progress.round()} %',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        errorWidget: (error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
