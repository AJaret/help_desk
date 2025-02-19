import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<File?> selectFile(BuildContext context, ImagePicker imagePicker) async {
  final Completer<File?> completer = Completer<File?>();

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
              if(await Permission.camera.isGranted || await Permission.camera.isLimited || await Permission.camera.isProvisional){
                final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 60);
                if (pickedFile != null) {
                  completer.complete(File(pickedFile.path));
                } else {
                  completer.complete(null);
                }
              } else if(await Permission.camera.isPermanentlyDenied){
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Permisos necesarios'),
                    content: const Text(
                      'Los permisos para acceder a la cámara fueron denegados permanentemente, para continuar, habilita los permisos de acceso a la cámara desde las configuraciones del dispositivo.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          openAppSettings();
                        },
                        child: const Text('Entendido'),
                      ),
                    ],
                  ),
                );
              }
              else {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Permisos necesarios'),
                    content: const Text(
                      'Para continuar, por favor otorga permisos para acceder a la cámara.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          Permission.camera.request();
                        },
                        child: const Text('Entendido'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Seleccionar desde la galería'),
            onTap: () async {
              Navigator.of(context).pop();
              if(await Permission.photos.isGranted || await Permission.photos.isLimited || await Permission.photos.isProvisional){
                final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  completer.complete(File(pickedFile.path));
                } else {
                  completer.complete(null);
                }
              } else if(await Permission.photos.isPermanentlyDenied){
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Permisos necesarios'),
                    content: const Text(
                      'Los permisos para acceder a la galería fueron denegados permanentemente, para continuar, habilita los permisos de acceso a la galería desde las configuraciones del dispositivo.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          openAppSettings();
                        },
                        child: const Text('Entendido'),
                      ),
                    ],
                  ),
                );
              }
              else {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Permisos necesarios'),
                    content: const Text(
                      'Para continuar, por favor otorga permisos para acceder a la galería.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          Permission.photos.request();
                        },
                        child: const Text('Entendido'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.attach_file),
            title: const Text('Añadir archivo'),
            onTap: () async {
              Navigator.of(context).pop();
              if(await Permission.storage.isGranted || await Permission.storage.isLimited || await Permission.storage.isProvisional){
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                );
                if (result != null) {
                  completer.complete(File(result.files.single.path!));
                } else {
                  completer.complete(null);
                }
              } else if(await Permission.storage.isPermanentlyDenied){
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Permisos necesarios'),
                    content: const Text(
                      'Los permisos para acceder a la los archivos del dispositivo fueron denegados permanentemente, para continuar, habilita los permisos de acceso a los archivos desde las configuraciones del dispositivo.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          openAppSettings();
                        },
                        child: const Text('Entendido'),
                      ),
                    ],
                  ),
                );
              }
              else {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Permisos necesarios'),
                    content: const Text(
                      'Para continuar, por favor otorga permisos para acceder a tus archivos.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          Permission.storage.request();
                        },
                        child: const Text('Entendido'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      );
    },
  );

  final File? selectedFile = await completer.future;
  return selectedFile;
}