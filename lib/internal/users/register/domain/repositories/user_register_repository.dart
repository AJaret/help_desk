import 'package:help_desk/internal/users/register/domain/entities/user_register.dart';

abstract class UserRegisterRepository {
  Future<bool> postUser({required UserRegister userData});
}
