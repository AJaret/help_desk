import 'dart:io';

import 'package:flutter/material.dart';

Widget buildStep5({
  required List<File> files,
  required Function() handleFileSelectionModal,
  required Function(int index) removeFile,
  required BuildContext context
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      ElevatedButton(
        onPressed: () => handleFileSelectionModal(),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          backgroundColor: const Color(0xFF8B1A42),
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
                files[index].path.endsWith('.pdf') ? Icons.picture_as_pdf : Icons.image,
                color: const Color(0xFF8B1A42),
              ),
              title: Text(files[index].path.endsWith('.pdf') ? 'PDF' : 'Imagen'),
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
