import 'package:help_desk/internal/users/login/domain/repositories/login_repository.dart';

class PostLoginUseCase {
  final LoginRepository userLoginRepo;

  PostLoginUseCase({required this.userLoginRepo});

  Future<void> execute({required String email, required String password}) async {
    try {
      return await userLoginRepo.postLogin(email, password);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
