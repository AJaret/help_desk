import 'dart:convert';
import 'dart:io';

import 'package:help_desk/internal/technical_assistance/domain/repositories/technicians_login_repository.dart';
import 'package:help_desk/shared/helpers/http_interceptor.dart';
import 'package:help_desk/shared/services/token_service.dart';
import 'package:http/http.dart' as http;

class TechniciansLoginApiDatasource implements TechniciansLoginRepository {
  final String urlApi = "helpdesk.gobiernodesolidaridad.gob.mx";
  final TokenService tokenService = TokenService();
  final httpService = HttpService();
//TODO PENDEIENTE CAMBIAR EL API PARA TECNICOS, AHORTA ES COPIA DEL OTRO LOGIN
  @override
  Future<void> postTechniciansLogin(String email, String password) async{
    try {
      var url = Uri.https(urlApi, '/apiHelpdeskDNTICS/administrador/iniciar-sesion');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'usuario': email, 'contrasena': password}),
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if(data["respuesta"] == "correcto"){
          String? userDependency;
          String? userDependencyDirector;
          final shortToken = data['token'];
          final longToken = data['refreshToken'];
          await tokenService.saveTokens(shortToken, longToken);
          final responseDep = await httpService.getRequest('https://helpdesk.gobiernodesolidaridad.gob.mx/apiHelpdeskDNTICS/solicitudes-usuarios/entidad-director-usuario', 1);
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
        throw Exception('Ocurrió un error al al momento de hacer la petición, por favor, vuelva a intentarlo');
      }
    } on SocketException {
      throw Exception('No hay conexión a Internet. Por favor, revisa tu conexión.');
    }
    catch (e) {
      throw Exception(e.toString());
    }
  }
}