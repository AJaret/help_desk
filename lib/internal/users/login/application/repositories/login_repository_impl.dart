
import 'package:help_desk/internal/users/login/application/datasources/login_api_datasource.dart';
import 'package:help_desk/internal/users/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginApiDatasourceImp datasource;

  LoginRepositoryImpl({required this.datasource});

  @override
  Future<void> postLogin(String email, String password) async{
    try {
      return await datasource.postLogin(email, password);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<void> postResetPassword(String email, String employeeNumber) async{
    try {
      return await datasource.postResetPassword(email, employeeNumber);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
