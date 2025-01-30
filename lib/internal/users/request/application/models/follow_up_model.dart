import 'package:help_desk/internal/users/request/domain/entities/follow_up.dart';

class FollowUpModel extends FollowUp {
  FollowUpModel({
    super.registrationDate,
    super.observations,
    super.email,
    super.status
  });

  factory FollowUpModel.fromJson(Map<String, dynamic> json) {
    return FollowUpModel(
      registrationDate: json["fechaRegistro"],
      observations: json["observaciones"],
      email: json["correo"],
      status: json["estado"]
    );
  }

  factory FollowUpModel.fromEntity(FollowUp fu) {
    return FollowUpModel(
      registrationDate: fu.registrationDate,
      observations: fu.observations,
      email: fu.email,
      status: fu.status
    );
  }
}