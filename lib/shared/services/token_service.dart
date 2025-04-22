import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TokenService {
  final _storage = const FlutterSecureStorage();
  final String baseUrl = 'helpdesk.playadelcarmen.gob.mx';

  Future<void> saveTokens(String shortToken, String longToken, [String? userDependency, String? userDependencyDirector]) async {
    await _storage.write(key: 'shortToken', value: shortToken);
    await _storage.write(key: 'longToken', value: longToken);
    userDependency != null ? await _storage.write(key: 'userDependency', value: userDependency) : null;
    userDependencyDirector != null ? await _storage.write(key: 'userDependencyDirector', value: userDependencyDirector) : null;
  }

  Future<void> saveTechniciansTokens(String shortToken, String longToken) async {
    await _storage.write(key: 'technicianShortToken', value: shortToken);
    await _storage.write(key: 'technicianLongToken', value: longToken);
  }

  Future<void> saveUserDependencyData([String? userDependency, String? userDependencyDirector]) async {
    userDependency != null ? await _storage.write(key: 'userDependency', value: userDependency) : null;
    userDependencyDirector != null ? await _storage.write(key: 'userDependencyDirector', value: userDependencyDirector) : null;
  }

  Future<void> saveUserEmail(String userEmail) async {
    await _storage.write(key: 'userEmail', value: userEmail);
  }

  Future<String?> getShortToken() async { 
    return await _storage.read(key: 'shortToken');
  }

  Future<String?> getLongToken() async {
    return await _storage.read(key: 'longToken');
  }

  Future<String?> getTechnicianShortToken() async { 
    return await _storage.read(key: 'technicianShortToken');
  }

  Future<String?> getTechnicianLongToken() async {
    return await _storage.read(key: 'technicianLongToken');
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: 'userEmail');
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<String?> renewShortToken( {bool isTechnician = false} ) async {
    final longToken = !isTechnician ? await getLongToken() : await getTechnicianLongToken();
    if (longToken == null) {
      return null;
    }

    final response = await http.post(
      Uri.https(baseUrl, '/apiHelpdeskDNTICS/administrador/refresh-token'),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $longToken',
      },
      body: jsonEncode({ 'refreshToken': longToken })
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final newShortToken = data['token'];
      !isTechnician ? await saveTokens(newShortToken, longToken) : await saveTechniciansTokens(newShortToken, longToken);
      return newShortToken;
    } else {
      await logout();
      return null;
    }
  }
}
