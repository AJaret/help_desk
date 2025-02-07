import 'package:help_desk/internal/technical_assistance/services/domain/entities/work_done.dart';

class Activity {
  final int? activityId;
  final String? date;
  final String? activityDescription;
  final List<WorkDone>? worksDone;

  Activity({
    this.activityId,
    this.date,
    this.activityDescription,
    this.worksDone
  });
}