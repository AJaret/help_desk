import 'package:flutter/material.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/widgets/details_widgets/service_applicant_information.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/widgets/details_widgets/service_contact_information.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/widgets/details_widgets/service_information.dart';

class ServiceDetailsMenuWidget extends StatelessWidget {
  final TechnicianService requestData;

  const ServiceDetailsMenuWidget({
    super.key,
    required this.requestData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ServiceInformationWidget(serviceData: requestData),
            const SizedBox(height: 20),
            ServiceApplicantInformationWidget(serviceData: requestData),
            const SizedBox(height: 20),
            ServiceContactInformationWidget(serviceData: requestData),
          ],
        ),
      ),
    );
  }
}