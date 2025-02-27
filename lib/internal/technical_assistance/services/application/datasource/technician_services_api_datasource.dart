import 'dart:convert';
import 'dart:io';

import 'package:help_desk/internal/technical_assistance/services/application/models/technician_service_details_model.dart';
import 'package:help_desk/internal/technical_assistance/services/application/models/technician_service_model.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/repositories/technician_services_repository.dart';
import 'package:help_desk/internal/users/request/application/models/document_model.dart';
import 'package:help_desk/internal/users/request/domain/entities/document.dart';
import 'package:help_desk/shared/helpers/http_interceptor.dart';
import 'package:help_desk/shared/services/token_service.dart';

class TechnicianServicesApiDatasource implements TechnicianServicesRepository {
  final String urlApi = "http://localhost";
  final TokenService tokenService = TokenService();
  final httpService = HttpService();

  @override
  Future<List<TechnicianService>> getTechnicianServices() async{
    try {
      final response = await httpService.getRequest('$urlApi/apiHelpdeskDNTICS/responsables-app/servicios', 1, isTechnician: true);
      if (response.statusCode == 201) {
        dynamic body = jsonDecode(response.body);
        final List<TechnicianService> data = body["servicios"].map<TechnicianService>((data) => TechnicianServiceModel.fromJson(data)).toList();
        return data;
      } else if(response.statusCode == 401) {
        String message = 'Su sesión ha expirado, por favor vuelva a iniciar sesión.';
        throw Exception(message);
      }else{
        String message = 'Ocurrió un error al obtener los servicios, por favor intente de nuevo.';
        throw Exception(message);
      }
    } on SocketException {
      throw Exception('No hay conexión a Internet. Por favor, revisa tu conexión.');
    }
    catch (e) {
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<TechnicianService> getTechnicianServiceDetails(String serviceId) async{
    try {
      final response = await httpService.getRequest('$urlApi/apiHelpdeskDNTICS/responsables-app/servicio/$serviceId', 1, isTechnician: true);
      if (response.statusCode == 201) {
        dynamic body = jsonDecode(response.body);
        final Map<String, dynamic> allDAta = {
          ... body["servicio"],
          "documentos": body["documentos"],
          "agentesAsignados": body["agentesAsignados"],
          "seguimiento": body["seguimiento"],
        };
        final TechnicianService data = TechnicianServiceDetailsModel.fromJson(allDAta);
        return data;
      } else if(response.statusCode == 401) {
        String message = 'Su sesión ha expirado, por favor vuelva a iniciar sesión.';
        throw Exception(message);
      }else{
        String message = 'Ocurrió un error al obtener los servicios, por favor intente de nuevo.';
        throw Exception(message);
      }
    } on SocketException {
      throw Exception('No hay conexión a Internet. Por favor, revisa tu conexión.');
    }
    catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Document> getDocumentById(int fileId) async{
    try {
      final response = await httpService.getRequest('$urlApi/apiHelpdeskDNTICS/solicitudes-usuarios/archivo-digital/$fileId', 1, isTechnician: true);
      if (response.statusCode == 201) {
        dynamic body = jsonDecode(response.body);
        final Document data = DocumentModel.fromJson(body);
        return data;
      }
      else{
        String message = 'Ocurrió un error al obtener la solicitud.';
        throw Exception(message);
      }
    } on SocketException {
      throw Exception('No hay conexión a Internet. Por favor, revisa tu conexión.');
    }
    catch (e) {
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<Map<String, dynamic>> doeServiceRequireSignatureAndSurvey(int serviceId) async{
    try {
      final response = await httpService.getRequest('$urlApi/apiHelpdeskDNTICS/responsables-app/verificar-servicio-requiere-firma/$serviceId', 1, isTechnician: true);
      if (response.statusCode == 201) {
        dynamic body = jsonDecode(response.body);
        final Map<String, dynamic> resp = {
          "requiereFirma": body["requiereFirma"] ?? false,
          "requiereEncuesta": body["requiereEncuesta"] ?? false,
        };
        return resp;
      } else if(response.statusCode == 401) {
        String message = 'Su sesión ha expirado, por favor vuelva a iniciar sesión.';
        throw Exception(message);
      }else{
        String message = 'Ocurrió un error al obtener los servicios, por favor intente de nuevo.';
        throw Exception(message);
      }
    } on SocketException {
      throw Exception('No hay conexión a Internet. Por favor, revisa tu conexión.');
    }
    catch (e) {
      throw Exception(e.toString());
    }
  }
}