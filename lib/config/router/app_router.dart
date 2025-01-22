import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/login/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:help_desk/internal/login/presentation/screens/login_screen.dart';
import 'package:help_desk/internal/login/presentation/screens/reset_password.dart';
import 'package:help_desk/internal/register/presentation/screen/register_screen.dart';
import 'package:help_desk/shared/services/token_service.dart';
import 'package:help_desk/shared/widgets/main_menu_widget.dart';


Future<RouterConfig<Object>> getInitialRoute(GlobalKey<NavigatorState> navigatorKey, LoginBloc loginBloc) async {
  return GoRouter(
    navigatorKey: navigatorKey,
    redirect: (context, state) async {
      final authState = loginBloc.state;
      final tokenService = TokenService();
      final longToken = await tokenService.getLongToken();
      const publicRoutes = ['/register', '/', 'resetPassword'];


      if (longToken != null && state.uri.path == '/') {
        return '/main';
      }
      if (authState is Unauthenticated && !publicRoutes.contains(state.uri.path)) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainMenuWidget(),
      ),
      GoRoute(
        path: '/resetPassword',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
    ],
  );
}
