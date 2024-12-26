import 'package:flutter/material.dart';
import 'package:help_desk/internal/request/domain/entities/request.dart';
import 'package:help_desk/internal/request/presentation/widgets/request_search_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  final List<Request> actors = [
    Request(folio: 51, name: 'Solicitud 8', desc: 'Descripción de la solicitud 8', status: 6, date: '23-11-1999'),
    Request(folio: 58, name: 'Solicitud 2', desc: 'Descripción de la solicitud 2', status: 6, date: '29-11-1999'),
    Request(folio: 47, name: 'Solicitud 1', desc: 'Descripción de la solicitud 1', status: 6, date: '30-11-1999'),
    Request(folio: 49, name: 'Solicitud 6', desc: 'Descripción de la solicitud 6', status: 6, date: '25-11-1999'),
    Request(folio: 50, name: 'Solicitud 7', desc: 'Descripción de la solicitud 7', status: 6, date: '24-11-1999'),
    Request(folio: 78, name: 'Solicitud 3', desc: 'Descripción de la solicitud 3', status: 6, date: '28-11-1999'),
    Request(folio: 66, name: 'Solicitud 5', desc: 'Descripción de la solicitud 5', status: 6, date: '26-11-1999'),
    Request(folio: 44, name: 'Solicitud 4', desc: 'Descripción de la solicitud 4', status: 6, date: '27-11-1999'),
  ];


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'HISTORIAL DE SOLICITUDES',
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
            child: RequestSearchWidget(requests: actors)
          ),
        ),
      ],
    );
  }
}