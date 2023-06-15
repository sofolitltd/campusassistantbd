import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// Represents Homepage for Navigation
class PdfViewerCached extends StatefulWidget {
  const PdfViewerCached(
      {super.key, required this.title, required this.fileUrl});
  final String title;
  final String fileUrl;

  @override
  State<PdfViewerCached> createState() => _PdfViewerCachedState();
}

class _PdfViewerCachedState extends State<PdfViewerCached> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  File? _tempFile;

  @override
  void initState() {
    initializeFile();
    super.initState();
  }

  // ignore: avoid_void_async
  void initializeFile() async {
    final Directory tempPath = await getApplicationDocumentsDirectory();
    final File tempFile = File('${tempPath.path}/flutter_succinctly.pdf');
    final bool checkFileExist = await tempFile.exists();
    if (checkFileExist) {
      _tempFile = tempFile;
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    Widget child;
    if (_tempFile == null) {
      child = SfPdfViewer.network(
          'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
          key: _pdfViewerKey,
          onDocumentLoaded: (PdfDocumentLoadedDetails details) async {
        final Directory tempPath = await getApplicationDocumentsDirectory();
        _tempFile = await File('${tempPath.path}/flutter_succinctly.pdf')
            .writeAsBytes(details.document.save() as List<int>);
      });
    } else {
      child = SfPdfViewer.file(
        _tempFile!,
        key: _pdfViewerKey,
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: child,
    );
  }
}
