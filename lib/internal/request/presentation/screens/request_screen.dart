import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/request/presentation/blocs/request_bloc/request_bloc.dart';
import 'package:help_desk/internal/request/presentation/widgets/request_search_widget.dart';
import 'package:help_desk/shared/helpers/app_dependencies.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'SOLICITUDES PENDIENTES',
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
              create: (context) => RequestBloc(AppDependencies.postRequestUseCase, AppDependencies.postNewRequest),
              child: BlocListener<RequestBloc, RequestState>(
                listener: (context, state) {
                  BlocListener<RequestBloc, RequestState>(
                    listener: (context, state) {
                      if (state is ErrorGettingRequests) {
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
                  );
                },
                child: const RequestSearchWidget(requestType: 'All'),
              ),
            ),
          )
        ),
      ],
    );
  }
}