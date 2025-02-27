import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/blocs/technician_services_bloc/technician_services_bloc.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/widgets/details_widgets/assignation_services_widget.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/widgets/details_widgets/service_details_menu_widget.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/widgets/details_widgets/service_files_widget.dart';
import 'package:help_desk/internal/users/request/presentation/widgets/request_details_widgets/follow_up_widget.dart';
import 'package:help_desk/shared/helpers/app_dependencies.dart';

class TechnicianServiceDetailsScreen extends StatelessWidget {
  final Color statusColor;
  final String requestId;
  const TechnicianServiceDetailsScreen({super.key, required this.statusColor, required this.requestId});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    final selectedTextStyle = textStyle?.copyWith(fontWeight: FontWeight.bold);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del servicio', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFFA10046),
      ),
      backgroundColor: Colors.white,
      body: SizedBox(
        height: size.height,
        child: BlocProvider(
          create: (context) => TechnicianServicesBloc(AppDependencies.getTechnicianServicesUsecase, AppDependencies.getTechnicianServiceDetailsUsecase, AppDependencies.getDocumentByIdUsecase),
          child: BlocListener<TechnicianServicesBloc, TechnicianServicesState>(
            listener: (context, state) {
              if (state is ErrorGettingTechnicianServices) {
                GoRouter.of(context).canPop() ? GoRouter.of(context).pop() : null;
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Error'),
                    content: Center(
                      child: Text(state.message),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () => GoRouter.of(context).pop(),
                        child: const Text('Aceptar'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: BlocBuilder<TechnicianServicesBloc, TechnicianServicesState>(
              builder: (context, state) {
                if (state is TechnicianServicesInitial) {
                  context.read<TechnicianServicesBloc>().add(GetTechnicianServiceDetails(requestId));
                } else if (state is GettingTechnicianServiceDetails) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TechnicianServiceDetailsSuccess) {
                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: DefaultTabController(
                      length: 4,
                      child: SafeArea(
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
                                  label: 'Asignación',
                                  backgroundColor: Colors.blue.shade100,
                                  color: Colors.blue.shade300,
                                ),
                                SegmentTab(
                                  label: 'Archivo digital',
                                  color: Colors.amber.shade600,
                                  backgroundColor: Colors.amber.shade300,
                                ),
                                SegmentTab(
                                  label: 'Seguimiento',
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
                                  ServiceDetailsMenuWidget(
                                    requestData: state.services,
                                  ),
                                  state.services.assignedAgent!.isNotEmpty ? 
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: state.services.assignedAgent?.length,
                                          itemBuilder: (context, index) {
                                            return AssignationServicesWidget(assignment: state.services.assignedAgent![index]);
                                          },
                                        ),
                                      ),
                                      state.services.status == 'Servicio asignado' ? ElevatedButton(
                                        onPressed: (){
                                          showCupertinoDialog(
                                            context: context, 
                                            builder: (context) => CupertinoAlertDialog(
                                              title: const Text('Iniciar servicio'),
                                              content: const Center(
                                                child: Text('Estas a punto de iniciar un servicio, ¿Estás seguro?'),
                                              ),
                                              actions: [
                                                CupertinoDialogAction(
                                                  isDefaultAction: true,
                                                  onPressed: () => GoRouter.of(context).pop(), 
                                                  child: const Text('Cancelar'),
                                                ),
                                                CupertinoDialogAction(
                                                  onPressed: () => GoRouter.of(context).push('/serviceForm', extra: state.services.assignedAgent!.first), 
                                                  child: const Text('Iniciar'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF8B1A42),
                                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          'Iniciar Servicio',
                                          style: TextStyle(fontSize: size.width * 0.04),
                                        ),
                                      ) : Container(),
                                    ],
                                  ) : const Center(
                                    child: Text('No hay servicios asignados'),
                                  ),
                                  ServiceFilesWidget(
                                    documents: state.services.documents ?? [],
                                  ),
                                  FollowUpWidget(
                                    followUps: state.services.followUp ?? [],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (state is ErrorGettingTechnicianServiceDetails) {
                  return Center(
                    child: Text(state.message),
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      )
    );
  }
}
