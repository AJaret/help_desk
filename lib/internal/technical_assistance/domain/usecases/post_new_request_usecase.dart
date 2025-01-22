import 'package:help_desk/internal/request/domain/entities/new_request.dart';
import 'package:help_desk/internal/request/domain/repositories/request_repository.dart';

class PostNewRequestUsecase {
  final RequestRepository requestRepo;

  PostNewRequestUsecase({required this.requestRepo});

  Future<String> execute({required NewRequest requestData}) async {
    try {
      return await requestRepo.postNewRequest(requestData);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
