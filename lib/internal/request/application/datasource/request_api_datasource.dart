import 'dart:convert';
import 'dart:io';

import 'package:help_desk/internal/request/application/models/document_model.dart';
import 'package:help_desk/internal/request/application/models/request_full_model.dart';
import 'package:help_desk/internal/request/application/models/request_model.dart';
import 'package:help_desk/internal/request/domain/entities/document.dart';
import 'package:help_desk/internal/request/domain/entities/request.dart';
import 'package:help_desk/internal/request/domain/entities/request_full.dart';
import 'package:help_desk/internal/request/domain/repositories/request_repository.dart';
import 'package:help_desk/shared/helpers/http_interceptor.dart';
import 'package:help_desk/shared/services/token_service.dart';

class RequestApiDatasourceImp implements RequestRepository {
  final String urlApi = "https://helpdesk.gobiernodesolidaridad.gob.mx";
  final TokenService tokenService = TokenService();
  final httpService = HttpService();
  
  @override
  Future<List<Request>> getRequests() async{
    try {
      final response = await httpService.getRequest('$urlApi/apiHelpdeskDNTICS/solicitudes-usuarios/solicitudes', 2);
      if (response.statusCode == 201) {
        dynamic body = jsonDecode(response.body);
        final List<Request> data = body["solicitudes"].map<Request>((data) => RequestModel.fromJson(data)).toList();
        return data;
      } else if(response.statusCode == 401) {
        String message = 'Su sesión ha expirado, por favor vuelva a iniciar sesión.';
        throw Exception(message);
      }else{
        String message = 'Ocurrió un error al obtener las solicitudes, por favor intente de nuevo.';
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
  Future<RequestFull> getRequestById(String requestId) async{
    try {
      final response = await httpService.getRequest('$urlApi/apiHelpdeskDNTICS/solicitudes-usuarios/solicitud/$requestId', 1);
      if (response.statusCode == 201) {
        dynamic body = jsonDecode(response.body);
        if(body["respuesta"] == "correcto"){
          final RequestFull data = RequestFullModel.fromJson(body);
          return data;
        }else{
          throw Exception('No se encontró la solicitud.');
        }
      }
      else{
        String message = 'Ocurrió un error al obtener las solicitudes, por favor intente de nuevo.';
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
  Future<Document> getDocumentFile(int fileId) async{
    try {
      final response = await httpService.getRequest('$urlApi/apiHelpdeskDNTICS/solicitudes-usuarios/archivo-digital/$fileId', 1);
      if (response.statusCode == 201) {
        dynamic body = jsonDecode(response.body);
        final Document data = DocumentModel.fromJson(body);
        return data;
      }
      else{
        String message = 'Ocurrió un error al obtener las solicitudes, por favor intente de nuevo.';
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
  Future<bool> postNewRequest() async{
    try {
      final response = await httpService.getRequest('$urlApi/apiHelpdeskDNTICS/solicitudes-usuarios/solicitud', 2);
      if (response.statusCode == 201) {
        dynamic body = jsonDecode(response.body);
        final bool data = body["solicitudes"].map<Request>((data) => RequestModel.fromJson(data)).toList();
        return data;
      } else if(response.statusCode == 401) {
        String message = 'Su sesión ha expirado, por favor vuelva a iniciar sesión.';
        throw Exception(message);
      }else{
        String message = 'Ocurrió un error al obtener las solicitudes, por favor intente de nuevo.';
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