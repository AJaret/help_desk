import 'dart:io';

import 'package:flutter/material.dart';

Widget buildStep5({
  required List<File> files,
  required Function() handleFileSelection,
  required Function(int index) removeFile,
  required BuildContext context
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ElevatedButton(
        onPressed: handleFileSelection,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Añadir archivo o tomar foto',
          style: TextStyle(color: Colors.white),
        ),
      ),
      const SizedBox(height: 16),
      if (files.isNotEmpty)
        ListView.builder(
          shrinkWrap: true,
          itemCount: files.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(
                files[index].path.endsWith('.pdf')
                    ? Icons.picture_as_pdf
                    : files[index].path.endsWith('.zip')
                        ? Icons.archive
                        : Icons.image,
                color: Colors.blue,
              ),
              title: Text(files[index].path.split('/').last),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => removeFile(index),
              ),
            );
          },
        ),
    ],
  );
}
