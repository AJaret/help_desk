import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/request/presentation/blocs/request_details_bloc/request_details_bloc.dart';

class RequestDetailsWidget extends StatelessWidget {
  final Color statusColor;
  final String requestId;
  const RequestDetailsWidget({super.key, required this.statusColor, required this.requestId});

  @override
  Widget build(BuildContext context) {
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
          return Column(
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