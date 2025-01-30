import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/technical_assistance/login/presentation/screens/technicians_login_screen.dart';
import 'package:help_desk/internal/users/login/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:help_desk/internal/users/login/presentation/screens/login_screen.dart';
import 'package:help_desk/internal/users/login/presentation/screens/reset_password_screen.dart';
import 'package:help_desk/internal/users/register/presentation/screen/register_screen.dart';
import 'package:help_desk/shared/services/token_service.dart';
import 'package:help_desk/shared/widgets/main_menu_widget.dart';
import 'package:help_desk/shared/widgets/tech_main_menu_widget.dart';


Future<RouterConfig<Object>> getInitialRoute(GlobalKey<NavigatorState> navigatorKey, LoginBloc loginBloc) async {
  return GoRouter(
    navigatorKey: navigatorKey,
    redirect: (context, state) async {
      final authState = loginBloc.state;
      final tokenService = TokenService();
      final longToken = await tokenService.getLongToken();
      final techLongToken = await tokenService.getTechnicianLongToken();

      const publicRoutes = ['/register', '/', '/resetPassword', '/techLogin'];
      const normalRoutes = ['/main'];
      const techRoutes = ['/mainTech'];

      if ((longToken != null || techLongToken != null) && state.uri.path == '/') {
        if (longToken != null) {
          return '/main';
        } else if (techLongToken != null) {
          return '/mainTech';
        }
      }

      if (authState is Unauthenticated && !publicRoutes.contains(state.uri.path)) {
        return '/';
      }

      if (longToken == null && normalRoutes.contains(state.uri.path)) {
        return '/';
      }

      if (techLongToken == null && techRoutes.contains(state.uri.path)) {
        return '/';
      }

      return null;
    },
    routes: [
      // Public Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/resetPassword',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/techLogin',
        builder: (context, state) => const TechniciansLoginScreen(),
      ),
      
      // Normal User Routes
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainMenuWidget(),
      ),
      
      // Tech User Routes
      GoRoute(
        path: '/mainTech',
        builder: (context, state) => const TechMainMenuWidget(),
      ),
    ],
  );
}