import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/assigned_agent.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

class SignatureScreen extends StatefulWidget {
  final AssignedAgent assignment;
  const SignatureScreen({super.key, required this.assignment});

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
  );

  Uint8List? _signatureImage;

  Future<void> _saveSignature() async {
    if (_signatureController.isNotEmpty) {
      final Uint8List? data = await _signatureController.toPngBytes();
      if (data != null) {
        setState(() {
          _signatureImage = data;
        });

        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/firma.png';
        File file = File(filePath);
        await file.writeAsBytes(data);

        print("Firma guardada en: $filePath");
      }
    }
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firma Digital")),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Signature(
                controller: _signatureController,
                width: double.infinity,
                height: double.infinity,
                backgroundColor: Colors.transparent, // Sin fondo
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _signatureController.clear(),
                child: Text("Borrar"),
              ),
              ElevatedButton(
                onPressed: _saveSignature,
                child: Text("Guardar"),
              ),
            ],
          ),
          if (_signatureImage != null)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.memory(_signatureImage!), // Mostrar la firma guardada
            ),
        ],
      ),
    );
  }
}
