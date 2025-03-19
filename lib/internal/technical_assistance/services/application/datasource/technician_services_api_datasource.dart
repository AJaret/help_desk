import 'dart:convert';
import 'dart:io';

import 'package:help_desk/internal/technical_assistance/services/application/models/technician_service_details_model.dart';
import 'package:help_desk/internal/technical_assistance/services/application/models/technician_service_model.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/closed_service.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/repositories/technician_services_repository.dart';
import 'package:help_desk/internal/users/request/application/models/document_model.dart';
import 'package:help_desk/internal/users/request/domain/entities/document.dart';
import 'package:help_desk/shared/helpers/http_interceptor.dart';
import 'package:help_desk/shared/services/token_service.dart';

class TechnicianServicesApiDatasource implements TechnicianServicesRepository {
  final String urlApi = "https://test-helpdesk.gobiernodesolidaridad.gob.mx";
  final TokenService tokenService = TokenService();
  final httpService = HttpService();

  @override
  Future<List<TechnicianService>> getTechnicianServices() async{
    try {
      final response = await httpService.sendRequest('$urlApi/apiHelpdeskDNTICS/responsables-app/servicios', 1, isTechnician: true);
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
      final response = await httpService.sendRequest('$urlApi/apiHelpdeskDNTICS/responsables-app/servicio/$serviceId', 1, isTechnician: true);
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
      final response = await httpService.sendRequest('$urlApi/apiHelpdeskDNTICS/solicitudes-usuarios/archivo-digital/$fileId', 1, isTechnician: true);
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
      final response = await httpService.sendRequest('$urlApi/apiHelpdeskDNTICS/responsables-app/verificar-servicio-requiere-firma/$serviceId', 1, isTechnician: true);
      if (response.statusCode == 200) {
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
        String message = 'Ocurrió un error al obtener los requerimientos del servicio, por favor intente de nuevo.';
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
  Future<Map<String, dynamic>> postCloseService(ClosedService closedService) async{
    try {

      final Map<String, dynamic> body = {
        "tokenServicio": closedService.serviceToken,
        "fechaInicio": closedService.fechaInicio,
        "fechaFin": closedService.fechaFin,
        "actividades": closedService.activities,
        "firmaBase64": closedService.signBase64,
        "respuestasEncuesta": closedService.surveyAnswers,
      };

      final response = await httpService.sendRequest('$urlApi/apiHelpdeskDNTICS/responsables-app/cerrar-servicio', 2, isTechnician: true, body: body);

      if (response.statusCode == 201) {
        dynamic body = jsonDecode(response.body);
        if(body["mensaje"] == 'Servicio cerrado correctamente'){
          final Map<String, dynamic> resp = {
            "mensaje": body["mensaje"],
            "pdfBase64": body["pdfBase64"],
          };
          return resp;
        }else{
          throw Exception(body["respuesta"]);
        }
      } else if(response.statusCode == 401) {
        String message = 'Su sesión ha expirado, por favor vuelva a iniciar sesión.';
        throw Exception(message);
      }else{
        String message = 'Ocurrió un error al cerrar el servicio, por favor intente de nuevo.';
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