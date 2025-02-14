import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/users/request/domain/entities/request.dart';
import 'package:help_desk/internal/users/request/presentation/blocs/delete_request_bloc/delete_request_bloc.dart';
import 'package:help_desk/internal/users/request/presentation/widgets/request_details_widget.dart';
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
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet<String>(
                context: context,
                isDismissible: true,
                isScrollControlled: true,
                builder: (context) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    width: MediaQuery.of(context).size.width,
                    child: RequestDetailsWidget(
                      statusColor: statusColor ?? Colors.white,
                      requestId: request.requestToken ?? '',
                    ),
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
          
          if (statusDesc == 'Solicitud registrada')
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  final deleteRequestBloc = context.read<DeleteRequestBloc>();
                  showCupertinoDialog(
                    context: context,
                    builder: (dialogContext) {
                      return CupertinoAlertDialog(
                        title: const Text('Cancelar la solicitud'),
                        content: const Text('¿Desea cancelar esta solicitud?'),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () => GoRouter.of(context).pop(),
                            child: const Text('Cancelar'),
                          ),
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () {
                              deleteRequestBloc.add(DeleteRequest(requestId: request.requestToken ?? '0'));
                            },
                            child: const Text('Si'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
