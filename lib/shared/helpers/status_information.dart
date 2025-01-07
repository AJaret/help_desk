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
    case 'Solicitud terminada':
      statusColor = const Color(0xFFD619AD);
      textColor = Colors.black;
      statusIcon = Icons.task_alt;
      statusDesc = 'Solicitud terminada';
      break;
    case 'Solicitud finalizada':
      statusColor = const Color(0xFFCCBDC9);
      textColor = Colors.black;
      statusIcon = Icons.done_all;
      statusDesc = 'Solicitud finalizada';
      break;
    default:
  }

  return {
    'statusColor': statusColor,
    'statusIcon': statusIcon,
    'statusDesc': statusDesc,
    'textColor': textColor
  };
}