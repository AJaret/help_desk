import 'package:help_desk/internal/login/domain/entities/user_login.dart';

abstract class LoginRepository {
  Future<Session> postLogin(String email, String password);
  Future<Session> postRefreshToken(String refreshToken);
}