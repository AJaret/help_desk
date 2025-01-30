import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:help_desk/internal/users/request/domain/entities/document.dart';
import 'package:help_desk/internal/users/request/presentation/blocs/request_details_bloc/request_details_bloc.dart';
import 'package:help_desk/shared/helpers/app_dependencies.dart';
import 'package:path_provider/path_provider.dart';

class FilesWidget extends StatelessWidget {
  final List<Document> documents;

  const FilesWidget({
    super.key,
    required this.documents,
  });

  Future<Widget> _showPdf(String base64File, Size size) async {
    try {
      Uint8List bytes = base64Decode(base64File);
      
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = '${tempDir.path}/document.pdf';
      
      File tempFile = File(tempPath);
      await tempFile.writeAsBytes(bytes);
      
      return SizedBox(
        height: size.height * 0.5,
        child: PDFView(
          filePath: tempPath,
        ),
      );
    } catch (e) {
      return Center(child: Text('Error al mostrar el PDF: $e'));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final Map<String, IconData> fileTypeIcons = {
      'pdf': Icons.picture_as_pdf,
      'doc': Icons.description,
      'docx': Icons.description,
      'xls': Icons.table_chart,
      'xlsx': Icons.table_chart,
      'jpg': Icons.image,
      'jpeg': Icons.image,
      'png': Icons.image,
    };

    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Archivos digitales',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.055,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            documents.isNotEmpty
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final document = documents[index];
                      final fileType = document.fileExtension;
                      final icon = fileTypeIcons[fileType] ?? Icons.insert_drive_file;
    
                      return GestureDetector(
                        onTap: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) {
                              return BlocProvider(
                                create: (context) => RequestDetailsBloc(AppDependencies.getRequestById, AppDependencies.getDocumentFile),
                                child: CupertinoActionSheet(
                                  title: Text('Documento ${document.documentId}'),
                                  message: BlocBuilder<RequestDetailsBloc, RequestDetailsState>(
                                    builder: (context, state){
                                      if(state is RequestDetailsInitial){
                                        context.read<RequestDetailsBloc>().add(GetDocumentFile(documentId: document.documentId ?? 0));
                                      }
                                      else if (state is GettingDocumentFile) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (state is DocumentFileSuccess){
                                        if (state.doc.file != null) {
                                          final fileType = state.doc.fileExtension!.toLowerCase();

                                          if (fileType == 'jpg' || fileType == 'jpeg' || fileType == 'png') {
                                            Uint8List bytes = base64Decode(state.doc.file!);
                                            return SizedBox(
                                              height: size.height * 0.5,
                                              child: Image.memory(bytes),
                                            );
                                          } else if (fileType == 'pdf') {
                                            return FutureBuilder<Widget>(
                                              future: _showPdf(state.doc.file ?? '', size),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return const Center(child: CircularProgressIndicator());
                                                } else if (snapshot.hasError) {
                                                  return Center(child: Text('Error: ${snapshot.error}'));
                                                } else {
                                                  return snapshot.data ?? const Center(child: Text('Error al cargar PDF'));
                                                }
                                              },
                                            );
                                          } else {
                                            return Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(fileTypeIcons[fileType] ?? Icons.insert_drive_file, size: 50),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    'Documento ${state.doc.documentId}',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        }
                                      } else if(state is ErrorGettingDocumentFile){
                                        return Center(
                                          child: Text(state.message),
                                        );
                                      }
                                      return const Center(
                                        child: Text('Error al cargar el documento'),
                                      );
                                    },
                                  ),
                                  actions: [
                                    CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cerrar'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Column(
                          children: [
                            Icon(icon, size: 40),
                            Text(
                              document.documentId.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * 0.03,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'No hay archivo(s) digital(es)',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
