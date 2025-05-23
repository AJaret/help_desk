import 'dart:convert';

import 'package:help_desk/shared/services/token_service.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final TokenService authService = TokenService();

  Future<http.Response> sendRequest(String endpoint, int requestType, {Map<String, dynamic>? body, bool isTechnician = false}) async {
    String? token = isTechnician ? await authService.getTechnicianShortToken() : await authService.getShortToken();

    if (token == null) {
      token = await authService.renewShortToken(isTechnician: isTechnician);
      if (token == null) {
        return http.Response('Unauthorized', 401);
      }
    }

    dynamic response;

    switch (requestType) {
      case 1:
        response = await http.get(
          Uri.parse(endpoint),
          headers: {'Authorization': 'Bearer $token'},
        );
      break;

      case 2:
        final headers = {
          'Authorization': 'Bearer $token',
          if (body != null) 'Content-Type': 'application/json',
        };

        response = await http.post(
          Uri.parse(endpoint),
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
      break;
      default:
    }

    if (response.statusCode == 401) {
      token = await authService.renewShortToken(isTechnician: isTechnician);
      if (token != null) {
        return await http.get(
          Uri.parse(endpoint),
          headers: {'Authorization': 'Bearer $token'},
        );
      }
    }

    return response;
  }
}
