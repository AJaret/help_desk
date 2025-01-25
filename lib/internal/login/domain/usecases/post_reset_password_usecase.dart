import 'package:help_desk/internal/login/domain/repositories/login_repository.dart';

class PostResetPasswordUseCase {
  final LoginRepository userLoginRepo;

  PostResetPasswordUseCase({required this.userLoginRepo});

  Future<void> execute({required String email, required String employeeNumber}) async {
    try {
      return await userLoginRepo.postResetPassword(email, employeeNumber);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
