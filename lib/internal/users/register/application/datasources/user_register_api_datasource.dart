import 'dart:convert';
import 'dart:io';

import 'package:help_desk/internal/users/register/application/models/user_register_model.dart';
import 'package:help_desk/internal/users/register/domain/entities/user_register.dart';
import 'package:help_desk/internal/users/register/domain/repositories/user_register_repository.dart';
import 'package:http/http.dart' as http;

class UserRegisterApiDatasourceImp implements UserRegisterRepository{
  String urlApi = "test-helpdesk.gobiernodesolidaridad.gob.mx";
  
  @override
  Future<bool> postUser({required UserRegister userData}) async{
    try {
      var url = Uri.http(urlApi, '/apiHelpdeskDNTICS/administrador/crear-cuenta');
      var response = await http.post(
        url,
        body: UserRegisterModel.fromEntity(userData).toJson(),
      );
      dynamic body = jsonDecode(response.body);
      if (response.statusCode == 200) {
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