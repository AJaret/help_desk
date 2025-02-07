import 'package:help_desk/internal/technical_assistance/services/application/models/activities_model.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/activity.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/assigned_agent.dart';

class AssignedAgentModel extends AssignedAgent {
  AssignedAgentModel({
    super.assignationId,
    super.assignedAgent,
    super.date,
    super.status,
    super.idStatus,
    super.activities
  });

  factory AssignedAgentModel.fromJson(Map<String, dynamic> json) {
    return AssignedAgentModel(
      assignationId: json["idasignacion"],
      assignedAgent: json["agenteAsignado"],
      date: json["fechaRegistro"],
      status: json["estado"],
      idStatus: json["idestado"],
      activities: json["actividades"]?.map<Activity>((data) => ActivitiesModel.fromJson(data)).toList(),
    );
  }

  factory AssignedAgentModel.fromEntity(AssignedAgent assig) {
    return AssignedAgentModel(
      assignationId: assig.assignationId,
      assignedAgent: assig.assignedAgent,
      date: assig.date,
      status: assig.status,
      idStatus: assig.idStatus,
      activities: assig.activities,
    );
  }
}