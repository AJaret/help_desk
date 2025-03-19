import 'package:help_desk/internal/technical_assistance/services/domain/entities/closed_service.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/repositories/technician_services_repository.dart';

class PostCloseServiceUsecase {
  final TechnicianServicesRepository technicianServicesRepository;

  PostCloseServiceUsecase({required this.technicianServicesRepository});

  Future<Map<String, dynamic>> execute(ClosedService closedService) async {
    try {
      return await technicianServicesRepository.postCloseService(closedService);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
