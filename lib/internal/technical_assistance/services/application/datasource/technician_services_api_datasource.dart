import 'dart:convert';
import 'dart:io';

import 'package:help_desk/internal/technical_assistance/services/application/models/technician_service_details_model.dart';
import 'package:help_desk/internal/technical_assistance/services/application/models/technician_service_model.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/repositories/technician_services_repository.dart';
import 'package:help_desk/shared/helpers/http_interceptor.dart';
import 'package:help_desk/shared/services/token_service.dart';

class TechnicianServicesApiDatasource implements TechnicianServicesRepository {
  final String urlApi = "https://helpdesk.gobiernodesolidaridad.gob.mx";
  final TokenService tokenService = TokenService();
  final httpService = HttpService();

  @override
  Future<List<TechnicianService>> getTechnicianServices() async{
    try {
      final response = await httpService.getRequest('$urlApi/apiHelpdeskDNTICS/responsables/servicios', 1, isTechnician: true);
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
  Future<TechnicianService> getTechnicianServiceDetails(int serviceId) async{
    try {
      final response = await httpService.getRequest('$urlApi/apiHelpdeskDNTICS/responsables/servicio/$serviceId', 1, isTechnician: true);
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
}