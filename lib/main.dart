import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/config/router/app_router.dart';
import 'package:help_desk/config/theme/app_theme.dart';
import 'package:help_desk/internal/login/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:help_desk/shared/helpers/app_dependencies.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final loginBloc = LoginBloc(AppDependencies.postLoginUseCase, AppDependencies.postResetPasswordUseCase);

  final initialRouterConfig = await getInitialRoute(navigatorKey, loginBloc);

  runApp(MyApp(
    initialRouterConfig: initialRouterConfig,
    loginBloc: loginBloc,
  ));
}

class MyApp extends StatelessWidget {
  final RouterConfig<Object>? initialRouterConfig;
  final LoginBloc loginBloc;

  const MyApp({
    super.key,
    required this.initialRouterConfig,
    required this.loginBloc,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return BlocProvider(
      create: (_) => loginBloc,
      child: MaterialApp.router(
        theme: AppTheme().theme(),
        routerConfig: initialRouterConfig,
      ),
    );
  }
}
