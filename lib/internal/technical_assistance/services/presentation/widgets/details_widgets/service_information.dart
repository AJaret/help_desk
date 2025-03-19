import 'package:flutter/material.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';
import 'package:help_desk/shared/helpers/status_information.dart';
import 'package:intl/intl.dart';

class ServiceInformationWidget extends StatelessWidget {
  final TechnicianService serviceData;
  const ServiceInformationWidget({super.key, required this.serviceData});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String formattedDate = '';
    if (serviceData.date != null) {
      DateTime parsedDate = DateTime.parse(serviceData.date!);
      formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    }
    Color? statusColor;
    Color? textColor;
    String? statusDesc;
    Map<String, dynamic> statusInfo = getStatusInformation(serviceData.status ?? 'Solicitud registrada');
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
              serviceData.serviceFolio ?? 'No hay folio',
              style: TextStyle(
                color: serviceData.serviceFolio != null ? Colors.black : Colors.grey,
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
                statusDesc ?? 'No hay estad de la solicitud',
                style: TextStyle(
                  color: serviceData.serviceFolio != null ? textColor : Colors.grey,
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
              'Prioridad: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: serviceData.priority == 'VIP'
                    ? Colors.red
                    : serviceData.priority == 'Media'
                        ? Colors.yellow
                        : Colors.grey,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(5.0),
              child: Text(
                serviceData.priority ?? '',
                style: TextStyle(
                  color: serviceData.priority == 'VIP'
                      ? Colors.white
                      : serviceData.priority == 'Media'
                          ? Colors.black
                          : Colors.white,
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
              'Actividad principal: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                serviceData.mainActivity ?? '',
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
              'Servicio: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                serviceData.serviceTitle ?? '',
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
              'Descripción: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                serviceData.serviceDescription ?? '',
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
              'Observaciones: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                serviceData.observations ?? '',
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
                serviceData.inventoryNumber ?? '',
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