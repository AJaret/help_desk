import 'package:help_desk/internal/users/request/domain/entities/request_full.dart';
import 'package:help_desk/internal/users/request/domain/repositories/request_repository.dart';

class GetRequestByIdUsecase {
  final RequestRepository requestRepo;

  GetRequestByIdUsecase({required this.requestRepo});

  Future<RequestFull> execute({required String requestId}) async {
    try {
      return await requestRepo.getRequestById(requestId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
