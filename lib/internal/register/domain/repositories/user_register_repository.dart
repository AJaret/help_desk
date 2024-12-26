import 'package:help_desk/internal/register/domain/entities/user_register.dart';

abstract class UserRegisterRepository {
  Future<bool> postUser({required UserRegister userData});
}
