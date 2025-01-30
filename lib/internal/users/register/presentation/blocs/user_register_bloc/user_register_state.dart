part of 'user_register_bloc.dart';

@immutable
sealed class UserRegisterState {}

final class UserRegisterInitial extends UserRegisterState {}

final class PostingUserRegister extends UserRegisterState {}

final class UserRegisterPosted extends UserRegisterState {
  final bool response;

  UserRegisterPosted(this.response);
}

final class ErrorPostingUserRegister extends UserRegisterState{
  final String message;

  ErrorPostingUserRegister(this.message);
}
