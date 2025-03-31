import 'package:help_desk/internal/technical_assistance/services/domain/entities/closed_service.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';
import 'package:help_desk/internal/users/request/domain/entities/document.dart';

abstract class TechnicianServicesRepository {
  Future<List<TechnicianService>> getTechnicianServices();
  Future<TechnicianService> getTechnicianServiceDetails(String serviceId);
  Future<Document> getDocumentById(int fileId);
  Future<Map<String, dynamic>> doeServiceRequireSignatureAndSurvey(int serviceId);
  Future<Map<String, dynamic>> postCloseService(ClosedService closedService);
  Future<String> getServicePdf(String serviceToken);
}