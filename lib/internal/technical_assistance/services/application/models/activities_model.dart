import 'package:help_desk/internal/technical_assistance/services/application/models/work_done_model.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/activity.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/work_done.dart';

class ActivitiesModel extends Activity {
  ActivitiesModel({
    super.activityId,
    super.date,
    super.activityDescription,
    super.worksDone
  });

  factory ActivitiesModel.fromJson(Map<String, dynamic> json) {
    return ActivitiesModel(
      activityId: json["idactividad"],
      date: json["fechaRegistro"],
      activityDescription: json["actividad"],
      worksDone: json["trabajos"]?.map<WorkDone>((data) => WorkDoneModel.fromJson(data)).toList(),
    );
  }

  factory ActivitiesModel.fromEntity(Activity act) {
    return ActivitiesModel(
      activityId: act.activityId,
      date: act.date,
      activityDescription: act.activityDescription,
      worksDone: act.worksDone,
    );
  }
}