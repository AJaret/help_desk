

abstract class LoginRepository {
  Future<void> postLogin(String email, String password);
  // Future<Session> postRefreshToken(String refreshToken);
}