import 'package:help_desk/internal/register/application/datasources/user_register_api_datasource.dart';
import 'package:help_desk/internal/register/domain/entities/user_register.dart';
import 'package:help_desk/internal/register/domain/repositories/user_register_repository.dart';

class UserRepositoryRepositoryImpl implements UserRegisterRepository {
  final UserRegisterApiDatasourceImp datasource;

  UserRepositoryRepositoryImpl({required this.datasource});
  
  @override
  Future<bool> postUser({required UserRegister userData}) async{
    try {
      return await datasource.postUser(userData: userData);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
