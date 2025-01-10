import 'dart:convert';
import 'dart:io';

import 'package:help_desk/internal/catalog/application/models/dependency_catalog_model.dart';
import 'package:help_desk/internal/catalog/domain/entities/dependency.dart';
import 'package:help_desk/internal/catalog/domain/repositories/catalog_repository.dart';
import 'package:help_desk/shared/helpers/http_interceptor.dart';
import 'package:help_desk/shared/services/token_service.dart';

class CatalogApiDatasourceImp implements CatalogRepository {
  String urlApi = "soportetecnico.gobiernodesolidaridad.gob.mx";
  final TokenService tokenService = TokenService();
  final httpService = HttpService();

  @override
  Future<List<Catalog>> getDependencies() async{
    try {
      final response = await httpService.getRequest('https://soportetecnico.gobiernodesolidaridad.gob.mx/apiHelpdeskDNTICS/catalogos/direcciones-secretarias', 1);
      dynamic body = jsonDecode(response.body);
      if (response.statusCode == 201) {
        List<dynamic> data = body["catalogo"];
        List<Catalog> depenTmp =  data.map<Catalog>((data) => CatalogModel.fromJson(data)).toList();
        return depenTmp;
      } else {
        String message = body['mensaje_error'];
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
  Future<List<Catalog>> getPhysicalLocations() async{
    try {
      final response = await httpService.getRequest('https://soportetecnico.gobiernodesolidaridad.gob.mx/apiHelpdeskDNTICS/catalogos/ubicacion-servicio', 1);
      dynamic body = jsonDecode(response.body);
      if (response.statusCode == 201) {
        List<dynamic> data = body["catalogo"];
        List<Catalog> depenTmp =  data.map<Catalog>((data) => CatalogModel.fromJson(data)).toList();
        return depenTmp;
      } else {
        String message = body['mensaje_error'];
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