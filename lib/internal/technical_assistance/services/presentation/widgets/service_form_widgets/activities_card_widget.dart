import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/assigned_agent.dart';
import 'package:image_picker/image_picker.dart';


class ActivitiesCardWidget extends StatefulWidget {
  final AssignedAgent assignment;
  final List<Map<String, dynamic>> tasks;
  final Function(List<Map<String, dynamic>>) onTasksUpdated;

  const ActivitiesCardWidget({super.key, required this.assignment, required this.tasks, required this.onTasksUpdated});

  @override
  State<ActivitiesCardWidget> createState() => _ActivitiesCardWidgetState();
}

class _ActivitiesCardWidgetState extends State<ActivitiesCardWidget> {
  final TextEditingController _descriptionController = TextEditingController();
  final List<File> _files = [];
  final ImagePicker _imagePicker = ImagePicker();
  String activityDescription = 'Sin actividad';
  final List<Map<String, dynamic>> _localTasks = [];

  @override
  void initState() {
    activityDescription = widget.assignment.activities!.first.activityDescription ?? "Sin actividad";
    super.initState();
  }

  Future<void> _handleFileSelection() async {
    File? file = await selectFile(context, _imagePicker);
    if (file != null) {
      setState(() {
        _files.add(file);
      });
    }
  }

  Future<File?> selectFile(BuildContext context, ImagePicker imagePicker) async {
    final Completer<File?> completer = Completer<File?>();

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Seleccionar imagen o PDF'),
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
        _localTasks.add({
          'description': _descriptionController.text,
          'files': _files.map((file) => _convertFileToBase64(file)).toList(),
        });
        widget.onTasksUpdated(_localTasks);
        _descriptionController.clear();
        _files.clear();
      });
    }
  }

  void _removeTask(int index) {
    setState(() {
      _localTasks.removeAt(index);
      widget.onTasksUpdated(_localTasks);
    });
  }

  void _removeFile(int index) {
    setState(() {
      _files.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, IconData> fileTypeIcons = {
      'pdf': Icons.picture_as_pdf,
      'jpg': Icons.image,
      'jpeg': Icons.image,
      'png': Icons.image,
    };

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const Divider(),
            ..._localTasks.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> task = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${index + 1} - ${task['description']}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeTask(index),
                      ),
                    ],
                  ),
                  Wrap(
                    children: task['files'].map<Widget>((fileBase64) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Chip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(fileTypeIcons[fileBase64.substring(0, 3)] ?? Icons.insert_drive_file),
                              const SizedBox(width: 5),
                              const Text("Archivo adjunto"),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const Divider(),
                ],
              );
            }),
            const Text(
              "Descripción del trabajo realizado:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
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
                int index = entry.key;
                File file = entry.value;
                String fileExtension = file.path.split('.').last.toLowerCase();
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Chip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(fileTypeIcons[fileExtension] ?? Icons.insert_drive_file),
                        const SizedBox(width: 5),
                        Text(file.path.split('/').last),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18, color: Colors.red),
                          onPressed: () => _removeFile(index),
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
                  icon: const Icon(Icons.add, color: Colors.white,),
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
