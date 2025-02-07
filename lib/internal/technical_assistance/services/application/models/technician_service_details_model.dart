import 'package:help_desk/internal/technical_assistance/services/application/models/assigned_agent_model.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/assigned_agent.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';
import 'package:help_desk/internal/users/request/application/models/document_model.dart';
import 'package:help_desk/internal/users/request/application/models/follow_up_model.dart';
import 'package:help_desk/internal/users/request/domain/entities/document.dart';
import 'package:help_desk/internal/users/request/domain/entities/follow_up.dart';

class TechnicianServiceDetailsModel extends TechnicianService {
  TechnicianServiceDetailsModel({
    super.idServicio,
    super.date,
    super.documentNumber,
    super.dependency,
    super.status,
    super.requestFolio,
    super.serviceFolio,
    super.priority,
    super.priorityId,
    super.registrationDate,
    super.employee,
    super.serviceDescription,
    super.observations,
    super.location,
    super.physicalLocation,
    super.phone,
    super.phoneExtension,
    super.email,
    super.applicant,
    super.requestToken,
    super.serviceTitle,
    super.inventoryNumber,
    super.addressWith,
    super.mainActivity,
    super.serviceToken,
    super.registrationEmployee,
    super.documents,
    super.assignedAgent,
    super.followUp
  });

  factory TechnicianServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    return TechnicianServiceDetailsModel(
      requestFolio: json["folioSolicitud"],
      date: json["fechaRegistro"],
      employee: json["empleado"],
      dependency: json["direccion"],
      documentNumber: json["numeroOficio"],
      serviceDescription: json["descripcionServicio"],
      observations: json["observaciones"],
      location: json["ubicacion"],
      physicalLocation: json["ubicacionFisicaServicio"],
      status: json["estado"],
      phone: json["telefono"],
      phoneExtension: json["extension"],
      email: json["correo"],
      applicant: json["solicitante"],
      serviceFolio: json["folioServicio"],
      requestToken: json["tokenSolicitud"],
      priorityId: json["idprioridad"],
      priority: json["prioridad"],
      serviceToken: json["tokenServicio"],
      inventoryNumber: json["numeroInventario"],
      addressWith: json["dirigirseCon"],
      mainActivity: json["actividadPrincipal"],
      serviceTitle: json["servicio"],
      registrationEmployee: json["agenteRegistra"],
      documents: json["documentos"]?.map<Document>((data) => DocumentModel.fromJson(data)).toList(),
      assignedAgent: json["agentesAsignados"]?.map<AssignedAgent>((data) => AssignedAgentModel.fromJson(data)).toList(),
      followUp: json["seguimiento"]?.map<FollowUp>((data) => FollowUpModel.fromJson(data)).toList(),
    );
  }

  factory TechnicianServiceDetailsModel.fromEntity(TechnicianService ser) {
    return TechnicianServiceDetailsModel(
      requestFolio: ser.requestFolio,
      date: ser.date,
      employee: ser.employee,
      dependency: ser.dependency,
      documentNumber: ser.documentNumber,
      serviceDescription: ser.serviceDescription,
      observations: ser.observations,
      location: ser.location,
      physicalLocation: ser.physicalLocation,
      status: ser.status,
      phone: ser.phone,
      phoneExtension: ser.phoneExtension,
      email: ser.email,
      applicant: ser.applicant,
      serviceFolio: ser.serviceFolio,
      requestToken: ser.requestToken,
      priorityId: ser.priorityId,
      priority: ser.priority,
      serviceToken: ser.serviceToken,
      inventoryNumber: ser.inventoryNumber,
      addressWith: ser.addressWith,
      mainActivity: ser.mainActivity,
      serviceTitle: ser.serviceTitle,
      registrationEmployee: ser.registrationEmployee,
    );
  }
}