import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/login/presentation/screens/login_screen.dart';
import 'package:help_desk/internal/register/presentation/screen/register_screen.dart';
import 'package:help_desk/shared/services/token_service.dart';
import 'package:help_desk/shared/widgets/main_menu_widget.dart';


Future<RouterConfig<Object>> getInitialRoute(GlobalKey<NavigatorState> navigatorKey) async {
  return GoRouter(
    navigatorKey: navigatorKey,
    redirect: (context, state) async {
      final TokenService tokenService = TokenService();
      final longToken = await tokenService.getLongToken();
      const publicRoutes = ['/register', '/'];
      if (longToken == null && !publicRoutes.contains(state.uri.path)) {
        return '/';
      } else if (longToken != null && state.uri.path == '/') {
        return '/main';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state){
          return const LoginScreen();
        },
      ),
      
      GoRoute(
        path: '/register',
        builder: (context, state){
          return const RegisterScreen();
        },
      ),

      GoRoute(
        path: '/main',
        builder: (context, state){
          return const MainMenuWidget();
        },
      ),
    ]
  );
}