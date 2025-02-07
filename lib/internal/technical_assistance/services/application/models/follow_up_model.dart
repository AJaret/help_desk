import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_follow_up.dart';

class FollowUpModel extends TechnicianFollowUp {
  FollowUpModel({
    super.date,
    super.user,
    super.status,
    super.assignedAgent
  });

  factory FollowUpModel.fromJson(Map<String, dynamic> json) {
    return FollowUpModel(
      date: json["fechaRegistro"],
      user: json["usuario"],
      status: json["estado"],
      assignedAgent: json["agenteAsignado"],
    );
  }

  factory FollowUpModel.fromEntity(TechnicianFollowUp fu) {
    return FollowUpModel(
      date: fu.date,
      user: fu.user,
      status: fu.status,
      assignedAgent: fu.assignedAgent,
    );
  }
}