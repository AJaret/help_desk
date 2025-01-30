import 'package:help_desk/internal/users/register/domain/entities/user_register.dart';
import 'package:help_desk/internal/users/register/domain/repositories/user_register_repository.dart';

class PostUserRegisterUseCase {
  final UserRegisterRepository userRegisterRepo;

  PostUserRegisterUseCase({required this.userRegisterRepo});

  Future<bool> execute({required UserRegister userData}) async {
    try {
      return await userRegisterRepo.postUser(userData: userData);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
