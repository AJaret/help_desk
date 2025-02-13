import 'package:flutter/material.dart';
import 'package:help_desk/shared/helpers/form_helper.dart';

Widget buildStep4({
  required TextEditingController phoneController,
  required TextEditingController emailController,
  required TextEditingController extensionController,
  required TextEditingController referredPersonController,
  required List<String> phoneNumbers,
  required List<String> emails,
  required List<String> extensions,
  required Function(List<String> items, TextEditingController controller) addItem,
  required Function(int index, List<String> items) removeItem,
  required BuildContext context
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: referredPersonController,
          decoration: const InputDecoration(
            labelText: "Persona que atenderá al técnico",
            border: OutlineInputBorder(),
          ),
          validator: (value) => value == null || value.isEmpty ? "El nombre es requerido" : null,
        ),
        const SizedBox(height: 20,),
        Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all()
          ),
          child: buildMultipleItemsPhoneField(phoneController: phoneController, phoneNumbers: phoneNumbers, addItem: addItem, removeItem: removeItem)
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              
            )
          ),
          child: buildMultipleItemsEmailField(emailController: emailController, emails: emails, addItem: addItem, removeItem: removeItem, context: context),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              
            )
          ),
          child: buildMultipleItemsPhoneExtensionField(extensionController: extensionController, extensions: extensions, addItem: addItem, removeItem: removeItem),
        ),
      ],
    ),
  );
}
