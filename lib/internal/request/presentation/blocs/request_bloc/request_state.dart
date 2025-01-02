part of 'request_bloc.dart';

@immutable
sealed class RequestState {}

final class RequestInitial extends RequestState {}

final class PostingRequest extends RequestState {}

final class RequestSuccess extends RequestState {
  final List<Request> requests;

  RequestSuccess(this.requests);
}

final class ErrorPostingRequest extends RequestState {
  final String message;

  ErrorPostingRequest(this.message);
}