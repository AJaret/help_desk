import 'package:help_desk/internal/technical_assistance/services/application/datasource/technician_services_api_datasource.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/repositories/technician_services_repository.dart';

class TechnicianServicesRepositoryImpl implements TechnicianServicesRepository {
  final TechnicianServicesApiDatasource datasource;

  TechnicianServicesRepositoryImpl({required this.datasource});

  @override
  Future<List<TechnicianService>> getTechnicianServices() async{
    try {
      return await datasource.getTechnicianServices();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<TechnicianService> getTechnicianServiceDetails(int serviceId) async{
    try {
      return await datasource.getTechnicianServiceDetails(serviceId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
