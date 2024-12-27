import 'package:help_desk/internal/login/application/datasources/login_api_datasource.dart';
import 'package:help_desk/internal/login/application/repositories/login_repository_impl.dart';
import 'package:help_desk/internal/login/domain/usecases/post_login_usecase.dart';

class AppDependencies {
  static final LoginApiDatasourceImp loginDatasource = LoginApiDatasourceImp();
  static final LoginRepositoryImpl userLoginRepo = LoginRepositoryImpl(datasource: loginDatasource);
  static final PostLoginUseCase postLoginUseCase = PostLoginUseCase(userLoginRepo: userLoginRepo);
}