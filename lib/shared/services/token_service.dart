import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TokenService {
  final _storage = const FlutterSecureStorage();
  final String baseUrl = 'https://soportetecnico.gobiernodesolidaridad.gob.mx';

  Future<void> saveTokens(String shortToken, String longToken) async {
    await _storage.write(key: 'shortToken', value: shortToken);
    await _storage.write(key: 'longToken', value: longToken);
  }

  Future<String?> getShortToken() async {
    return await _storage.read(key: 'shortToken');
  }

  Future<String?> getLongToken() async {
    return await _storage.read(key: 'longToken');
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

    Future<String?> renewShortToken() async {
      final longToken = await getLongToken();
      if (longToken == null) {
        return null;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/apiHelpdeskDNTICS/administrador/refresh-token'),
        body: {
          'refreshToken': longToken,
        }
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newShortToken = data['token'];
        await saveTokens(newShortToken, longToken);
        return newShortToken;
      } else {
        await logout();
        return null;
      }
    }
}
