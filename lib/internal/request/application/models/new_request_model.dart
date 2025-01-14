import 'package:help_desk/internal/request/domain/entities/new_request.dart';

class NewRequestModel extends NewRequest {
  NewRequestModel({
    super.documentNumber,
    super.serviceDescription,
    super.observations,
    super.inventoryNumber,
    super.serviceLocation,
    super.physicalServiceLocation,
    super.phoneList,
    super.extensions,
    super.emails,
    super.documents,
  });

  factory NewRequestModel.fromJson(Map<String, dynamic> json) {
    return NewRequestModel(
      documentNumber: json["numeroOficio"],
      serviceDescription: json["descripcionServicio"],
      observations: json["observations"],
      inventoryNumber: json["numeroInventario"],
      serviceLocation: json["ubicacionServicio"],
      physicalServiceLocation: json["ubicacionFisica"],
      phoneList: json["telefonos"],
      extensions: json["extensiones"],
      emails: json["correos"],
      documents: json["documentos"],
    );
  }

  factory NewRequestModel.fromEntity(NewRequest req) {
    return NewRequestModel(
      documentNumber: req.documentNumber,
      serviceDescription: req.serviceDescription,
      observations: req.observations,
      inventoryNumber: req.inventoryNumber,
      serviceLocation: req.serviceLocation,
      physicalServiceLocation: req.physicalServiceLocation,
      phoneList: req.phoneList,
      extensions: req.extensions,
      emails: req.emails,
      documents: req.documents
    );
  }
}