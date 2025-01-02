import 'package:help_desk/internal/login/application/datasources/login_api_datasource.dart';
import 'package:help_desk/internal/login/application/repositories/login_repository_impl.dart';
import 'package:help_desk/internal/login/domain/usecases/post_login_usecase.dart';
import 'package:help_desk/internal/request/application/datasource/request_api_datasource.dart';
import 'package:help_desk/internal/request/application/repositories/request_repository_impl.dart';
import 'package:help_desk/internal/request/domain/usecases/get_request_usecase.dart';

class AppDependencies {
  static final LoginApiDatasourceImp loginDatasource = LoginApiDatasourceImp();
  static final LoginRepositoryImpl userLoginRepo = LoginRepositoryImpl(datasource: loginDatasource);
  static final PostLoginUseCase postLoginUseCase = PostLoginUseCase(userLoginRepo: userLoginRepo);
  
  static final RequestApiDatasourceImp requestDatasource = RequestApiDatasourceImp();
  static final RequestRepositoryImpl requestRepo = RequestRepositoryImpl(datasource: requestDatasource);
  static final PostRequestUsecase postRequestUseCase = PostRequestUsecase(requestRepo: requestRepo);
  
}