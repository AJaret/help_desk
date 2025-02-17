import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerWidget extends StatefulWidget {
  final String base64File;

  const PdfViewerWidget({super.key, required this.base64File});

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfController = PdfViewerController();
  String? tempFilePath;
  int _currentPage = 1;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      Uint8List bytes = base64Decode(widget.base64File);
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = '${tempDir.path}/document.pdf';
      File tempFile = File(tempPath);
      await tempFile.writeAsBytes(bytes);

      setState(() {
        tempFilePath = tempPath;
      });
    } catch (e) {
      setState(() {
        tempFilePath = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return tempFilePath == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(
                child: SfPdfViewer.file(
                  File(tempFilePath!),
                  key: _pdfViewerKey,
                  controller: _pdfController,
                  enableDoubleTapZooming: true,
                  onPageChanged: (PdfPageChangedDetails details) {
                    setState(() {
                      _currentPage = details.newPageNumber;
                      _totalPages = _pdfController.pageCount ?? _totalPages;
                    });
                  },
                ),
              ),
              if (_totalPages > 1)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: _currentPage > 1
                            ? () {
                                _pdfController.previousPage();
                              }
                            : null,
                      ),
                      Text('Página $_currentPage de $_totalPages'),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: _currentPage < _totalPages
                            ? () {
                                _pdfController.nextPage();
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
            ],
          );
  }
}