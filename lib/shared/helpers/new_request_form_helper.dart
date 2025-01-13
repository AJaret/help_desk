import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> selectFile(BuildContext context, ImagePicker imagePicker) async {
  File? selectedFile;

  await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text('Tomar una foto'),
            onTap: () async {
              Navigator.of(context).pop();
              final pickedFile =
                  await imagePicker.pickImage(source: ImageSource.camera);
              if (pickedFile != null) {
                selectedFile = File(pickedFile.path);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Seleccionar desde la galería'),
            onTap: () async {
              Navigator.of(context).pop();
              final pickedFile =
                  await imagePicker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                selectedFile = File(pickedFile.path);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.attach_file),
            title: const Text('Añadir archivo'),
            onTap: () async {
              Navigator.of(context).pop();
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'zip', 'mp4'],
              );
              if (result != null) {
                selectedFile = File(result.files.single.path!);
              }
            },
          ),
        ],
      );
    },
  );

  return selectedFile;
}