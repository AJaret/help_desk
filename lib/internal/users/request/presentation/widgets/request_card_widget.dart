import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/users/request/domain/entities/request.dart';
import 'package:help_desk/internal/users/request/presentation/blocs/request_bloc/request_bloc.dart';
import 'package:help_desk/internal/users/request/presentation/blocs/request_details_bloc/request_details_bloc.dart';
import 'package:help_desk/internal/users/request/presentation/widgets/request_details_widget.dart';
import 'package:help_desk/shared/helpers/app_dependencies.dart';
import 'package:help_desk/shared/helpers/status_information.dart';

class RequestCardWidget extends StatelessWidget {
  final Request request;

  const RequestCardWidget({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    Color? statusColor;
    Color? textColor;
    IconData? statusIcon;
    String? statusDesc;

    Map<String, dynamic> statusInfo = getStatusInformation(request.status ?? 'Solicitud cancelada');

    statusColor = statusInfo['statusColor'];
    statusIcon = statusInfo['statusIcon'];
    statusDesc = statusInfo['statusDesc'];
    textColor = statusInfo['textColor'];

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet<String>(
                    context: context,
                    isDismissible: true,
                    isScrollControlled: true,
                    builder: (context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.9,
                        width: MediaQuery.of(context).size.width,
                        child: BlocProvider(
                          create: (context) => RequestDetailsBloc(AppDependencies.getRequestById, AppDependencies.getDocumentFile),
                          child: BlocListener<RequestDetailsBloc,RequestDetailsState>(
                            listener: (context, state) {
                              if (state is ErrorGettingRequestDetails) {
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
                            child: RequestDetailsWidget(
                              statusColor: statusColor ?? Colors.white,
                              requestId: request.requestToken ?? '',
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: statusDesc == 'Solicitud registrada'? const BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)) : BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        Icon(
                          statusIcon,
                          color: textColor,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Estatus: $statusDesc',
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Folio: ${request.requestId}',
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Dirección: ${request.dependency}',
                                style: TextStyle(
                                  color: textColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (statusDesc == 'Solicitud registrada')
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                color: Colors.red,
                height: 69,
                child: GestureDetector(
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: const Text('Cancelar la solicitud'),
                        content: const Center(
                          child: Text('¿Desea cancelar esta solicitud?'),
                        ),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () => GoRouter.of(context).pop(),
                            child: const Text('Cancelar'),
                          ),
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () => context.read<RequestBloc>().add(GetRequests()),
                            child: const Text('Si'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
