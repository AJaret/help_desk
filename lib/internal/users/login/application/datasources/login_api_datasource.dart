import 'dart:convert';
import 'dart:io';

import 'package:help_desk/internal/users/login/domain/repositories/login_repository.dart';
import 'package:help_desk/shared/helpers/http_interceptor.dart';
import 'package:help_desk/shared/services/token_service.dart';
import 'package:http/http.dart' as http;

class LoginApiDatasourceImp implements LoginRepository {
  final String urlApi = "test-helpdesk.gobiernodesolidaridad.gob.mx";
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
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if(data["respuesta"] == "correcto"){
          String? userDependency;
          String? userDependencyDirector;
          final shortToken = data['token'];
          final longToken = data['refreshToken'];
          await tokenService.saveTokens(shortToken, longToken);
          final responseDep = await httpService.getRequest('http://localhost/apiHelpdeskDNTICS/solicitudes-usuarios/entidad-director-usuario', 1);
          if(responseDep.statusCode == 201){
            dynamic bodyDep = jsonDecode(responseDep.body);
            userDependency = bodyDep["entidad"];
            userDependencyDirector = bodyDep["titular"];
            await tokenService.saveUserDependencyData(userDependency, userDependencyDirector);
          }
          await tokenService.saveUserEmail(email);
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
  
  @override
  Future<void> postResetPassword(String email, String employeeNumber) async{
    try {
      var url = Uri.https(urlApi, '/apiHelpdeskDNTICS/administrador/recuperar-contrasena');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'correo': email, 'numeroEmpleado': employeeNumber}),
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        String message = '';
        switch (data["respuesta"]) {
          case 'verificacion-pendiente':
            message = 'Por el momento no se puede recuperar su contraseña ya que su cuenta se encuentra en proceso de ser activada';
          case 'incorrecto':
            message = 'Alguno de los datos ingresados no coinciden con los datos registrados en su cuenta, por favor, verifique la información';
          case 'registrado':
            message = 'registrado';
          default: 
            message = 'Ocurrió un error al al momento de hacer la petición, por favor, vuelva a intentarlo';
        }
        if(message != 'registrado'){
          throw Exception(message);
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