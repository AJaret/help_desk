import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/blocs/technician_services_bloc/technician_services_bloc.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/widgets/technician_services_search_widget.dart';
import 'package:help_desk/shared/helpers/app_dependencies.dart';

class TechnicianServicesHistoryScreen extends StatefulWidget {
  const TechnicianServicesHistoryScreen({super.key});

  @override
  State<TechnicianServicesHistoryScreen> createState() => _TechnicianServicesHistoryScreenState();
}

class _TechnicianServicesHistoryScreenState extends State<TechnicianServicesHistoryScreen> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'HISTORIAL DE SERVICIOS',
          style: TextStyle(
            color: const Color(0xFF2C2927),
            fontSize: size.width * 0.06,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          child: SizedBox(
            height: size.height * 0.62,
            child: BlocProvider(
              create: (context) => TechnicianServicesBloc(AppDependencies.getTechnicianServicesUsecase, AppDependencies.getTechnicianServiceDetailsUsecase, AppDependencies.getDocumentByIdUsecase),
              child: BlocListener<TechnicianServicesBloc, TechnicianServicesState>(
                listener: (context, state) {
                  if(state is ErrorGettingTechnicianServices){
                    GoRouter.of(context).canPop() ? GoRouter.of(context).pop() : null;
                    showCupertinoDialog(
                      context: context, 
                      builder: (context) => CupertinoAlertDialog(
                      title: const Text('Error'),
                        content: Center(
                          child: Text(state.message),
                        ),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () => GoRouter.of(context).pop(), 
                            child: const Text('Aceptar'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const TechnicianServicesSearchWidget(requestType: 'Finished',),
              ),
            )
          ),
        ),
      ],
    );
  }
}