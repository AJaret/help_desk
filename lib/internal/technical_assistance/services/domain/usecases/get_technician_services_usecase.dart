import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/repositories/technician_services_repository.dart';

class GetTechnicianServicesUsecase {
  final TechnicianServicesRepository technicianServicesRepository;

  GetTechnicianServicesUsecase({required this.technicianServicesRepository});

  Future<List<TechnicianService>> execute({required String email, required String password}) async {
    try {
      return await technicianServicesRepository.getTechnicianServices();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
