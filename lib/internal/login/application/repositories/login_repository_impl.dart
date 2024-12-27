
import 'package:help_desk/internal/login/application/datasources/login_api_datasource.dart';
import 'package:help_desk/internal/login/domain/repositories/login_repository.dart';

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

  // @override
  // Future<Session> postRefreshToken(String refreshToken) async{
  //   try {
  //     return await datasource.postRefreshToken(refreshToken);
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }
}
