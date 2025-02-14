import 'package:flutter/cupertino.dart';
import 'package:help_desk/internal/users/request/presentation/widgets/request_search_widget.dart';

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
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          child: SizedBox(
            height: size.height * 0.62,
            child: const RequestSearchWidget(requestType: 'All'),
          )
        ),
      ],
    );
  }
}