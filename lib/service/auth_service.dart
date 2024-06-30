import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kueku/dto/profile.dart';
import 'package:kueku/endpoints/kue.dart';

class AuthService {
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> _saveToken(token, role) async {
    await _secureStorage.delete(key: 'jwt_token');
    await _secureStorage.delete(key: 'role');
    await _secureStorage.write(key: 'jwt_token', value: token);
    await _secureStorage.write(key: 'role', value: role);
  }

  static Future<String> login(
      {required String email, required String password}) async {
    final response = await http.post(
      Uri.parse(Endpoints.login),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );
    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String token = responseData['token'];

        String userRole = responseData['role'];
        await _saveToken(token, userRole);

        return userRole;
      }
      return '';
    } on JWTNotActiveException {
      print('JWT Not Active Login again!!');
      throw Exception('JWT not active');
    } catch (e) {
      print(e);
      throw Exception('Failed to login');
    }
  }

  static Future<Profile> getProfile() async {
    var token = await _secureStorage.read(key: 'jwt_token');
    print(token);
    final response = await http.get(Uri.parse(Endpoints.profile), headers: {
      'Authorization': 'Bearer $token',
    });

    // final response = await http.get(Uri.parse(Endpoints.orders));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final responseData = jsonResponse['data'];
      print(responseData);
      return Profile.fromJson(responseData);
    } else {
      throw Exception('Failed to load profile data');
    }
  }

  static Future logout() async {
    var token = await _secureStorage.read(key: 'jwt_token');
    final response = await http.get(Uri.parse(Endpoints.logout), headers: {
      'Authorization': 'Bearer $token',
    });

    await _secureStorage.delete(key: 'jwt_token');
    await _secureStorage.delete(key: 'role');
  }
}
