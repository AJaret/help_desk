import 'package:help_desk/internal/technical_assistance/services/domain/repositories/technician_services_repository.dart';
import 'package:help_desk/internal/users/request/domain/entities/document.dart';

class GetDocumentByIdUsecase {
  final TechnicianServicesRepository techRepo;

  GetDocumentByIdUsecase({required this.techRepo});

  Future<Document> execute({required int documentId}) async {
    try {
      return await techRepo.getDocumentById(documentId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
