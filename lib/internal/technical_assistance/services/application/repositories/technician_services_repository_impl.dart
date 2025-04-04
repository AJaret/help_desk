import 'package:help_desk/internal/technical_assistance/services/application/datasource/technician_services_api_datasource.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/closed_service.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/repositories/technician_services_repository.dart';
import 'package:help_desk/internal/users/request/domain/entities/document.dart';

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
  Future<TechnicianService> getTechnicianServiceDetails(String serviceId) async{
    try {
      return await datasource.getTechnicianServiceDetails(serviceId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Document> getDocumentById(int fileId) async{
    try {
      return await datasource.getDocumentById(fileId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<Map<String, dynamic>> doeServiceRequireSignatureAndSurvey(int serviceId) async{
    try {
      return await datasource.doeServiceRequireSignatureAndSurvey(serviceId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> postCloseService(ClosedService closedService) async{
    try {
      return await datasource.postCloseService(closedService);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<String> getServicePdf(String serviceToken) async{
    try {
      return await datasource.getServicePdf(serviceToken);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
