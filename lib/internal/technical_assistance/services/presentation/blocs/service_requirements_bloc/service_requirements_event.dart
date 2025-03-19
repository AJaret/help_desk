part of 'service_requirements_bloc.dart';

@immutable
sealed class ServiceRequirementsEvent {}

class GetServiceRequirements extends ServiceRequirementsEvent {
  final int serviceId;
  
  GetServiceRequirements(this.serviceId);
}

class PostCloseService extends ServiceRequirementsEvent {
  final ClosedService serviceData;
  
  PostCloseService(this.serviceData);
}