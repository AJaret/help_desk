import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:help_desk/internal/users/request/domain/entities/request.dart';
import 'package:help_desk/shared/helpers/status_information.dart';
import 'package:intl/intl.dart';

class RequestInformationWidget extends StatelessWidget {
  final Request requestData;
  const RequestInformationWidget({super.key, required this.requestData});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String formattedDate = '';
    if (requestData.registrationDate != null) {
      DateTime parsedDate = DateTime.parse(requestData.registrationDate!);
      formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    }
    Color? statusColor;
    Color? textColor;
    String? statusDesc;
    Map<String, dynamic> statusInfo = getStatusInformation(requestData.status ?? 'Solicitud registrada');
    statusColor = statusInfo['statusColor'];
    statusDesc = statusInfo['statusDesc'];
    textColor = statusInfo['textColor'];

    return Column(
      children: [
        Text(
          'Información de la solicitud',
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
              'Folio: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              requestData.requestId ?? '',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              'Fecha de registro: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              formattedDate,
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              'Estado de la solicitud: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(5.0),
              child: Text(
                statusDesc ?? '',
                style: TextStyle(
                  color: textColor,
                  fontSize: size.width * 0.04,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              'Descripción: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Html(
                data: requestData.serviceDescription ?? ''
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              'Observaciones: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                requestData.observations ?? '',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * 0.04,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              'Número de inventario: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                requestData.inventoryNumber ?? '',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * 0.04,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}