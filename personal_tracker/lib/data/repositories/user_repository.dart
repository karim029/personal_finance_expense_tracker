import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:personal_tracker/domain/entities/reg_user_model.dart';
import 'package:personal_tracker/domain/entities/signin_user_model.dart';

const url = 'http://localhost:3000/';
const registration = '${url}users/registration';
const logIn = '${url}users/login';
const verification = '${url}users/check-verification';
const resendVerification = '${url}users/resend-verification';
const requestResetCode = '${url}users/request-reset-code';

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
    print(response.statusCode);
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

  Future<bool> checkEmailVerification(String userId) async {
    final response = await _client.post(
      Uri.parse(verification),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
      }),
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return body['isVerified'];
  }

  Future<verificationResponse> resendVerificationEmail(String userId) async {
    final response = await _client.post(
      Uri.parse(resendVerification),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
      }),
    );

    final body = jsonDecode(response.body);
    if (response.statusCode == 400) {
      return verificationResponse(success: false, message: body['message']);
    }
    if (response.statusCode == 200) {
      return verificationResponse(success: true, message: body['message']);
    }
    return verificationResponse(
        success: false,
        message: 'An error has occured. Please try again later');
  }

  Future<verificationResponse> requestPassResetCode(String email) async {
    final response = await _client.post(
      Uri.parse(requestResetCode),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
      }),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return verificationResponse(success: true, message: body['message']);
    } else {
      return verificationResponse(success: false, message: body['message']);
    }
  }
}

class verificationResponse {
  final bool success;
  final String message;

  verificationResponse({required this.success, required this.message});
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
