part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class PostLogin extends LoginEvent {
  final String email;
  final String password;

  PostLogin({
    required this.email,
    required this.password,
  });
}

class Logout extends LoginEvent {}

class PostResetPassword extends LoginEvent {
  final String email;
  final String employeeNumber;

  PostResetPassword({
    required this.email,
    required this.employeeNumber,
  });
}
