part of 'request_bloc.dart';

@immutable
sealed class RequestEvent {}

class GetRequests extends RequestEvent {
  final String? filter;

  GetRequests({
    this.filter,
  });
}

class PostNewRequest extends RequestEvent {
  final NewRequest requestData;

  PostNewRequest({
    required this.requestData,
  });
}

class DeleteRequest extends RequestEvent {
  final String requestId;

  DeleteRequest({
    required this.requestId,
  });
}
