part of 'user_register_bloc.dart';

@immutable
sealed class UserRegisterEvent {}

class PostUserRegister extends UserRegisterEvent{
  final UserRegister userData;

  PostUserRegister({required this.userData});
}
