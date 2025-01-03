import 'package:help_desk/internal/request/domain/entities/request.dart';

class RequestModel extends Request {
  RequestModel({
    super.requestId,
    super.registrationDate,
    super.employee,
    super.dependency,
    super.documentNumber,
    super.serviceDescription,
    super.observations,
    super.location,
    super.physicalServiceLocation,
    super.idStatus,
    super.status,
    super.phone,
    super.extensionNumber,
    super.email,
    super.applicant,
    super.inventoryNumber,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      requestId: json["folio"],
      registrationDate: json["fechaRegistro"],
      employee: json["empleado"],
      dependency: json["direccion"],
      documentNumber: json["numeroOficio"],
      serviceDescription: json["descripcionServicio"],
      observations: json["observaciones"],
      location: json["ubicacion"],
      physicalServiceLocation: json["ubicacionFisicaServicio"],
      idStatus: json["idestado"],
      status: json["estado"],
      phone: json["telefono"],
      extensionNumber: json["extension"],
      email: json["correo"],
      applicant: json["solicitante"],
      inventoryNumber: json["numeroInventario"],
    );
  }

  factory RequestModel.fromEntity(Request req) {
    return RequestModel(
      requestId: req.requestId,
      registrationDate: req.registrationDate,
      employee: req.employee,
      dependency: req.dependency,
      documentNumber: req.documentNumber,
      serviceDescription: req.serviceDescription,
      observations: req.observations,
      location: req.location,
      physicalServiceLocation: req.physicalServiceLocation,
      idStatus: req.idStatus,
      status: req.status,
      phone: req.phone,
      extensionNumber: req.extensionNumber,
      email: req.email,
      applicant: req.applicant,
      inventoryNumber: req.inventoryNumber,
    );
  }
}