import 'package:help_desk/internal/catalog/application/datasources/catalog_api_datasource.dart';
import 'package:help_desk/internal/catalog/application/repositories/dependency_catalog_repository_impl.dart';
import 'package:help_desk/internal/catalog/domain/usecases/get_dependency_catalog_usecase.dart';
import 'package:help_desk/internal/catalog/domain/usecases/get_locations_catalog_usecase.dart';
import 'package:help_desk/internal/login/application/datasources/login_api_datasource.dart';
import 'package:help_desk/internal/login/application/repositories/login_repository_impl.dart';
import 'package:help_desk/internal/login/domain/usecases/post_login_usecase.dart';
import 'package:help_desk/internal/register/application/datasources/user_register_api_datasource.dart';
import 'package:help_desk/internal/register/application/repositories/user_register_repository_impl.dart';
import 'package:help_desk/internal/register/domain/usecases/post_user_usecase.dart';
import 'package:help_desk/internal/request/application/datasource/request_api_datasource.dart';
import 'package:help_desk/internal/request/application/repositories/request_repository_impl.dart';
import 'package:help_desk/internal/request/domain/usecases/get_document_file_usecase.dart';
import 'package:help_desk/internal/request/domain/usecases/get_request_by_id_usecase.dart';
import 'package:help_desk/internal/request/domain/usecases/post_request_usecase.dart';

class AppDependencies {
  static final CatalogApiDatasourceImp dependencyDatasource = CatalogApiDatasourceImp();
  static final DependencyCatalogRepositoryImpl repoDependency = DependencyCatalogRepositoryImpl(datasource: dependencyDatasource);
  static final GetDependencyCatalogUseCase getDependency = GetDependencyCatalogUseCase(dependencycatalogRepo: repoDependency);
  static final GetPhysicalLocationsCatalogUseCase getPhysicalLocations = GetPhysicalLocationsCatalogUseCase(dependencycatalogRepo: repoDependency);

  static final UserRegisterApiDatasourceImp userRegisterDatasource = UserRegisterApiDatasourceImp();
  static final UserRepositoryRepositoryImpl repoUser = UserRepositoryRepositoryImpl(datasource: userRegisterDatasource);
  static final PostUserRegisterUseCase postUser = PostUserRegisterUseCase(userRegisterRepo: repoUser);

  static final LoginApiDatasourceImp loginDatasource = LoginApiDatasourceImp();
  static final LoginRepositoryImpl userLoginRepo = LoginRepositoryImpl(datasource: loginDatasource);
  static final PostLoginUseCase postLoginUseCase = PostLoginUseCase(userLoginRepo: userLoginRepo);
  
  static final RequestApiDatasourceImp requestDatasource = RequestApiDatasourceImp();
  static final RequestRepositoryImpl requestRepo = RequestRepositoryImpl(datasource: requestDatasource);
  static final PostRequestUsecase postRequestUseCase = PostRequestUsecase(requestRepo: requestRepo);
  static final GetRequestByIdUsecase getRequestById = GetRequestByIdUsecase(requestRepo: requestRepo);
  static final GetDocumentFileUsecase getDocumentFile = GetDocumentFileUsecase(requestRepo: requestRepo);
  
}