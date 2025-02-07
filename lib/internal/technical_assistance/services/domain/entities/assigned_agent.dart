import 'package:help_desk/internal/technical_assistance/services/domain/entities/activity.dart';

class AssignedAgent {
  final int? assignationId;
  final String? assignedAgent;
  final String? date;
  final String? status;
  final int? idStatus;
  final List<Activity>? activities;

  AssignedAgent({
    this.assignationId,
    this.assignedAgent,
    this.date,
    this.status,
    this.idStatus,
    this.activities
  });
}