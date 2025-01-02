import 'package:help_desk/internal/request/domain/entities/request.dart';

class RequestModel extends Request {
  RequestModel({
    super.requestId,
    super.date,
    super.dependency,
    super.status,
    super.folio,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      requestId: json["token"],
      date: json["fecha"],
      dependency: json["direccion"],
      status: json["estado"],
      folio: json["folio"],
    );
  }

  factory RequestModel.fromEntity(Request req) {
    return RequestModel(
      requestId: req.requestId,
      date: req.date,
      dependency: req.dependency,
      status: req.status,
      folio: req.folio,
    );
  }
}
