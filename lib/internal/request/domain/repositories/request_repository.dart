import 'package:help_desk/internal/request/domain/entities/document.dart';
import 'package:help_desk/internal/request/domain/entities/new_request.dart';
import 'package:help_desk/internal/request/domain/entities/request.dart';
import 'package:help_desk/internal/request/domain/entities/request_full.dart';

abstract class RequestRepository {
  Future<List<Request>> getRequests();
  Future<RequestFull> getRequestById(String requestId);
  Future<Document> getDocumentFile(int fileId);
  Future<String> postNewRequest(NewRequest requestData);
  Future<void> deleteRequest(String requestId);
}