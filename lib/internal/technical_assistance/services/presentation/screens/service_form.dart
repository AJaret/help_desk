import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/assigned_agent.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/widgets/service_form_widgets/activities_card_widget.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/widgets/service_form_widgets/timer.dart';

class ServiceForm extends StatefulWidget {
  final AssignedAgent assignment;
  const ServiceForm({super.key, required this.assignment});

  @override
  State<ServiceForm> createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  List<Map<String, dynamic>> _tasks = [];

  void _updateTasks(List<Map<String, dynamic>> newTasks) {
    setState(() {
      _tasks = newTasks;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de servicio', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFFA10046),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const TimerWidget(),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(child: ActivitiesCardWidget(assignment: widget.assignment, tasks: _tasks, onTasksUpdated: _updateTasks))
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFA10046)),
              onPressed: _tasks.isNotEmpty ? (){
                GoRouter.of(context).push('/serviceSignature', extra: widget.assignment);
              } : null,
              icon: const Icon(Icons.check, color: Colors.white,),
              label: const Text("Terminar servicio"),
            ),
          ],
        ),
      ),
      
    );
  }
}