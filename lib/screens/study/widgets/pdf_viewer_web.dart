import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class PdfViewerWeb extends StatefulWidget {
  final String contentTitle;
  final String fileUrl;

  const PdfViewerWeb({
    Key? key,
    required this.contentTitle,
    required this.fileUrl,
  }) : super(key: key);

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
        title:  Text(widget.contentTitle),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(widget.fileUrl,
        key: _pdfViewerKey,
      ),
    );
  }
}
