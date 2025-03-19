import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/closed_service.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/widgets/service_form_widgets/signature_widget.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/widgets/service_form_widgets/survey.dart';

class ServiceForm2Screen extends StatefulWidget {
  final ClosedService closedService;
  final Map<String, dynamic> serviceRequirements;
  final TechnicianService serviceData;

  const ServiceForm2Screen({
    super.key,
    required this.closedService,
    required this.serviceRequirements, required this.serviceData,
  });

  @override
  State<ServiceForm2Screen> createState() => _ServiceForm2ScreenState();
}

class _ServiceForm2ScreenState extends State<ServiceForm2Screen> {
  String? _savedSignature;
  bool showSignature = false;
  bool showSurvey = false;
  final TextEditingController _signatureNameController = TextEditingController();
  final GlobalKey<SurveyWidgetState> surveyKey = GlobalKey<SurveyWidgetState>();
  Map<String, dynamic>? surveyData;
  int step = 1;

  @override
  void initState() {
    super.initState();
    _signatureNameController.text = widget.serviceData.addressWith ?? '';

    // Configurar si se requiere firma y/o encuesta
    showSignature = widget.serviceRequirements["requiereFirma"] ?? false;
    showSurvey = widget.serviceRequirements["requiereEncuesta"] ?? false;

    if (showSignature && showSurvey) {
      showSurvey = false; // Primero firma, luego encuesta
    }
  }

  void _handleSignatureSaved(String base64Signature) {
    setState(() {
      _savedSignature = base64Signature;
    });
  }

  void _handleSurveyCompleted(Map<String, dynamic> feedback) {
    setState(() {
      surveyData = feedback;
    });
  }

  void _finishService() {
    // 🔹 Actualizar el objeto `ClosedService` con firma y encuesta si aplican
    ClosedService updatedService = ClosedService(
      serviceId: widget.closedService.serviceId,
      serviceToken: widget.closedService.serviceToken,
      activities: widget.closedService.activities,
      surveyAnswers: surveyData != null ? [surveyData!["rating"], surveyData!["observations"]] : [],
      signBase64: _savedSignature,
      fechaInicio: widget.closedService.fechaInicio,
      fechaFin: widget.closedService.fechaFin,
    );

    GoRouter.of(context).push('/closedService', extra: updatedService);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de servicio', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFA10046),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (showSignature)
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: SignatureWidget(onSignatureSaved: _handleSignatureSaved)),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        controller: _signatureNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Ingrese el nombre de la persona que firma...",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (showSurvey)
              Expanded(
                child: SurveyWidget(onSurveyCompleted: _handleSurveyCompleted, key: surveyKey),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFA10046)),
              onPressed: _savedSignature != null
                  ? () {
                      if (widget.serviceRequirements["requiereFirma"] &&
                          widget.serviceRequirements["requiereEncuesta"] &&
                          step == 1) {
                        setState(() {
                          showSignature = false;
                          showSurvey = true;
                          step = 2;
                        });
                      } else if (step == 2) {
                        surveyKey.currentState?.submitSurvey();
                        _finishService();
                      } else if (widget.serviceRequirements["requiereFirma"] ||
                          widget.serviceRequirements["requiereEncuesta"]) {
                        surveyKey.currentState?.submitSurvey();
                        _finishService();
                      }
                    }
                  : null,
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text("Siguiente"),
            ),
          ],
        ),
      ),
    );
  }
}