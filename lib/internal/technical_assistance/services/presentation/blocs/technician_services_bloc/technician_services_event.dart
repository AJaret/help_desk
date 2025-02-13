part of 'technician_services_bloc.dart';

@immutable
sealed class TechnicianServicesEvent {}

class GetTechnicianServices extends TechnicianServicesEvent {}

class GetTechnicianServiceDetails extends TechnicianServicesEvent {
  final int serviceId;

  GetTechnicianServiceDetails(this.serviceId);
}

class GetDocumentById extends TechnicianServicesEvent {
  final int documentId;

  GetDocumentById(this.documentId);
}