part of 'technician_request_details_bloc.dart';

@immutable
sealed class TechnicianRequestDetailsEvent {}

class GetTechnicianRequestById extends TechnicianRequestDetailsEvent {
  final String requestId;

  GetTechnicianRequestById({
    required this.requestId,
  });
}

class GetTechnicianDocumentFile extends TechnicianRequestDetailsEvent {
  final List<Document> documents;

  GetTechnicianDocumentFile({
    required this.documents,
  });
}

class GetServicePdf extends TechnicianRequestDetailsEvent {
  final String serviceToken;

  GetServicePdf({
    required this.serviceToken,
  });
}
