import 'package:help_desk/internal/technical_assistance/login/domain/repositories/technicians_login_repository.dart';

class PostTechniciansLoginUsecase {
  final TechniciansLoginRepository techniciansLoginRepository;

  PostTechniciansLoginUsecase({required this.techniciansLoginRepository});

  Future<void> execute({required String email, required String password}) async {
    try {
      return await techniciansLoginRepository.postTechniciansLogin(email, password);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
