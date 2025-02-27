import 'package:help_desk/internal/technical_assistance/services/domain/repositories/technician_services_repository.dart';

class GetServiceRequireSignatureAndSurveyUsecase {
  final TechnicianServicesRepository technicianServicesRepository;

  GetServiceRequireSignatureAndSurveyUsecase({required this.technicianServicesRepository});

  Future<Map<String, dynamic>> execute(int serviceId) async {
    try {
      return await technicianServicesRepository.doeServiceRequireSignatureAndSurvey(serviceId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
