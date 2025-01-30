
import 'package:help_desk/internal/users/register/domain/entities/user_register.dart';

class UserRegisterModel extends UserRegister {
  UserRegisterModel({
    super.employeeNumber,
    super.birthdate,
    super.entityId,
    super.email,
    super.password
  });

  factory UserRegisterModel.fromEntity(UserRegister user) {
    return UserRegisterModel(
      employeeNumber: user.employeeNumber,
      birthdate: user.birthdate,
      entityId: user.entityId,
      email: user.email,
      password: user.password
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numeroEmpleado': employeeNumber,
      'fechaNacimiento': birthdate,
      'entidad': entityId,
      'correo': email,
      'contrasena': password,
    };
  }
}
