import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '/models/content_model.dart';

class PdfViewerWeb extends StatefulWidget {
  final ContentModel courseContentModel;

  const PdfViewerWeb({Key? key, required this.courseContentModel})
      : super(key: key);

  @override
  State<PdfViewerWeb> createState() => _PdfViewerWebState();
}

class _PdfViewerWebState extends State<PdfViewerWeb> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseContentModel.contentTitle),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              // color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.courseContentModel.fileUrl,
        key: _pdfViewerKey,
      ),
    );
  }
}
