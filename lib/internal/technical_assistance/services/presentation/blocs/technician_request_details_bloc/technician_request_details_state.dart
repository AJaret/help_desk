part of 'technician_request_details_bloc.dart';

@immutable
sealed class TechnicianRequestDetailsState {}

final class TechnicianRequestDetailsInitial extends TechnicianRequestDetailsState {}

final class GettingTechnicianRequestDetails extends TechnicianRequestDetailsState {}

final class TechnicianRequestDetailsSuccess extends TechnicianRequestDetailsState {
  final TechnicianService request;

  TechnicianRequestDetailsSuccess(this.request);
}

final class ErrorGettingTechnicianRequestDetails extends TechnicianRequestDetailsState {
  final String message;

  ErrorGettingTechnicianRequestDetails(this.message);
}

final class GettingTechnicianDocumentFile extends TechnicianRequestDetailsState {}

final class TechnicianDocumentFileSuccess extends TechnicianRequestDetailsState {
  final List<Document> docs;

  TechnicianDocumentFileSuccess(this.docs);
}

final class ErrorGettingTechnicianDocumentFile extends TechnicianRequestDetailsState {
  final String message;

  ErrorGettingTechnicianDocumentFile(this.message);
}

final class GettingServicePdf extends TechnicianRequestDetailsState {}

final class ServicePdfSuccess extends TechnicianRequestDetailsState {
  final String pdf;

  ServicePdfSuccess(this.pdf);
}

final class ErrorGettingServicePdf extends TechnicianRequestDetailsState {
  final String message;

  ErrorGettingServicePdf(this.message);
}