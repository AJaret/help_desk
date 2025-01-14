import 'dart:convert';
import 'dart:io';

import 'package:help_desk/internal/login/domain/repositories/login_repository.dart';
import 'package:help_desk/shared/helpers/http_interceptor.dart';
import 'package:help_desk/shared/services/token_service.dart';
import 'package:http/http.dart' as http;

class LoginApiDatasourceImp implements LoginRepository {
  final String urlApi = "helpdesk.gobiernodesolidaridad.gob.mx";
  final TokenService tokenService = TokenService();
  final httpService = HttpService();

  @override
  Future<void> postLogin(String email, String password) async{
    try {
      var url = Uri.https(urlApi, '/apiHelpdeskDNTICS/administrador/iniciar-sesion');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'usuario': email, 'contrasena': password}),
      );
      dynamic body = jsonDecode(response.body);
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if(data["respuesta"] == "correcto"){
          String? userDependency;
          String? userDependencyDirector;
          final shortToken = data['token'];
          final longToken = data['refreshToken'];
          await tokenService.saveTokens(shortToken, longToken);
          final responseDep = await httpService.getRequest('https://helpdesk.gobiernodesolidaridad.gob.mx/apiHelpdeskDNTICS/solicitudes-usuarios/entidad-director-usuario', 2);
          if(responseDep.statusCode == 201){
            dynamic bodyDep = jsonDecode(responseDep.body);
            userDependency = bodyDep["entidad"];
            userDependencyDirector = bodyDep["titular"];
            await tokenService.saveUserDependencyData(userDependency, userDependencyDirector);
          }
        }else{
          throw Exception('Usuario o contraseña incorrectos');
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
}