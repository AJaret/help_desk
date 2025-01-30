import 'package:help_desk/internal/technical_assistance/login/application/datasource/technicians_login_api_datasource.dart';
import 'package:help_desk/internal/technical_assistance/login/domain/repositories/technicians_login_repository.dart';

class TechniciansLoginRepositoryImpl implements TechniciansLoginRepository {
  final TechniciansLoginApiDatasource datasource;

  TechniciansLoginRepositoryImpl({required this.datasource});
  
  @override
  Future<void> postTechniciansLogin(String email, String password) async{
    try {
      return await datasource.postTechniciansLogin(email, password);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
