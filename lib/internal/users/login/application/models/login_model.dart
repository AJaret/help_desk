
import 'package:help_desk/internal/users/login/domain/entities/session.dart';

class LoginModel extends Session {
  LoginModel({
    required super.accessToken,
    required super.refreshToken,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      accessToken: json["token"],
      refreshToken: json["refreshToken"],
    );
  }

  factory LoginModel.fromEntity(Session session) {
    return LoginModel(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
  }
}
