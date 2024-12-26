import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_desk/config/router/app_router.dart';
import 'package:help_desk/config/theme/app_theme.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final initialRouterConfig = await getInitialRoute(navigatorKey);
  runApp(MyApp(initialRouterConfig: initialRouterConfig,));
}

class MyApp extends StatelessWidget {
  final RouterConfig<Object>? initialRouterConfig;
  const MyApp({super.key, required this.initialRouterConfig});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp.router(
      theme: AppTheme().theme(),
      routerConfig: initialRouterConfig,
    );
  }
}
