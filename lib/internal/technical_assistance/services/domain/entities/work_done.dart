import 'package:help_desk/internal/users/request/domain/entities/document.dart';

class WorkDone {
  final int? workId;
  final String? date;
  final String? workDescription;
  final List<Document>? documents;

  WorkDone({
    this.workId,
    this.date,
    this.workDescription,
    this.documents
  });
}