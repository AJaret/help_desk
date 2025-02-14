import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/config/router/app_router.dart';
import 'package:help_desk/config/theme/app_theme.dart';
import 'package:help_desk/internal/users/catalog/presentation/blocs/catalog_bloc/catalog_bloc.dart';
import 'package:help_desk/internal/users/login/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:help_desk/internal/users/request/presentation/blocs/delete_request_bloc/delete_request_bloc.dart';
import 'package:help_desk/internal/users/request/presentation/blocs/request_bloc/request_bloc.dart';
import 'package:help_desk/internal/users/request/presentation/blocs/request_details_bloc/request_details_bloc.dart';
import 'package:help_desk/shared/helpers/app_dependencies.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final initialRouterConfig = await getInitialRoute(navigatorKey);

  runApp(MyApp(
    initialRouterConfig: initialRouterConfig,
  ));
}

class MyApp extends StatelessWidget {
  final RouterConfig<Object>? initialRouterConfig;

  const MyApp({
    super.key,
    required this.initialRouterConfig,
  });

  @override
  Widget build(BuildContext context) {
    final loginBloc = LoginBloc(AppDependencies.postLoginUseCase,
        AppDependencies.postResetPasswordUseCase);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => loginBloc),
        BlocProvider(create: (context) => RequestBloc(AppDependencies.postRequestUseCase, AppDependencies.postNewRequest)),
        BlocProvider(create: (context) => DeleteRequestBloc(AppDependencies.deleteRequestUsecase)),
        BlocProvider(create: (context) => CatalogBloc(getDependencyCatalogUseCase: AppDependencies.getDependency, getPhysicalLocationsCatalogUseCase: AppDependencies.getPhysicalLocations,)),
        BlocProvider(create: (context) => RequestDetailsBloc(AppDependencies.getRequestById, AppDependencies.getDocumentFile),),
      ],
      child: MaterialApp.router(
        theme: AppTheme().theme(),
        debugShowCheckedModeBanner: false,
        routerConfig: initialRouterConfig,
      ),
    );
  }
}
