import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/catalog/application/datasources/catalog_api_datasource.dart';
import 'package:help_desk/internal/catalog/application/repositories/dependency_catalog_repository_impl.dart';
import 'package:help_desk/internal/catalog/domain/usecases/get_dependency_catalog_usecase.dart';
import 'package:help_desk/internal/catalog/presentation/blocs/catalog_bloc/catalog_bloc.dart';
import 'package:help_desk/internal/register/application/datasources/user_register_api_datasource.dart';
import 'package:help_desk/internal/register/application/repositories/user_register_repository_impl.dart';
import 'package:help_desk/internal/register/domain/usecases/post_user_usecase.dart';
import 'package:help_desk/internal/register/presentation/blocs/user_register_bloc/user_register_bloc.dart';
import 'package:help_desk/internal/register/presentation/widgets/register_form_widget.dart';
import 'package:help_desk/shared/helpers/app_dependencies.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    CatalogApiDatasourceImp dependencyDatasource = CatalogApiDatasourceImp();
    DependencyCatalogRepositoryImpl repoDependency = DependencyCatalogRepositoryImpl(datasource: dependencyDatasource);
    GetDependencyCatalogUseCase getDependency = GetDependencyCatalogUseCase(dependencycatalogRepo: repoDependency);

    UserRegisterApiDatasourceImp userRegisterDatasource = UserRegisterApiDatasourceImp();
    UserRepositoryRepositoryImpl repoUser = UserRepositoryRepositoryImpl(datasource: userRegisterDatasource);
    PostUserRegisterUseCase postUser = PostUserRegisterUseCase(userRegisterRepo: repoUser);

    return Scaffold(
      backgroundColor: const Color(0xFFA10046),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CatalogBloc(getDependencyCatalogUseCase: getDependency, getPhysicalLocationsCatalogUseCase: AppDependencies.getPhysicalLocations),
          ),
          BlocProvider(
            create: (context) => UserRegisterBloc(postUserRegisterUseCase: postUser),
          ),
        ],
        child: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  SizedBox(
                    width: size.width,
                    child: Stack(
                      children: [
                        GoRouter.of(context).canPop() ? Positioned(
                          left: 10,
                          top: size.height * 0.025,
                          child: IconButton(
                            onPressed: (){
                              GoRouter.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: size.height * 0.03,
                            )
                          ),
                        ) : Container(),
                        Center(
                          child: Image.asset(
                            'assets/images/logos/sello_logo.png',
                            fit: BoxFit.contain,
                            width: 100,
                          ),
                        ),
                      ]
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - 100,
                        ),
                        child: IntrinsicHeight(
                          child: Container(
                            padding: const EdgeInsets.all(30),
                            decoration: const BoxDecoration(
                              color: Color(0xFFD4CBC0),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(50),
                              ),
                            ),
                            child: MultiBlocListener(
                              listeners: [
                                BlocListener<CatalogBloc, CatalogState>(
                                  listener: (context, state) {
                                    if(state is ErrorGettingDependencyCatalog){
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CupertinoAlertDialog(
                                            title: const Text('Help desk'),
                                            content: Text(state.message),
                                            actions: [
                                              CupertinoDialogAction(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                                BlocListener<UserRegisterBloc, UserRegisterState>(
                                  listener: (context, state) {
                                    if(state is ErrorPostingUserRegister){
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CupertinoAlertDialog(
                                            title: const Text('Help desk'),
                                            content: Text(state.message),
                                            actions: [
                                              CupertinoDialogAction(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              ],
                              child: const RegisterFormWidget(),
                            ) 
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ) 
    );
  }
}