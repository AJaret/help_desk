part of 'request_details_bloc.dart';

@immutable
sealed class RequestDetailsEvent {}

class GetRequestById extends RequestDetailsEvent {
  final String requestId;

  GetRequestById({
    required this.requestId,
  });
}

class GetDocumentFile extends RequestDetailsEvent {
  final int documentId;

  GetDocumentFile({
    required this.documentId,
  });
}
