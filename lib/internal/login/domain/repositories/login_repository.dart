

abstract class LoginRepository {
  Future<void> postLogin(String email, String password);
  Future<void> postResetPassword(String email, String employeeNumber);
}