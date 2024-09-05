import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_tracker/data/repositories/user_repository.dart';
import 'package:http/http.dart' as http;

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(http.Client());
});
