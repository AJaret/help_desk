import 'package:flutter/material.dart';

Map<String, dynamic> getStatusInformation(String status){
  Color? statusColor;
  Color? textColor;
  IconData? statusIcon;
  String? statusDesc;

  switch (status) {
    case 'Solicitud registrada' || 'Servicio registrado':
      statusColor = const Color(0XFF0DCAF0);
      textColor = Colors.black;
      statusIcon = Icons.add_circle_outline;
      statusDesc = status;
      break;
    case 'Solicitud validada' || 'Servicio validado':
      statusColor = const Color(0XFF0D6EFD);
      textColor = Colors.white;
      statusIcon = Icons.verified;
      statusDesc = status;
      break;
    case 'Solicitud asignada' || 'Servicio asignado':
      statusColor = const Color(0XFF212529);
      textColor = Colors.white;
      statusIcon = Icons.assignment_ind;
      statusDesc = status;
      break;
    case 'Solicitud en proceso' || 'Servicio en proceso':
      statusColor = const Color(0XFFFFC107);
      textColor = Colors.black;
      statusIcon = Icons.hourglass_bottom;
      statusDesc = status;
      break;
    case 'Solicitud finalizada' || 'Servicio finalizado':
      statusColor = const Color(0xFFCCBDC9);
      textColor = Colors.black;
      statusIcon = Icons.task_alt;
      statusDesc = status;
      break;
    case 'Solicitud cerrada' || 'Servicio cerrado':
      statusColor = Colors.green;
      textColor = Colors.black;
      statusIcon = Icons.done_all;
      statusDesc = status;
      break;
    case 'Solicitud cancelada':
      statusColor = Colors.red;
      textColor = Colors.white;
      statusIcon = Icons.cancel;
      statusDesc = 'Solicitud cancelada';
    default: 
      statusColor = const Color(0XFF0DCAF0);
      textColor = Colors.black;
      statusIcon = Icons.question_mark;
      statusDesc = 'No status';
  }

  return {
    'statusColor': statusColor,
    'statusIcon': statusIcon,
    'statusDesc': statusDesc,
    'textColor': textColor
  };
}