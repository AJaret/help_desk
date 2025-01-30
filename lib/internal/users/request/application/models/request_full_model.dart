import 'package:help_desk/internal/users/request/application/models/document_model.dart';
import 'package:help_desk/internal/users/request/application/models/follow_up_model.dart';
import 'package:help_desk/internal/users/request/application/models/request_model.dart';
import 'package:help_desk/internal/users/request/application/models/service_model.dart';
import 'package:help_desk/internal/users/request/domain/entities/document.dart';
import 'package:help_desk/internal/users/request/domain/entities/follow_up.dart';
import 'package:help_desk/internal/users/request/domain/entities/request_full.dart';
import 'package:help_desk/internal/users/request/domain/entities/service.dart';

class RequestFullModel extends RequestFull {
  RequestFullModel({
    super.requestDetails,
    super.documents,
    super.followUps,
    super.services
  });

  factory RequestFullModel.fromJson(Map<String, dynamic> json) {
    return RequestFullModel(
      requestDetails: json["solicitud"] != null ? RequestModel.fromJson(json["solicitud"]) : null,
      documents: json["documentos"]?.map<Document>((data) => DocumentModel.fromJson(data)).toList(),
      followUps: json["seguimiento"]?.map<FollowUp>((data) => FollowUpModel.fromJson(data)).toList(),
      services: json["servicios"]?.map<Service>((data) => ServiceModel.fromJson(data)).toList()
    );
  }

  factory RequestFullModel.fromEntity(RequestFull req) {
    return RequestFullModel(
      requestDetails: req.requestDetails,
      documents: req.documents,
      followUps: req.followUps,
      services: req.services
    );
  }
}