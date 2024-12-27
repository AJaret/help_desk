part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class PostingLogin extends LoginState {}

final class LoginSuccess extends LoginState {}

final class ErrorPostingLogin extends LoginState {
  final String message;

  ErrorPostingLogin(this.message);
}