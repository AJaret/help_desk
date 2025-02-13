part of 'technician_services_bloc.dart';

@immutable
sealed class TechnicianServicesState {}

final class TechnicianServicesInitial extends TechnicianServicesState {}

final class GettingTechnicianServices extends TechnicianServicesState {}

final class TechnicianServicesSuccess extends TechnicianServicesState {
  final List<TechnicianService> services;

  TechnicianServicesSuccess(this.services);
}

final class ErrorGettingTechnicianServices extends TechnicianServicesState {
  final String message;

  ErrorGettingTechnicianServices(this.message);
}

final class TechnicianServiceDetailsInitial extends TechnicianServicesState {}

final class GettingTechnicianServiceDetails extends TechnicianServicesState {}

final class TechnicianServiceDetailsSuccess extends TechnicianServicesState {
  final TechnicianService services;

  TechnicianServiceDetailsSuccess(this.services);
}

final class ErrorGettingTechnicianServiceDetails extends TechnicianServicesState {
  final String message;

  ErrorGettingTechnicianServiceDetails(this.message);
}

final class GettingDocumentById extends TechnicianServicesState {}

final class GetDocumentByIdSuccess extends TechnicianServicesState {
  final Document doc;

  GetDocumentByIdSuccess(this.doc);
}

final class ErrorGettingDocumentById extends TechnicianServicesState {
  final String message;

  ErrorGettingDocumentById(this.message);
}