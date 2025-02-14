import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/users/request/domain/entities/request.dart';
import 'package:help_desk/internal/users/request/presentation/blocs/request_details_bloc/request_details_bloc.dart';
import 'package:help_desk/internal/users/request/presentation/widgets/request_details_widgets/files_widget.dart';
import 'package:help_desk/internal/users/request/presentation/widgets/request_details_widgets/follow_up_widget.dart';
import 'package:help_desk/internal/users/request/presentation/widgets/request_details_widgets/request_menu_widget.dart';
import 'package:help_desk/internal/users/request/presentation/widgets/request_details_widgets/services_widget.dart';

class RequestDetailsWidget extends StatefulWidget {
  final Color statusColor;
  final String requestId;
  const RequestDetailsWidget({super.key, required this.statusColor, required this.requestId});

  @override
  State<RequestDetailsWidget> createState() => _RequestDetailsWidgetState();
}

class _RequestDetailsWidgetState extends State<RequestDetailsWidget> {
  @override
  void initState() {
    super.initState();
    // Dispara el evento cuando la pantalla se carga
    context.read<RequestDetailsBloc>().add(GetRequestById(requestId: widget.requestId));
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    final selectedTextStyle = textStyle?.copyWith(fontWeight: FontWeight.bold);

    return BlocBuilder<RequestDetailsBloc, RequestDetailsState>(
      builder: (context, state) {
        if(state is RequestDetailsInitial){
          context.read<RequestDetailsBloc>().add(GetRequestById(requestId: widget.requestId));
        }
        else if(state is GettingRequestDetails){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        else if(state is RequestDetailsSuccess){
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: DefaultTabController(
              length: 4,
              child: Scaffold(
                body: SafeArea(
                  child: Stack(
                    children: [
                      SegmentedTabControl(
                        tabTextColor: Colors.black,
                        selectedTabTextColor: Colors.white,
                        indicatorPadding: const EdgeInsets.all(2),
                        squeezeIntensity: 2,
                        tabPadding: const EdgeInsets.symmetric(horizontal: 1),
                        textStyle: textStyle,
                        selectedTextStyle: selectedTextStyle,
                        tabs: [
                          SegmentTab(
                            label: 'Solicitud',
                            color: Colors.red.shade300,
                            backgroundColor: Colors.red.shade100,
                          ),
                          SegmentTab(
                            label: 'Archivo digital',
                            color: Colors.amber.shade600,
                            backgroundColor: Colors.amber.shade300,
                          ),
                          SegmentTab(
                            label: 'Seguimiento',
                            backgroundColor: Colors.blue.shade100,
                            color: Colors.blue.shade300,
                          ),
                          SegmentTab(
                            label: 'Servicios',
                            backgroundColor: Colors.orange.shade100,
                            color: Colors.orange.shade300,
                          ),
                        ],
                      ),
                      // Sample pages
                      Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: TabBarView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            RequestMenuWidget(
                              requestData: state.request.requestDetails ?? Request(),
                            ),
                            FilesWidget(
                              documents: state.request.documents ?? [],
                            ),
                            FollowUpWidget(
                              followUps: state.request.followUps ?? [],
                            ),
                            ServicesWidget(
                              services: state.request.services ?? [],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        else if(state is ErrorGettingRequestDetails){
          return Center(
            child: Text(state.message),
          );
        }
        return Container();
      },
    );
  }
}
