import 'dart:convert';
import 'dart:io';

import 'package:help_desk/internal/users/catalog/application/models/dependency_catalog_model.dart';
import 'package:help_desk/internal/users/catalog/domain/entities/dependency.dart';
import 'package:help_desk/internal/users/catalog/domain/repositories/catalog_repository.dart';
import 'package:help_desk/shared/helpers/http_interceptor.dart';
import 'package:help_desk/shared/services/token_service.dart';
import 'package:http/http.dart' as htpp;

class CatalogApiDatasourceImp implements CatalogRepository {
  final TokenService tokenService = TokenService();
  final httpService = HttpService();

  @override
  Future<List<Catalog>> getDependencies() async{
    try {
      final response = await htpp.get(Uri.parse('https://helpdesk.playadelcarmen.gob.mx/apiHelpdeskDNTICS/catalogos/direcciones-secretarias'));
      if (response.statusCode == 201) {
        dynamic body = jsonDecode(response.body);
        List<dynamic> data = body["catalogo"];
        List<Catalog> depenTmp =  data.map<Catalog>((data) => CatalogModel.fromJson(data)).toList();
        return depenTmp;
      } else {
        String message = 'Ocurrió un error al consultar los datos, vuelva a intentarlo.';
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
      final response = await httpService.sendRequest('https://helpdesk.playadelcarmen.gob.mx/apiHelpdeskDNTICS/catalogos/ubicacion-servicio', 1);
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