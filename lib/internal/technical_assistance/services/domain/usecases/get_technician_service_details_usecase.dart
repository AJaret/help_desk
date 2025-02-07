import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/repositories/technician_services_repository.dart';

class GetTechnicianServiceDetailsUsecase {
  final TechnicianServicesRepository technicianServicesRepository;

  GetTechnicianServiceDetailsUsecase({required this.technicianServicesRepository});

  Future<TechnicianService> execute({required int serviceId}) async {
    try {
      return await technicianServicesRepository.getTechnicianServiceDetails(serviceId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
