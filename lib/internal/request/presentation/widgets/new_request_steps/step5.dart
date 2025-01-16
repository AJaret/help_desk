import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> _requestPermissions() async {
  final statusCamera = await Permission.camera.request();
  final statusStorage = await Permission.storage.request();
  final statusPhotos = await Permission.photos.request();
  return statusCamera.isGranted && statusStorage.isGranted && statusPhotos.isGranted;
}


Widget buildStep5({
  required List<File> files,
  required Function() handleFileSelectionModal,
  required Function(int index) removeFile,
  required BuildContext context
}) {

  void handleFileSelection(BuildContext context) async {
    final permissionsGranted = await _requestPermissions();

    if (permissionsGranted) {
      handleFileSelectionModal();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permisos necesarios'),
          content: const Text(
            'Para continuar, por favor otorga permisos para acceder a la cámara y el almacenamiento.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
    }
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      ElevatedButton(
        onPressed: () => handleFileSelection(context),
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
