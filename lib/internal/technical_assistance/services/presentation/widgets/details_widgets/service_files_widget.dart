import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/blocs/technician_request_details_bloc/technician_request_details_bloc.dart';
import 'package:help_desk/internal/users/request/domain/entities/document.dart';
import 'package:help_desk/shared/helpers/app_dependencies.dart';
import 'package:help_desk/shared/helpers/pdf_viewer.dart';

class ServiceFilesWidget extends StatelessWidget {
  final List<Document> documents;

  const ServiceFilesWidget({
    super.key,
    required this.documents,
  });

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

    return BlocProvider(
      create: (context) => TechnicianRequestDetailsBloc(AppDependencies.getTechnicianServiceDetailsUsecase, AppDependencies.getDocumentByIdUsecase, AppDependencies.getServicePdfUsecase),
      child: Padding(
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
              documents.isNotEmpty ? BlocBuilder<TechnicianRequestDetailsBloc, TechnicianRequestDetailsState>(
                builder: (context, state) {
                  if (state is TechnicianRequestDetailsInitial) {
                    context.read<TechnicianRequestDetailsBloc>().add(GetTechnicianDocumentFile(documents: documents));
                  } else if (state is GettingTechnicianDocumentFile) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TechnicianDocumentFileSuccess) {
                    if (state.docs.isNotEmpty) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0
                        ),
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final document = state.docs[index];
                          final fileType = state.docs[index].fileExtension;
                          final icon = fileTypeIcons[fileType] ?? Icons.insert_drive_file;

                          return GestureDetector(
                            onTap: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoActionSheet(
                                    message: (fileType == 'jpg' || fileType == 'jpeg' || fileType == 'png') ?
                                      SizedBox(
                                        height: size.height * 0.7,
                                        child: InteractiveViewer(
                                          panEnabled: true,
                                          boundaryMargin: const EdgeInsets.all(20),
                                          minScale: 0.1,
                                          maxScale: 3.0,
                                          child: Image.memory(base64Decode(document.file!), fit: BoxFit.contain),
                                        ),
                                      ) : (fileType == 'pdf') ? PdfViewerWidget(base64File: document.file!) :
                                      Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                                fileTypeIcons[fileType] ??
                                                    Icons.insert_drive_file,
                                                size: 50),
                                            const SizedBox(height: 10),
                                            Text(
                                              'Documento ${document.documentId}',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )
                                      ),
                                    actions: [
                                      CupertinoActionSheetAction(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cerrar'),
                                      ),
                                    ],
                                  );
                                }
                              );
                            },
                            child: fileType == 'jpg' || fileType == 'jpeg' || fileType == 'png' ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                base64Decode(document.file ?? ""),
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey
                                  );
                                },
                              ),
                            )
                          : Center(child: Icon(icon, size: 90)),
                          );
                        },
                      );
                    } else{
                      return const Center(
                        child: Text(
                          'No hay archivo(s) digital(es)',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                  } else if (state is ErrorGettingTechnicianDocumentFile) {
                    return Center(
                      child: Text(state.message),
                    );
                  }
                  return const Center(
                    child: Text('Error al cargar el documento'),
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
      ),
    );
  }
}
