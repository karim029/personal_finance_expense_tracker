import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:personal_tracker/domain/entities/reg_user_model.dart';
import 'package:personal_tracker/domain/entities/signin_user_model.dart';

final url = 'http://localhost:3000/';
final registration = url + 'users/registration';
final logIn = url + 'users/login';

class UserRepository {
  final http.Client _client;

  UserRepository(this._client);

  // call the api from the backend using http post request
  // method for registration
  Future<RegistrationResponse> registerUser(RegUserModel user) async {
    final response = await _client.post(
      Uri.parse(registration),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'userId': user.userId,
      }),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return RegistrationResponse(success: true);
    } else if (response.statusCode == 400) {
      return RegistrationResponse(success: false, error: body['error']!);
    } else {
      return RegistrationResponse(
          success: false, error: body['error'] ?? 'Registration failed');
    }
  }

  // method for signing in
  Future<SignInResponse> signInUser(SignInUserModel signedUser) async {
    final response = await _client.post(
      Uri.parse(logIn),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': signedUser.signInUserEmail,
        'password': signedUser.signInPass,
      }),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return SignInResponse(
          success: true,
          userId: body['user']['userId'],
          name: body['user']['name']);
    } else if (response.statusCode == 404) {
      return SignInResponse(success: false, error: body['error']);
    } else if (response.statusCode == 401) {
      return SignInResponse(success: false, error: body['error']);
    } else {
      return SignInResponse(
          success: false,
          error: body['error'] ?? 'Login failed... try again later');
    }
  }
}

class SignInResponse {
  final bool success;
  final String? error;
  final String? userId;
  final String? name;

  SignInResponse({required this.success, this.error, this.userId, this.name});
}

class RegistrationResponse {
  final bool success;
  final String? error;

  RegistrationResponse({required this.success, this.error});
}
