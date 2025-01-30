import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';

abstract class TechnicianServicesRepository {
  Future<List<TechnicianService>> getTechnicianServices();
}