import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/assigned_agent.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/closed_service.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/work_done.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/blocs/service_requirements_bloc/service_requirements_bloc.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/widgets/service_form_widgets/activities_card_widget.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/widgets/service_form_widgets/timer.dart';
import 'package:help_desk/shared/helpers/form_helper.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ServiceFormScreen extends StatefulWidget {
  final List<AssignedAgent> assignments;
  final TechnicianService serviceData;
  final String startDate;

  const ServiceFormScreen({
    super.key,
    required this.assignments,
    required this.serviceData,
    required this.startDate,
  });

  @override
  State<ServiceFormScreen> createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceFormScreen> {
  final StopWatchTimer stopWatchTimer = StopWatchTimer();
  String formattedTime = '';
  Map<int, List<WorkDone>> activityTasks = {};

  void _updateTasks(int idActividad, List<WorkDone> newTasks) {
    setState(() {
      if (activityTasks.containsKey(idActividad)) {
        activityTasks[idActividad] = List.from(newTasks);
      } else {
        activityTasks[idActividad] = newTasks;
      }
    });
  }

  Future<void> _getCurrentTime() async {
    final int currentTime = await stopWatchTimer.rawTime.first;
    double minutes = currentTime / 60000;
    formattedTime = minutes.toStringAsFixed(2);
  }

  void _finishService() async {
    if (activityTasks.isEmpty) {
      return;
    }

    await _getCurrentTime();
    List<Map<String, dynamic>> actividades = widget.assignments
        .expand((assignment) => assignment.activities?.map((activity) {
              return {
                "idactividad": activity.activityId,
                "idasignacion": assignment.assignationId,
                "tareas": (activityTasks[activity.activityId ?? 0] ?? [])
                    .map((work) => {
                          "description": work.workDescription,
                          "files": (work.documents ?? [])
                              .map((doc) => {
                                    "nombre": doc.file,
                                    "contenido": doc.fileExtension,
                                  })
                              .toList(),
                        })
                    .toList(),
              };
            }).toList() ?? [])
        .toList()
        .cast<Map<String, dynamic>>();

    final bloc = context.read<ServiceRequirementsBloc>();
    bloc.add(GetServiceRequirements(widget.assignments.first.assignationId ?? 0));

    bloc.stream.listen((state) {
      if (state is ServiceRequirementsSuccess) {
        bool requiereFirma = state.serviceRequirements["requiereFirma"] ?? false;
        bool requiereEncuesta = state.serviceRequirements["requiereEncuesta"] ?? false;

        ClosedService closedService = ClosedService(
          serviceId: widget.serviceData.serviceToken,
          serviceToken: widget.serviceData.serviceToken,
          activities: actividades,
          surveyAnswers: [],
          fechaInicio: widget.startDate,
          fechaFin: formatDateTime(DateTime.now()),
        );

        if (requiereFirma || requiereEncuesta) {
          GoRouter.of(context).push('/serviceSignature', extra: {
            "assignments": widget.assignments,
            "serviceData": widget.serviceData,
            "closedService": closedService,
            "serviceRequirements": state.serviceRequirements,
          });
        } else {
          GoRouter.of(context).push('/closedService', extra: closedService);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de servicio', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFA10046),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TimerWidget(stopWatchTimer: stopWatchTimer),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List<Widget>.from(
                      widget.assignments.expand((assignment) {
                        return assignment.activities?.map((activity) {
                          return ActivitiesCardWidget(
                            assignment: assignment,
                            activity: activity,
                            onTasksUpdated: (idActividad, tasks) {
                              _updateTasks(idActividad, tasks);
                            },
                          );
                        }).toList() ?? [];
                      }),
                    ),
                  ),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFA10046)),
                onPressed: activityTasks.isNotEmpty ? _finishService : null,
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text("Terminar servicio"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
