part of 'technical_assistance_login_bloc.dart';

@immutable
sealed class TechnicalAssistanceLoginState {}

final class TechnicalAssistanceLoginInitial extends TechnicalAssistanceLoginState {}

final class PostingTechnicalAssistanceLogin extends TechnicalAssistanceLoginState {}

final class TechnicalAssistanceLoginSuccess extends TechnicalAssistanceLoginState {}

final class ErrorPostingTechnicalAssistanceLogin extends TechnicalAssistanceLoginState {
  final String message;

  ErrorPostingTechnicalAssistanceLogin(this.message);
}

final class TechnicalAssistanceUnauthenticated extends TechnicalAssistanceLoginState {}