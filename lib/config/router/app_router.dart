import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/technical_assistance/login/presentation/screens/technicians_login_screen.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/screens/technician_service_details_screen.dart';
import 'package:help_desk/internal/users/login/presentation/screens/login_screen.dart';
import 'package:help_desk/internal/users/login/presentation/screens/reset_password_screen.dart';
import 'package:help_desk/internal/users/register/presentation/screen/register_screen.dart';
import 'package:help_desk/shared/services/token_service.dart';
import 'package:help_desk/shared/widgets/main_menu_widget.dart';
import 'package:help_desk/shared/widgets/tech_main_menu_widget.dart';


Future<RouterConfig<Object>> getInitialRoute(GlobalKey<NavigatorState> navigatorKey) async {
  return GoRouter(
    navigatorKey: navigatorKey,
    redirect: (context, state) async {
      final tokenService = TokenService();
      final longToken = await tokenService.getLongToken();
      final techLongToken = await tokenService.getTechnicianLongToken();

      const publicRoutes = ['/register', '/', '/resetPassword', '/techLogin'];

      // Si no hay tokens (ni normal ni de technician) y la ruta actual no es pública,
      // redirige al login.
      if (longToken == null && techLongToken == null && !publicRoutes.contains(state.uri.path)) {
        return '/';
      }

      // Si se tiene token normal y no estamos en /main, redirige a /main.
      if (longToken != null && state.uri.path != '/main') {
        return '/main';
      }

      if(state.uri.path == '/serviceDetails'){
        return '/serviceDetails';
      }

      // Si se tiene token de technician y no estamos en /mainTech, redirige a /mainTech.
      if (techLongToken != null && state.uri.path != '/mainTech') {
        return '/mainTech';
      }

      // En cualquier otro caso, no se hace redirección.
      return null;
    },
    routes: [
      // Rutas públicas
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
      
      // Rutas para usuario normal
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainMenuWidget(),
      ),
      
      // Rutas para technician
      GoRoute(
        path: '/mainTech',
        builder: (context, state) => const TechMainMenuWidget(),
      ),
      GoRoute(
        path: '/serviceDetails',
        builder: (context, state) {
          // Se espera que 'extra' sea un Map con los parámetros.
          final args = state.extra as Map<String, dynamic>;
          final statusColor = args['statusColor'] as Color;
          final requestId = args['requestId'] as int;

          return TechnicianServiceDetailsScreen(
            statusColor: statusColor,
            requestId: requestId,
          );
        },
      ),
    ],
  );
}
