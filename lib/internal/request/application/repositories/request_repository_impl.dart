import 'package:help_desk/internal/request/application/datasource/request_api_datasource.dart';
import 'package:help_desk/internal/request/domain/entities/request.dart';
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
}
