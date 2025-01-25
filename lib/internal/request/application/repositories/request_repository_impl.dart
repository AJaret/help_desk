import 'package:help_desk/internal/request/application/datasource/request_api_datasource.dart';
import 'package:help_desk/internal/request/domain/entities/document.dart';
import 'package:help_desk/internal/request/domain/entities/new_request.dart';
import 'package:help_desk/internal/request/domain/entities/request.dart';
import 'package:help_desk/internal/request/domain/entities/request_full.dart';
import 'package:help_desk/internal/request/domain/repositories/request_repository.dart';

class RequestRepositoryImpl implements RequestRepository {
  final RequestApiDatasourceImp datasource;

  RequestRepositoryImpl({required this.datasource});

  @override
  Future<List<Request>> getRequests() async{
    try {
      return await datasource.getRequests();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<RequestFull> getRequestById(String requestId) async{
    try {
      return await datasource.getRequestById(requestId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Document> getDocumentFile(int fileId) async{
    try {
      return await datasource.getDocumentFile(fileId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<String> postNewRequest(NewRequest requestData) async{
    try {
      return await datasource.postNewRequest(requestData);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<void> deleteRequest(String requestId) async{
    try {
      return await datasource.deleteRequest(requestId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
