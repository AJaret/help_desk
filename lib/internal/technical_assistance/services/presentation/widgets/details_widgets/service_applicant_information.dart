import 'package:flutter/material.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';

class ServiceApplicantInformationWidget extends StatelessWidget {
  final TechnicianService serviceData;
  const ServiceApplicantInformationWidget({super.key, required this.serviceData});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          'Información del solicitante',
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
              'Dirección: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                serviceData.dependency ?? '',
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
              'Ubicación: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                serviceData.location ?? '',
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
              'Ubicación física: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                serviceData.physicalLocation ?? '',
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
              'Dirigirse con ',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                serviceData.addressWith ?? '',
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