import 'package:help_desk/internal/technical_assistance/login/application/datasource/technicians_login_api_datasource.dart';
import 'package:help_desk/internal/technical_assistance/login/application/repositories/request_repository_impl.dart';
import 'package:help_desk/internal/technical_assistance/login/domain/usecases/post_technicians_login_usecase.dart';
import 'package:help_desk/internal/technical_assistance/services/application/datasource/technician_services_api_datasource.dart';
import 'package:help_desk/internal/technical_assistance/services/application/repositories/technician_services_repository_impl.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/usecases/get_document_by_id_usecase.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/usecases/get_technician_service_details_usecase.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/usecases/get_technician_services_usecase.dart';
import 'package:help_desk/internal/users/catalog/application/datasources/catalog_api_datasource.dart';
import 'package:help_desk/internal/users/catalog/application/repositories/dependency_catalog_repository_impl.dart';
import 'package:help_desk/internal/users/catalog/domain/usecases/get_dependency_catalog_usecase.dart';
import 'package:help_desk/internal/users/catalog/domain/usecases/get_locations_catalog_usecase.dart';
import 'package:help_desk/internal/users/login/application/datasources/login_api_datasource.dart';
import 'package:help_desk/internal/users/login/application/repositories/login_repository_impl.dart';
import 'package:help_desk/internal/users/login/domain/usecases/post_login_usecase.dart';
import 'package:help_desk/internal/users/login/domain/usecases/post_reset_password_usecase.dart';
import 'package:help_desk/internal/users/register/application/datasources/user_register_api_datasource.dart';
import 'package:help_desk/internal/users/register/application/repositories/user_register_repository_impl.dart';
import 'package:help_desk/internal/users/register/domain/usecases/post_user_usecase.dart';
import 'package:help_desk/internal/users/request/application/datasource/request_api_datasource.dart';
import 'package:help_desk/internal/users/request/application/repositories/request_repository_impl.dart';
import 'package:help_desk/internal/users/request/domain/usecases/delete_request_usecase.dart';
import 'package:help_desk/internal/users/request/domain/usecases/get_document_file_usecase.dart';
import 'package:help_desk/internal/users/request/domain/usecases/get_request_by_id_usecase.dart';
import 'package:help_desk/internal/users/request/domain/usecases/post_new_request_usecase.dart';
import 'package:help_desk/internal/users/request/domain/usecases/post_request_usecase.dart';

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
  static final PostResetPasswordUseCase postResetPasswordUseCase = PostResetPasswordUseCase(userLoginRepo: userLoginRepo);
  
  static final RequestApiDatasourceImp requestDatasource = RequestApiDatasourceImp();
  static final RequestRepositoryImpl requestRepo = RequestRepositoryImpl(datasource: requestDatasource);
  static final PostRequestUsecase postRequestUseCase = PostRequestUsecase(requestRepo: requestRepo);
  static final GetRequestByIdUsecase getRequestById = GetRequestByIdUsecase(requestRepo: requestRepo);
  static final GetDocumentFileUsecase getDocumentFile = GetDocumentFileUsecase(requestRepo: requestRepo);
  static final PostNewRequestUsecase postNewRequest = PostNewRequestUsecase(requestRepo: requestRepo);
  static final DeleteRequestUsecase deleteRequestUsecase = DeleteRequestUsecase(requestRepo: requestRepo);

  static final TechniciansLoginApiDatasource techLoginDatasource = TechniciansLoginApiDatasource();
  static final TechniciansLoginRepositoryImpl techLogin = TechniciansLoginRepositoryImpl(datasource: techLoginDatasource);
  static final PostTechniciansLoginUsecase postTechniciansLoginUseCase = PostTechniciansLoginUsecase(techniciansLoginRepository: techLogin);

  static final TechnicianServicesApiDatasource technicianServicesApiDatasource = TechnicianServicesApiDatasource();
  static final TechnicianServicesRepositoryImpl technicianServicesRepositoryImpl = TechnicianServicesRepositoryImpl(datasource: technicianServicesApiDatasource);
  static final GetTechnicianServicesUsecase getTechnicianServicesUsecase = GetTechnicianServicesUsecase(technicianServicesRepository: technicianServicesRepositoryImpl);
  static final GetTechnicianServiceDetailsUsecase getTechnicianServiceDetailsUsecase = GetTechnicianServiceDetailsUsecase(technicianServicesRepository: technicianServicesRepositoryImpl);
  static final GetDocumentByIdUsecase getDocumentByIdUsecase = GetDocumentByIdUsecase(techRepo: technicianServicesApiDatasource);
}