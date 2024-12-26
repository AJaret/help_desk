import 'dart:convert';
import 'dart:io';

import 'package:help_desk/internal/catalog/application/models/dependency_catalog_model.dart';
import 'package:help_desk/internal/catalog/domain/entities/dependency.dart';
import 'package:help_desk/internal/catalog/domain/repositories/dependency_catalog_repository.dart';
import 'package:http/http.dart' as http;

class DependencyCatalogApiDatasourceImp implements DependencyCatalogRepository {
  String urlApi = "soportetecnico.gobiernodesolidaridad.gob.mx";

  @override
  Future<List<DependencyCatalog>> getDependencies() async{
    try {
      var url = Uri.http(urlApi, '/apiHelpdeskDNTICS/catalogos/direcciones-secretarias');
      var response = await http.get(
        url,
      );
      dynamic body = jsonDecode(response.body);
      if (response.statusCode == 201) {
        List<dynamic> data = body["catalogo"];
        List<DependencyCatalog> depenTmp =  data.map<DependencyCatalog>((data) => DependencyCatalogModel.fromJson(data)).toList();
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