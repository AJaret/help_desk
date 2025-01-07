import 'package:flutter/material.dart';
import 'package:help_desk/internal/request/domain/entities/request.dart';

class ContactInformationWidget extends StatelessWidget {
  final Request requestData;
  const ContactInformationWidget({super.key, required this.requestData});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> phoneNumbers = requestData.phone?.split(',') ?? [];
    List<String> extensions = requestData.extensionNumber?.split(',') ?? [];
    List<String> emails = requestData.email?.split(',') ?? [];
    String formatPhoneNumber(String phone) {
      if (phone.length >= 8) {
        String areaCode = phone.substring(0, 3);
        String remaining = phone.substring(3);
        return '($areaCode) $remaining';
      }
      return phone;
    }

    return Column(
      children: [
        Text(
          'Datos de contacto',
          style: TextStyle(
            color: Colors.black,
            fontSize: size.width * 0.055,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              'Teléfono: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: phoneNumbers.isNotEmpty ?
              Wrap(
                spacing: 8.0,
                children: phoneNumbers.map((phone) {
                  String formattedPhone = formatPhoneNumber(phone.trim());
                  return Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      formattedPhone,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.width * 0.04,
                      ),
                    ),
                  );
                }).toList(),
              ) : Text('No hay teléfono(s) registrado(s)', style: TextStyle(fontSize: size.width * 0.04,)),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              'Extensión: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: extensions.isNotEmpty ?
              Wrap(
                spacing: 8.0,
                children: extensions.map((ext) {
                  return Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      ext.trim(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.width * 0.04,
                      ),
                    ),
                  );
                }).toList(),
              ) : Text('No hay extensión(es) registrada(s)', style: TextStyle(fontSize: size.width * 0.04,),),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              'Correo electrónico: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: emails.isNotEmpty ? 
              Wrap(
                spacing: 8.0,
                children: emails.map((email) {
                  return Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      email.trim(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.width * 0.04,
                      ),
                    ),
                  );
                }).toList(),
              ): Text('No hay correo(s) registrado(s)', style: TextStyle(fontSize: size.width * 0.04,),),
            ),
          ],
        ),
      ],
    );
  }
}