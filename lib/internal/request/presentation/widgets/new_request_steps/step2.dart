import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildStep2({
  required TextEditingController descriptionController,
  required TextEditingController aditionalDescriptionController,
  required TextEditingController inventoryController,
  required int characterCount,
  required Function(String) onDescriptionChanged,
  required BuildContext context
}) {
  return Column(
    children: [
      TextFormField(
        minLines: 5,
        maxLines: 10,
        maxLengthEnforcement: MaxLengthEnforcement.none,
        maxLength: 4000,
        controller: descriptionController,
        onChanged: (value) => onDescriptionChanged(value),
        decoration: InputDecoration(
          counterText: '$characterCount/4000 Máximo',
          labelText: "Describe la solicitud del servicio *",
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "El campo es requerido" : null,
      ),
      const SizedBox(height: 20),
      TextFormField(
        minLines: 3,
        maxLines: 8,
        maxLengthEnforcement: MaxLengthEnforcement.none,
        maxLength: 4000,
        controller: aditionalDescriptionController,
        decoration: const InputDecoration(
          labelText: "Observaciones adicionales",
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              maxLengthEnforcement: MaxLengthEnforcement.none,
              maxLength: 200,
              controller: inventoryController,
              decoration: const InputDecoration(
                labelText: "Número de inventario",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Tooltip(
            message: "Ingrese el número de inventario único para identificar el artículo.",
            child: IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                    title: const Text("Información"),
                    content: const Text("Indica el número de inventario del equipo; laptop, computadora de escritorio, impresora. Ejemplo 12345678901"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cerrar"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ],
  );
}
