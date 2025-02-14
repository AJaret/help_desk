part of 'delete_request_bloc.dart';

@immutable
sealed class DeleteRequestState {}

final class DeleteRequestInitial extends DeleteRequestState {}

final class DeletingRequest extends DeleteRequestState {}

final class DeleteRequestSuccess extends DeleteRequestState {}

final class ErrorDeletingRequest extends DeleteRequestState {
  final String message;

  ErrorDeletingRequest(this.message);
}