part of 'delete_request_bloc.dart';

@immutable
sealed class DeleteRequestEvent {}

class DeleteRequest extends DeleteRequestEvent {
  final String requestId;

  DeleteRequest({
    required this.requestId,
  });
}
