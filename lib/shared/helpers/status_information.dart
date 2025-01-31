import 'package:flutter/material.dart';

Map<String, dynamic> getStatusInformation(String status){
  Color? statusColor;
  Color? textColor;
  IconData? statusIcon;
  String? statusDesc;

  switch (status) {
    case 'Solicitud registrada':
      statusColor = const Color(0XFF0DCAF0);
      textColor = Colors.black;
      statusIcon = Icons.add_circle_outline;
      statusDesc = 'Solicitud registrada';
      break;
    case 'Solicitud validada':
      statusColor = const Color(0XFF0D6EFD);
      textColor = Colors.white;
      statusIcon = Icons.verified;
      statusDesc = 'Solicitud validada';
      break;
    case 'Solicitud asignada':
      statusColor = const Color(0XFF212529);
      textColor = Colors.white;
      statusIcon = Icons.assignment_ind;
      statusDesc = 'Solicitud asignada';
      break;
    case 'Solicitud en proceso':
      statusColor = const Color(0XFFFFC107);
      textColor = Colors.black;
      statusIcon = Icons.hourglass_bottom;
      statusDesc = 'Solicitud en proceso';
      break;
    case 'Solicitud finalizada':
      statusColor = const Color(0xFFCCBDC9);
      textColor = Colors.black;
      statusIcon = Icons.task_alt;
      statusDesc = 'Solicitud finalizada';
      break;
    case 'Solicitud cerrada':
      statusColor = Colors.green;
      textColor = Colors.black;
      statusIcon = Icons.done_all;
      statusDesc = 'Solicitud cerrada';
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