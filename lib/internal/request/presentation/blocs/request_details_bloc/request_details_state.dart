part of 'request_details_bloc.dart';

@immutable
sealed class RequestDetailsState {}

final class RequestDetailsInitial extends RequestDetailsState {}

final class GettingRequestDetails extends RequestDetailsState {}

final class RequestDetailsSuccess extends RequestDetailsState {
  final RequestFull request;

  RequestDetailsSuccess(this.request);
}

final class ErrorGettingRequestDetails extends RequestDetailsState {
  final String message;

  ErrorGettingRequestDetails(this.message);
}