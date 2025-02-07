import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';

class TechnicianServiceModel extends TechnicianService {
  TechnicianServiceModel({
    super.idServicio,
    super.date,
    super.documentNumber,
    super.dependency,
    super.status,
    super.requestFolio,
    super.serviceFolio,
    super.priority,
    super.priorityId,
  });

  factory TechnicianServiceModel.fromJson(Map<String, dynamic> json) {
    return TechnicianServiceModel(
      idServicio: json["idservicio"],
      date: json["fecha"],
      documentNumber: json["numeroOficio"],
      dependency: json["direccion"],
      status: json["estado"],
      requestFolio: json["folioSolicitud"],
      serviceFolio: json["folioServicio"],
      priority: json["prioridad"],
      priorityId: json["idprioridad"],
    );
  }

  factory TechnicianServiceModel.fromEntity(TechnicianService ser) {
    return TechnicianServiceModel(
      idServicio: ser.idServicio,
      date: ser.date,
      documentNumber: ser.documentNumber,
      dependency: ser.dependency,
      status: ser.status,
      requestFolio: ser.requestFolio,
      serviceFolio: ser.serviceFolio,
      priority: ser.priority,
      priorityId: ser.priorityId,
    );
  }
}