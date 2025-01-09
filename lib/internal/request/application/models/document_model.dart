import 'package:help_desk/internal/request/domain/entities/document.dart';

class DocumentModel extends Document {
  DocumentModel({
    super.documentId,
    super.fileExtension,
    super.file,
    super.type
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      documentId: json["iddocumento"],
      fileExtension: json["extension"],
      file: json["archivo"],
      type: json["tipo"],
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
}