import 'package:help_desk/internal/users/request/application/models/document_model.dart';
import 'package:help_desk/internal/users/request/domain/entities/new_request.dart';

class NewRequestModel extends NewRequest {
  NewRequestModel({
    super.documentNumber,
    super.serviceDescription,
    super.observations,
    super.inventoryNumber,
    super.serviceLocation,
    super.physicalServiceLocation,
    super.addressWith,
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
      inventoryNumber: json["numerosInventario"],
      serviceLocation: json["ubicacionServicio"],
      physicalServiceLocation: json["ubicacionFisica"],
      addressWith: json["dirigirseCon"],
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
      addressWith: req.addressWith,
      phoneList: req.phoneList,
      extensions: req.extensions,
      emails: req.emails,
      documents: req.documents
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "numeroOficio": documentNumber,
      "descripcionServicio": serviceDescription,
      "observaciones": observations,
      "numerosInventario": inventoryNumber != null ? inventoryNumber!.map((inv) => {"numeroInventario": inv}).toList() : [],
      "ubicacionServicio": serviceLocation,
      "ubicacionFisica": physicalServiceLocation,
      "dirigirseCon": addressWith,
      "telefonos": phoneList != null ? phoneList!.map((phone) => {"telefono": phone}).toList() : [],
      "extensiones": extensions != null ? extensions!.map((ext) => {"extension": ext}).toList() : [],
      "correos": emails != null ? emails!.map((email) => {"correo": email}).toList() : [],
      "documentos": documents != null ? documents!.map((doc) => DocumentModel.fromEntity(doc).toJson()).toList() : [],
    };
  }
}