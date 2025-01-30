import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_desk/shared/helpers/form_helper.dart';

Widget buildStep2({
  required TextEditingController descriptionController,
  required TextEditingController aditionalDescriptionController,
  required TextEditingController inventoryController,
  required List<String> inventoryNumbers,
  required Function(List<String> items, TextEditingController controller) addItem,
  required Function(int index, List<String> items) removeItem,
  required int characterCount,
  required Function(String) onDescriptionChanged,
  required BuildContext context
}) {
  return SingleChildScrollView(
    child: Expanded(
      child: Column(
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Numero(s) de inventario(s) en caso de aplicar'),
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
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all()
            ),
            child: buildMultipleItemsInventoryField(
              inventoryController: inventoryController,
              inventoryNumbers: inventoryNumbers,
              addItem: addItem,
              removeItem: removeItem
            ),
          ),
        ],
      ),
    ),
  );
}
