import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';
import 'package:help_desk/internal/users/request/presentation/blocs/request_bloc/request_bloc.dart';
import 'package:help_desk/shared/helpers/status_information.dart';

class TechnicianServiceCardWidget extends StatelessWidget {
  final TechnicianService request;

  const TechnicianServiceCardWidget({
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
                  context.push('/serviceDetails', extra: {
                    'statusColor': statusColor ?? Colors.white,
                    'requestId': request.idServicio ?? 0,
                  });
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
                                'Folio: ${request.requestFolio}',
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
