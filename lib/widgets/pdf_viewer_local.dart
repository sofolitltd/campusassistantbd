// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:pdfx/pdfx.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
//
// class PdfViewerLocal extends StatefulWidget {
//   final String title;
//   final String filePath;
//
//   const PdfViewerLocal({
//     Key? key,
//     required this.title,
//     required this.filePath,
//   }) : super(key: key);
//
//   @override
//   State<PdfViewerLocal> createState() => _PdfViewerLocalState();
// }
//
// class _PdfViewerLocalState extends State<PdfViewerLocal> {
//   @override
//   Widget build(BuildContext context) {
//     final pdfPinchController = PdfControllerPinch(
//       document: PdfDocument.openFile(widget.filePath),
//     );
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         actions: [
//           IconButton(
//             icon: const Icon(
//               Icons.bookmark,
//               color: Colors.white,
//               semanticLabel: 'Bookmark',
//             ),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: PdfViewPinch(
//         controller: pdfPinchController,
//       ),
//     );
//   }
// }
