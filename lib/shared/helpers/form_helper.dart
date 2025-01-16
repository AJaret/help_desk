import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildMultipleItemsInventoryField({
  required TextEditingController inventoryController,
  required List<String> inventoryNumbers,
  required Function(List<String> items, TextEditingController controller) addItem,
  required Function(int index, List<String> items) removeItem
}){
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: const Color(0xff99825D),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.inventory, color: Color(0xFF8B1A42)),
                SizedBox(width: 8),
                Text(
                  'Registra un número de inventario',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Text(
              'x${inventoryNumbers.length}',
              style: const TextStyle(
                color: Colors.white,
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
              backgroundColor: const Color(0xFF8B1A42),
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
      )
    ],
  );
}


Widget buildMultipleItemsPhoneField({
  required TextEditingController phoneController,
  required List<String> phoneNumbers,
  required Function(List<String> items, TextEditingController controller) addItem,
  required Function(int index, List<String> items) removeItem
}){
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: const Color(0xff99825D),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.inventory, color: Color(0xFF8B1A42)),
                SizedBox(width: 8),
                Text(
                  'Registra un teléfono de contacto',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Text(
              'x${phoneNumbers.length}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (value) => phoneNumbers.isEmpty || value == null ? "Al menos un número de teléfono es requerido" : null,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => addItem(phoneNumbers, phoneController),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B1A42),
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
        itemCount: phoneNumbers.length,
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
                      phoneNumbers[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => removeItem(index, phoneNumbers),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          );
        },
      )
    ],
  );
}

Widget buildMultipleItemsEmailField({
  required TextEditingController emailController,
  required List<String> emails,
  required Function(List<String> items, TextEditingController controller) addItem,
  required Function(int index, List<String> items) removeItem,
  required BuildContext context
}){
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: const Color(0xff99825D),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.inventory, color: Color(0xFF8B1A42)),
                SizedBox(width: 8),
                Text(
                  'Anexar correos adicionales',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Text(
              'x${emails.length}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Correo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              final email = emailController.text.trim();
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

              if (!emailRegex.hasMatch(email)) {
                showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: const Text('Error'),
                      content: const Text('Ingrese un correo válido.'),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('Aceptar'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    );
                  },
                );
              } else {
                addItem(emails, emailController);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B1A42),
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
        itemCount: emails.length,
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
                      emails[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => removeItem(index, emails),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          );
        },
      )
    ],
  );
}

Widget buildMultipleItemsPhoneExtensionField({
  required TextEditingController extensionController,
  required List<String> extensions,
  required Function(List<String> items,TextEditingController controller) addItem,
  required Function(int index, List<String> items) removeItem
}){
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: const Color(0xff99825D),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.inventory, color: Color(0xFF8B1A42)),
                SizedBox(width: 8),
                Text(
                  'Extension(es) de contacto',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Text(
              'x${extensions.length}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: extensionController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Extensión',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => addItem(extensions, extensionController),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B1A42),
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
        itemCount: extensions.length,
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
                      extensions[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => removeItem(index, extensions),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          );
        },
      )
    ],
  );
}