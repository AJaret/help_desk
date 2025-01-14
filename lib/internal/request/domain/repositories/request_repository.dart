import 'package:help_desk/internal/request/domain/entities/document.dart';
import 'package:help_desk/internal/request/domain/entities/request.dart';
import 'package:help_desk/internal/request/domain/entities/request_full.dart';

abstract class RequestRepository {
  Future<List<Request>> getRequests();
  Future<RequestFull> getRequestById(String requestId);
  Future<Document> getDocumentFile(int fileId);
  Future<bool> postNewRequest();
}