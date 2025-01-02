import 'package:help_desk/internal/request/domain/entities/request.dart';

abstract class RequestRepository {
  Future<List<Request>> getRequests();
}