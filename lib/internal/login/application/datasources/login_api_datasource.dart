import 'dart:convert';
import 'dart:io';

import 'package:help_desk/internal/catalog/application/services/token_service.dart';
import 'package:help_desk/internal/login/domain/repositories/login_repository.dart';
import 'package:http/http.dart' as http;

class LoginApiDatasourceImp implements LoginRepository {
  final String urlApi = "soportetecnico.gobiernodesolidaridad.gob.mx";
  final TokenService tokenService = TokenService();

  @override
  Future<void> postLogin(String email, String password) async{
    try {
      var url = Uri.http(urlApi, '/apiHelpdeskDNTICS/administrador/iniciar-sesion');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': email, 'password': password}),
      );
      dynamic body = jsonDecode(response.body);
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if(data["respuesta"] == "correcto"){
          final shortToken = data['shortToken'];
          final longToken = data['longToken'];
          await tokenService.saveTokens(shortToken, longToken);
        }else{
          throw Exception('Ocurrió un error al consultar sus datos, por favor, vuelva a intentarlo');
        }
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

  // @override
  // Future<Session> postRefreshToken(String refreshToken) async{
  //   try {
  //     var url = Uri.http(urlApi, '/apiHelpdeskDNTICS/catalogos/direcciones-secretarias');
  //     var response = await http.get(
  //       url,
  //     );
  //     dynamic body = jsonDecode(response.body);
  //     if (response.statusCode == 201) {
  //       List<dynamic> data = body["catalogo"];
  //       List<DependencyCatalog> depenTmp =  data.map<DependencyCatalog>((data) => DependencyCatalogModel.fromJson(data)).toList();
  //       return Session(accessToken: 'ada', refreshToken: 'dasdas');
  //     } else {
  //       String message = body['mensaje_error'];
  //       throw Exception(message);
  //     }
  //   } on SocketException {
  //     throw Exception('No hay conexión a Internet. Por favor, revisa tu conexión.');
  //   }
  //   catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }

}