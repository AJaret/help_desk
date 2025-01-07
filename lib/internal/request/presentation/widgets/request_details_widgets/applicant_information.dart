import 'package:flutter/material.dart';
import 'package:help_desk/internal/request/domain/entities/request.dart';

class ApplicantInformationWidget extends StatelessWidget {
  final Request requestData;
  const ApplicantInformationWidget({super.key, required this.requestData});

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
                requestData.dependency ?? '',
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
              'Solicitante: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                requestData.applicant ?? '',
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
                requestData.location ?? '',
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
                requestData.physicalServiceLocation ?? '',
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