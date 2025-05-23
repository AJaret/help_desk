import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/technical_assistance/login/presentation/screens/technicians_login_screen.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/assigned_agent.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/closed_service.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/blocs/service_requirements_bloc/service_requirements_bloc.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/screens/closed_service_screen.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/screens/service_form2_screen.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/screens/service_form_screen.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/screens/technician_service_details_screen.dart';
import 'package:help_desk/internal/users/login/presentation/screens/login_screen.dart';
import 'package:help_desk/internal/users/login/presentation/screens/reset_password_screen.dart';
import 'package:help_desk/internal/users/register/presentation/screen/register_screen.dart';
import 'package:help_desk/shared/helpers/app_dependencies.dart';
import 'package:help_desk/shared/services/token_service.dart';
import 'package:help_desk/shared/widgets/main_menu_widget.dart';
import 'package:help_desk/shared/widgets/tech_main_menu_widget.dart';

Future<RouterConfig<Object>> getInitialRoute(
    GlobalKey<NavigatorState> navigatorKey) async {
  return GoRouter(
    navigatorKey: navigatorKey,
    redirect: (context, state) async {
      final tokenService = TokenService();
      final longToken = await tokenService.getLongToken();
      final techLongToken = await tokenService.getTechnicianLongToken();

      const publicRoutes = ['/register', '/', '/resetPassword', '/techLogin'];
      if (longToken == null &&
          techLongToken == null &&
          !publicRoutes.contains(state.uri.path)) {
        return '/';
      }

      if (longToken != null && state.uri.path != '/main') {
        return '/main';
      }

      switch (state.uri.path) {
        case '/serviceDetails':
          return '/serviceDetails';
        case '/serviceForm':
          return '/serviceForm';
        case '/serviceSignature':
          return '/serviceSignature';
        case '/closedService':
          return '/closedService';
        default:
          break;
      }

      if (techLongToken != null && state.uri.path != '/mainTech') {
        return '/mainTech';
      }

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
          final args = state.extra as Map<String, dynamic>;
          final statusColor = args['statusColor'] as Color;
          final requestId = args['requestId'] as String;

          return TechnicianServiceDetailsScreen(
            statusColor: statusColor,
            requestId: requestId,
          );
        },
      ),
      GoRoute(
        path: '/serviceForm',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          final assignment = args['assignment'] as List<AssignedAgent>;
          final serviceData = args['serviceData'] as TechnicianService;
          final startDate = args['startDate'] as String;
          return BlocProvider(
            create: (context) => ServiceRequirementsBloc(AppDependencies.getServiceRequireSignatureAndSurveyUsecase, AppDependencies.postCloseServiceUsecase),
            child: ServiceFormScreen(
              assignments: assignment,
              serviceData: serviceData,
              startDate: startDate,
            ),
          );
        },
      ),
      GoRoute(
        path: '/serviceSignature',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          final serviceData = args['serviceData'] as TechnicianService;
          // final assignment = args['assignment'] as List<AssignedAgent>;
          final serviceRequirements = args['serviceRequirements'] as Map<String, dynamic>;
          final closedService = args['closedService'] as ClosedService;
          return ServiceForm2Screen(
            closedService: closedService,
            serviceRequirements: serviceRequirements,
            serviceData: serviceData,
          );
        },
      ),
      GoRoute(
        path: '/closedService',
        builder: (context, state) {
          final closedData = state.extra as ClosedService;
          return BlocProvider(
            create: (context) => ServiceRequirementsBloc(AppDependencies.getServiceRequireSignatureAndSurveyUsecase, AppDependencies.postCloseServiceUsecase),
            child: ClosedServiceScreen(
              closedServiceData: closedData,
            ),
          );
        },
      ),
    ],
  );
}
