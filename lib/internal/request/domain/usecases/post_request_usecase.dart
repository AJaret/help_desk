import 'package:help_desk/internal/request/domain/entities/request.dart';
import 'package:help_desk/internal/request/domain/repositories/request_repository.dart';

class PostRequestUsecase {
  final RequestRepository requestRepo;

  PostRequestUsecase({required this.requestRepo});

  Future<List<Request>> execute() async {
    try {
      return await requestRepo.getRequests();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
