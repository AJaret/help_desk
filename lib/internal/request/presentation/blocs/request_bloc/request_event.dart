part of 'request_bloc.dart';

@immutable
sealed class RequestEvent {}

class PostRequest extends RequestEvent {
  final String? filter;

  PostRequest({
    this.filter,
  });
}
