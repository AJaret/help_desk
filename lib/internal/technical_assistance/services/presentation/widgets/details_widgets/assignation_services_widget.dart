import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/activity.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/assigned_agent.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/work_done.dart';
import 'package:help_desk/internal/users/request/domain/entities/document.dart';
import 'package:help_desk/shared/helpers/pdf_viewer.dart';
import 'package:help_desk/shared/helpers/status_information.dart';


class AssignationServicesWidget extends StatelessWidget {
  final AssignedAgent assignment;

  const AssignationServicesWidget({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    final String agentName = assignment.assignedAgent ?? "Sin asignar";
    final String status = assignment.status ?? "Sin estado";
    final String registeredDate = assignment.date ?? "Sin fecha";
    final List<Activity> activities = assignment.activities ?? [];

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              agentName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            buildStatusBadge(status),
            const SizedBox(height: 16),
            ...activities.map((activity) {
              final String activityDescription = activity.activityDescription ?? "Sin actividad";
              final List<WorkDone> works = activity.worksDone ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const Row(
                    children: [
                      Icon(Icons.headset_mic, size: 20, color: Colors.black54),
                      SizedBox(width: 8),
                      Text(
                        "Actividad",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Descripción de la actividad:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    activityDescription,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),

                  // Works Section
                  const Text(
                    "Trabajos realizados:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  ...works.map((work) {
                    final String workDescription = work.workDescription ?? "Sin trabajo";
                    final List<Document> files = work.documents ?? [];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("1. "),
                              Expanded(
                                child: Text(
                                  workDescription,
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Files Section
                          ...files.map((file) {
                            final String fileExtension = file.fileExtension ?? "N/A";

                            return Card(
                              color: const Color(0xFFF1F5F9),
                              child: ListTile(
                                leading: Icon(
                                  fileExtension.toLowerCase() == "pdf" ? Icons.picture_as_pdf : Icons.insert_drive_file,
                                  color: Colors.red,
                                ),
                                title: const Text("Documento"),
                                isThreeLine: false,
                                onTap: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoActionSheet(
                                        message: (file.fileExtension == 'jpg' || file.fileExtension == 'jpeg' || file.fileExtension == 'png') ?
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.7,
                                            child: InteractiveViewer(
                                              panEnabled: true,
                                              boundaryMargin: const EdgeInsets.all(20),
                                              minScale: 0.1,
                                              maxScale: 3.0,
                                              child: Image.memory(base64Decode(file.file!), fit: BoxFit.contain),
                                            ),
                                          ) : (file.fileExtension!.contains('pdf')) ? PdfViewerWidget(base64File: file.file!) :
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.7,
                                            child: InteractiveViewer(
                                              panEnabled: true,
                                              boundaryMargin: const EdgeInsets.all(20),
                                              minScale: 0.1,
                                              maxScale: 3.0,
                                              child: Image.memory(base64Decode(file.file!), fit: BoxFit.contain),
                                            ),
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
                              ),
                            );
                          })
                        ],
                      ),
                    );
                  }),
                ],
              );
            }),

            // Footer
            const Divider(),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Asignado: $registeredDate",
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}