import 'package:flutter/material.dart';
import 'package:help_desk/internal/users/request/domain/entities/request.dart';
import 'package:help_desk/internal/users/request/presentation/widgets/request_details_widgets/applicant_information.dart';
import 'package:help_desk/internal/users/request/presentation/widgets/request_details_widgets/contact_information.dart';
import 'package:help_desk/internal/users/request/presentation/widgets/request_details_widgets/request_information.dart';

class RequestMenuWidget extends StatelessWidget {
  final Request requestData;

  const RequestMenuWidget({
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
            RequestInformationWidget(requestData: requestData),
            const SizedBox(height: 20),
            ApplicantInformationWidget(requestData: requestData),
            const SizedBox(height: 20),
            ContactInformationWidget(requestData: requestData),
          ],
        ),
      ),
    );
  }
}