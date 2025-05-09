import 'dart:convert';
import 'dart:io';

import 'package:help_desk/internal/users/register/domain/entities/user_register.dart';
import 'package:help_desk/internal/users/register/domain/repositories/user_register_repository.dart';
import 'package:http/http.dart' as http;

class UserRegisterApiDatasourceImp implements UserRegisterRepository{
  String urlApi = "helpdesk.playadelcarmen.gob.mx";
  
  @override
  Future<bool> postUser({required UserRegister userData}) async{
    try {
      var url = Uri.https(urlApi, '/api_helpdesk_dntics/crear-cuenta.php');
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "entidad": userData.entityId.toString(),
          "correo": userData.email,
          "numeroEmpleado": userData.employeeNumber,
          "fechaNacimiento": userData.birthdate,
          "contrasena": userData.password,
        },
      );
      if (response.statusCode == 200) {
        dynamic body = jsonDecode(response.body);
        String data = body["respuesta"];
        String message = '';

        switch (data) {
          case 'empleadoNoExiste':
            message = 'El numero de empleado no existe.';
          case 'correoRegistrado':
            message = 'Ya existe una cuenta con el correo ingresado.';
          case 'numeroEmpleadoRegistrado':
            message = 'Ya existe una cuenta con el número de empleado ingresado.';
          case 'sincomunicacion':
            message = 'Ocurrió un error al comunicarse con la base de datos, intentelo más tarde.';
          case 'empleadoBaja':
            message = 'El numero de empleado ingresado se encuentra dado de baja.';
          case 'fechaNacimientoIncorrecta':
            message = 'La fecha de nacimiento ingresada no coincide con la registrada en la base de datos, verifique su información.';
          case 'registrado':
            message = 'registrado';
          default:
            message = 'Ocurrió un error al procesar los datos, intentelo más tarde.';
        }

        if(message != 'registrado'){
          throw Exception(message);
        }
        
        return true;

      } else {
        throw Exception('Ocurrió un error al procesar los datos, intentelo más tarde');
      }
    } on SocketException {
      throw Exception('No hay conexión a Internet. Por favor, revisa tu conexión.');
    }
    catch (e) {
      throw Exception(e.toString());
    }
  }

}