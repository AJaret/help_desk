import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:help_desk/internal/request/domain/entities/request.dart';

class RequestCardWidget extends StatefulWidget {
  final Request request;

  const RequestCardWidget({
    super.key,
    required this.request,
  });

  @override
  State<RequestCardWidget> createState() => _RequestCardWidgetState();
}

class _RequestCardWidgetState extends State<RequestCardWidget>{

  @override
  Widget build(BuildContext context) {
    Color? statusColor;
    IconData? statusIcon;
    String? statusDesc;

    switch (widget.request.status) {
      case 1:
        statusColor = const Color(0XFF0DCAF0);
        statusIcon = Icons.add_circle_outline;
        statusDesc = 'Registrada';
        break;
      case 2:
        statusColor = const Color(0XFF0D6EFD);
        statusIcon = Icons.verified;
        statusDesc = 'Validada';
        break;
      case 3:
        statusColor = const Color(0XFF212529);
        statusIcon = Icons.assignment_ind;
        statusDesc = 'Asignada';
        break;
      case 4:
        statusColor = const Color(0XFFFFC107);
        statusIcon = Icons.hourglass_bottom;
        statusDesc = 'En proceso';
        break;
      case 5:
        statusColor = const Color(0xFFD619AD);
        statusIcon = Icons.task_alt;
        statusDesc = 'Terminada';
        break;
      case 6:
        statusColor = const Color(0xFFCCBDC9);
        statusIcon = Icons.done_all;
        statusDesc = 'Finalizado';
        break;
      default:
    }

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: (){
          showModalBottomSheet<String>(
            context: context,
            isDismissible: true,
            isScrollControlled: true,
            builder: (BuildContext context) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: DefaultTabController(
                      length: 4,
                      child: SegmentedTabControl(
                        tabs: [
                          SegmentTab(
                            backgroundColor: statusColor,
                            color: Colors.white,
                            textColor: Colors.white,
                            selectedTextColor: Colors.black,
                            label: "Home",
                          ),
                          SegmentTab(
                            backgroundColor: statusColor,
                            color: Colors.white,
                            textColor: Colors.white,
                            selectedTextColor: Colors.black,
                            label: "Account",
                          ),
                          SegmentTab(
                            backgroundColor: statusColor,
                            color: Colors.white,
                            textColor: Colors.white,
                            selectedTextColor: Colors.black,
                            label: "Account",
                          ),
                          SegmentTab(
                            backgroundColor: statusColor,
                            color: Colors.white,
                            textColor: Colors.white,
                            selectedTextColor: Colors.black,
                            label: "Account",
                          ),
                        ],
                      )
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text('lol'),
                    ),
                  )
                ],
              )
            )
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
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
                  color: widget.request.status == 3 || widget.request.status == 2 ? Colors.white : Colors.black,
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
                        color: widget.request.status == 3 || widget.request.status == 2 ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Folio: ${widget.request.folio}',
                      style: TextStyle(
                        color: widget.request.status == 3 || widget.request.status == 2 ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Nombre: ${widget.request.name}',
                      style: TextStyle(
                        color: widget.request.status == 3 || widget.request.status == 2 ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      'Descripción: ${widget.request.desc}',
                      style: TextStyle(
                        color: widget.request.status == 3 || widget.request.status == 2 ? Colors.white : Colors.black,
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
