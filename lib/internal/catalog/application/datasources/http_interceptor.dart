import 'package:help_desk/internal/catalog/application/services/token_service.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final TokenService authService = TokenService();

  Future<http.Response> getRequest(String endpoint) async {
    String? token = await authService.getShortToken();

    if (token == null) {
      token = await authService.renewShortToken();
      if (token == null) {
        return http.Response('Unauthorized', 401);
      }
    }

    final response = await http.get(
      Uri.parse(endpoint),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 401) {
      token = await authService.renewShortToken();
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
