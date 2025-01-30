part of 'technical_assistance_login_bloc.dart';

@immutable
sealed class TechnicalAssistanceLoginEvent {}

class PostTechnicalAssistanceLogin extends TechnicalAssistanceLoginEvent {
  final String email;
  final String password;

  PostTechnicalAssistanceLogin({
    required this.email,
    required this.password,
  });
}

class TechnicalAssistanceLogout extends TechnicalAssistanceLoginEvent {}