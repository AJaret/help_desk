import 'package:help_desk/internal/technical_assistance/services/domain/entities/work_done.dart';

class WorkDoneModel extends WorkDone {
  WorkDoneModel({
    super.workId,
    super.date,
    super.workDescription,
    super.documents
  });

  factory WorkDoneModel.fromJson(Map<String, dynamic> json) {
    return WorkDoneModel(
      workId: json["idtrabajo"],
      date: json["fechaRegistro"],
    );
  }

  factory WorkDoneModel.fromEntity(WorkDone work) {
    return WorkDoneModel(
      workId: work.workId,
      date: work.date,
      workDescription: work.workDescription,
      documents: work.documents
    );
  }
}