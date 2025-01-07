import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/request/domain/entities/request.dart';
import 'package:help_desk/internal/request/presentation/blocs/request_details_bloc/request_details_bloc.dart';
import 'package:help_desk/internal/request/presentation/widgets/request_details_widgets/request_menu_widget.dart';

class RequestDetailsWidget extends StatelessWidget {
  final Color statusColor;
  final String requestId;
  const RequestDetailsWidget({super.key, required this.statusColor, required this.requestId});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    final selectedTextStyle = textStyle?.copyWith(fontWeight: FontWeight.bold);

    return BlocBuilder<RequestDetailsBloc, RequestDetailsState>(
      builder: (context, state) {
        if(state is RequestDetailsInitial){
          context.read<RequestDetailsBloc>().add(GetRequestById(requestId: requestId));
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
                            RequestMenuWidget(
                              requestData: state.request.requestDetails ?? Request(),
                            ),
                            RequestMenuWidget(
                              requestData: state.request.requestDetails ?? Request(),
                            ),
                            RequestMenuWidget(
                              requestData: state.request.requestDetails ?? Request(),
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
