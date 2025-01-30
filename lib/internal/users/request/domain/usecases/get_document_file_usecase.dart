import 'package:help_desk/internal/users/request/domain/entities/document.dart';
import 'package:help_desk/internal/users/request/domain/repositories/request_repository.dart';

class GetDocumentFileUsecase {
  final RequestRepository requestRepo;

  GetDocumentFileUsecase({required this.requestRepo});

  Future<Document> execute({required int documentId}) async {
    try {
      return await requestRepo.getDocumentFile(documentId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
