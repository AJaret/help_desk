import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';

class TechnicianServiceModel extends TechnicianService {
  TechnicianServiceModel({
    super.date,
    super.dependency,
    super.documentNumber,
    super.idServicio,
    super.priority,
    super.priorityId,
    super.requestId,
    super.serviceId,
    super.status
  });

  factory TechnicianServiceModel.fromJson(Map<String, dynamic> json) {
    return TechnicianServiceModel(
      idServicio: json["idservicio"],
      date: json["fecha"],
      documentNumber: json["numeroOficio"],
      dependency: json["direccion"],
      status: json["estado"],
      requestId: json["folioSolicitud"],
    );
  }

  // factory TechnicianServiceModel.fromEntity(Catalog dependency) {
  //   return TechnicianServiceModel(
  //     value: dependency.value,
  //     label: dependency.label,
  //     decentralized: dependency.decentralized,
  //   );
  // }
}