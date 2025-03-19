import 'package:help_desk/internal/users/request/domain/entities/document.dart';

class DocumentModel extends Document {
  DocumentModel({
    super.documentId,
    super.fileExtension,
    super.file,
    super.type
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      documentId: json["iddocumento"] ?? json["idarchivo"],
      fileExtension: json["extension"] ?? json["nombreDocumento"],
      file: json["archivo"] ?? json["contenido"],
      type: json["tipo"] ?? json["fechaCarga"],
    );
  }

  factory DocumentModel.fromEntity(Document doc) {
    return DocumentModel(
      documentId: doc.documentId,
      fileExtension: doc.fileExtension,
      file: doc.file,
      type: doc.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "iddocumento": documentId,
      "extension": fileExtension,
      "archivo": file,
      "tipo": type,
    };
  }
}