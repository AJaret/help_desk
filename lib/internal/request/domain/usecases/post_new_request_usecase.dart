import 'package:help_desk/internal/request/domain/repositories/request_repository.dart';

class PostNewRequestUsecase {
  final RequestRepository requestRepo;

  PostNewRequestUsecase({required this.requestRepo});

  Future<bool> execute() async {
    try {
      return await requestRepo.postNewRequest();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
