import 'package:help_desk/internal/request/domain/repositories/request_repository.dart';

class DeleteRequestUsecase {
  final RequestRepository requestRepo;

  DeleteRequestUsecase({required this.requestRepo});

  Future<void> execute({required String requestId}) async {
    try {
      return await requestRepo.deleteRequest(requestId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
