import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/activity.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/assigned_agent.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/work_done.dart';
import 'package:help_desk/internal/users/request/domain/entities/document.dart';
import 'package:image_picker/image_picker.dart';

class ActivitiesCardWidget extends StatefulWidget {
  final AssignedAgent assignment;
  final Activity activity;
  final Function(int, List<WorkDone>) onTasksUpdated;

  const ActivitiesCardWidget({
    super.key,
    required this.assignment,
    required this.activity,
    required this.onTasksUpdated,
  });

  @override
  State<ActivitiesCardWidget> createState() => _ActivitiesCardWidgetState();
}

class _ActivitiesCardWidgetState extends State<ActivitiesCardWidget> {
  final TextEditingController _descriptionController = TextEditingController();
  final List<Document> _files = [];
  final List<WorkDone> _localTasks = [];
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleFileSelection() async {
    File? file = await _selectFile(context, _imagePicker);
    if (file != null) {
      setState(() {
        _files.add(Document(
          file: file.path.split('/').last,
          fileExtension: _convertFileToBase64(file),
        ));
      });
    }
  }

  Future<File?> _selectFile(BuildContext context, ImagePicker imagePicker) async {
    final Completer<File?> completer = Completer<File?>();

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Seleccionar imagen de galería'),
              onTap: () async {
                Navigator.of(context).pop();
                final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  completer.complete(File(pickedFile.path));
                } else {
                  completer.complete(null);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text('Seleccionar archivo (PDF, imágenes)'),
              onTap: () async {
                Navigator.of(context).pop();
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                );
                if (result != null) {
                  completer.complete(File(result.files.single.path!));
                } else {
                  completer.complete(null);
                }
              },
            ),
          ],
        );
      },
    );

    return await completer.future;
  }

  String _convertFileToBase64(File file) {
    List<int> fileBytes = file.readAsBytesSync();
    return base64Encode(fileBytes);
  }

  void _addTask() {
    if (_descriptionController.text.isNotEmpty) {
      setState(() {
        _localTasks.add(WorkDone(
          workDescription: _descriptionController.text,
          documents: List<Document>.from(_files),
        ));
        widget.onTasksUpdated(widget.activity.activityId ?? 0, _localTasks);
        _descriptionController.clear();
        _files.clear();
      });
    }
  }

  void _removeTask(int index) {
    setState(() {
      _localTasks.removeAt(index);
      widget.onTasksUpdated(widget.activity.activityId ?? 0, _localTasks);
    });
  }

  void _removeFile(int index) {
    setState(() {
      _files.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Actividad: ${widget.activity.activityDescription}", style: const TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            ..._localTasks.asMap().entries.map((entry) {
              int index = entry.key;
              WorkDone task = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${index + 1} - ${task.workDescription}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeTask(index),
                      ),
                    ],
                  ),
                  Wrap(
                    children: task.documents?.asMap().entries.map((fileEntry) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Chip(
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.insert_drive_file),
                                  const SizedBox(width: 5),
                                  Text(fileEntry.value.file ?? "Archivo"),
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 18, color: Colors.red),
                                    onPressed: () => setState(() {
                                      task.documents?.removeAt(fileEntry.key);
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList() ??
                        [],
                  ),
                  const Divider(),
                ],
              );
            }).toList(),
            const Text("Descripción del trabajo realizado:", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Ingrese la descripción...",
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              children: _files.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Chip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.insert_drive_file),
                        const SizedBox(width: 5),
                        Text(entry.value.file ?? "Archivo"),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18, color: Colors.red),
                          onPressed: () => _removeFile(entry.key),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: _handleFileSelection,
                  icon: const Icon(Icons.attach_file),
                  label: const Text("Adjuntar archivo"),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: _addTask,
                  icon: const Icon(Icons.add),
                  label: const Text("Agregar tarea"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}