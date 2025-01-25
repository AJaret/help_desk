part of 'request_bloc.dart';

@immutable
sealed class RequestState {}

final class RequestInitial extends RequestState {}

final class GettingRequests extends RequestState {}

final class PostingNewRequest extends RequestState {}

final class DeletingRequest extends RequestState {}

final class GetRequestSuccess extends RequestState {
  final List<Request> requests;

  GetRequestSuccess(this.requests);
}

final class PostRequestSuccess extends RequestState {
  final String folio;

  PostRequestSuccess(this.folio);
}

final class DeleteRequestSuccess extends RequestState {}

final class ErrorGettingRequests extends RequestState {
  final String message;

  ErrorGettingRequests(this.message);
}

final class ErrorPostingRequest extends RequestState {
  final String message;

  ErrorPostingRequest(this.message);
}

final class ErrorDeletingRequest extends RequestState {
  final String message;

  ErrorDeletingRequest(this.message);
}