class ClosedService {
  final String? serviceId;
  final String? serviceToken;
  final List<Map<String, dynamic>>? activities;
  final List<dynamic>? surveyAnswers;
  final String? signBase64;
  final String? fechaInicio; 
  final String? fechaFin;
  final String? latitude;
  final String? longitude;

  ClosedService({
    this.serviceId,
    this.serviceToken,
    this.activities,
    this.surveyAnswers,
    this.signBase64,
    this.fechaFin,
    this.fechaInicio,
    this.latitude,
    this.longitude
  });
}