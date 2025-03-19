import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignatureWidget extends StatefulWidget {
  final Function(String base64Signature) onSignatureSaved;

  const SignatureWidget({super.key, required this.onSignatureSaved});

  @override
  State<SignatureWidget> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureWidget> {
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
  );

  Uint8List? _signatureImage;

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _getSignatureBase64() async {
    if (_signatureController.isNotEmpty) {
      final Uint8List? data = await _signatureController.toPngBytes();
      if (data != null) {
        String base64String = base64Encode(data);
        widget.onSignatureSaved(base64String);
        setState(() {
          _signatureImage = data;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_signatureImage == null)
        Expanded(
          child: Container(
            color: Colors.grey[200],
            child: Signature(
              controller: _signatureController,
              width: double.infinity,
              height: double.infinity,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
        if (_signatureImage == null)
        const SizedBox(height: 20),
        if (_signatureImage == null)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              onPressed: () => _signatureController.clear(),
              child: const Text("Borrar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: _getSignatureBase64,
              child: const Text("Confirmar Firma"),
            ),
          ],
        ),
        if (_signatureImage != null)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(child: Image.memory(_signatureImage!)),
          ),
      ],
    );
  }
}
