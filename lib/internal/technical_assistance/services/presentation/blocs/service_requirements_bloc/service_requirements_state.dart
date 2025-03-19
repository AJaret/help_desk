part of 'service_requirements_bloc.dart';

@immutable
sealed class ServiceRequirementsState {}

final class ServiceRequirementsInitial extends ServiceRequirementsState {}

final class GettingServiceRequirements extends ServiceRequirementsState {}

final class ServiceRequirementsSuccess extends ServiceRequirementsState {
  final Map<String, dynamic> serviceRequirements;

  ServiceRequirementsSuccess(this.serviceRequirements);
}

final class ErrorGettingServiceRequirements extends ServiceRequirementsState {
  final String message;

  ErrorGettingServiceRequirements(this.message);
}

final class ClosingService extends ServiceRequirementsState {}

final class CloseServiceSuccess extends ServiceRequirementsState {
  final String pdfBase64;

  CloseServiceSuccess(this.pdfBase64);
}

final class ErrorClosingService extends ServiceRequirementsState {
  final String message;

  ErrorClosingService(this.message);
}