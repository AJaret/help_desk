
import 'package:help_desk/internal/login/domain/entities/user_login.dart';

class LoginModel extends Session {
  LoginModel({
    required super.accessToken,
    required super.refreshToken,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      accessToken: json["value"],
      refreshToken: json["label"],
    );
  }

  factory LoginModel.fromEntity(Session session) {
    return LoginModel(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
  }
}
