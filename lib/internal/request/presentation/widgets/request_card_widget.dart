import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/request/domain/entities/request.dart';
import 'package:help_desk/internal/request/presentation/blocs/request_details_bloc/request_details_bloc.dart';
import 'package:help_desk/internal/request/presentation/widgets/request_details_widget.dart';
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

    Map<String, dynamic> statusInfo = getStatusInformation(request.status ?? 'Solicitud registrada');

    statusColor = statusInfo['statusColor'];
    statusIcon = statusInfo['statusIcon'];
    statusDesc = statusInfo['statusDesc'];
    textColor = statusInfo['textColor'];
    return Padding(
      padding: const EdgeInsets.all(6.0),
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
                  create: (context) => RequestDetailsBloc(AppDependencies.getRequestById),
                  child: BlocListener<RequestDetailsBloc, RequestDetailsState>(
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
          padding: const EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Icon(
                  statusIcon,
                  color: textColor
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        'Dirección: ${request.dependency}',
                        style: TextStyle(
                          color: textColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
