import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F3FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.inventory, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'Registra un número de inventario',
                            style: TextStyle(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'x${inventoryNumbers.length}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: inventoryController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'No. de inventario',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => addItem(inventoryNumbers, inventoryController),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Agregar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: inventoryNumbers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.circle, size: 8, color: Colors.black),
                              const SizedBox(width: 8),
                              Text(
                                inventoryNumbers[index],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () => removeItem(index, inventoryNumbers),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
