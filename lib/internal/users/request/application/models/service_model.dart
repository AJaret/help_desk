import 'package:help_desk/internal/users/request/domain/entities/service.dart';

class ServiceModel extends Service {
  ServiceModel({
    super.registrationDate,
    super.serviceNumber,
    super.assignedAgent,
    super.status,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      registrationDate: json["fechaRegistro"],
      serviceNumber: json["numeroServicio"],
      assignedAgent: json["agenteAsignado"],
      status: json["estado"],
    );
  }

  factory ServiceModel.fromEntity(Service se) {
    return ServiceModel(
      registrationDate: se.registrationDate,
      serviceNumber: se.serviceNumber,
      assignedAgent: se.assignedAgent,
      status: se.status,
    );
  }
}