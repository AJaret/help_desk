import 'package:help_desk/internal/technical_assistance/services/domain/repositories/technician_services_repository.dart';

class GetServicePdfUsecase {
  final TechnicianServicesRepository techRepo;

  GetServicePdfUsecase({required this.techRepo});

  Future<String> execute({required String serviceToken}) async {
    try {
      return await techRepo.getServicePdf(serviceToken);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
