import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_tracker/data/repositories/user_repository.dart';
import 'package:personal_tracker/domain/entities/reg_user_model.dart';
import 'package:personal_tracker/provider/user_Repository_provider.dart';

class RegistrationNotifier extends Notifier<RegistrationState> {
  late final UserRepository _userRepository;

  @override
  RegistrationState build() {
    _userRepository = ref.watch(userRepositoryProvider);
    return RegistrationState.initial();
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
  }

  bool validateFields() {
    if (state.name.isEmpty ||
        state.email.isEmpty ||
        state.password.isEmpty ||
        state.confirmPassword.isEmpty) {
      state = state.copyWith(errorMessage: 'All fields are required');
      return false;
    }
    if (!state.email.contains('@')) {
      state = state.copyWith(errorMessage: 'Invalid email');
      return false;
    }
    if (state.password != state.confirmPassword) {
      state = state.copyWith(errorMessage: 'Passwords do not match');
      return false;
    }
    return true;
  }

  void logoutUser() {
    state = RegistrationState.initial();
  }

  Future<void> registerUser() async {
    if (!validateFields()) {
      return;
    }
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    final user = RegUserModel(
      name: state.name,
      email: state.email,
      password: state.password,
    );

    try {
      final response = await _userRepository.registerUser(user);
      if (response.success) {
        state = RegistrationState.success(userId: user.userId);
      } else {
        String? errorMsg = response.error;
        if (errorMsg == 'Email is already registered') {
          errorMsg =
              'This email is already in use. Please use a different email.';
        }
        state = state.copyWith(isLoading: false, errorMessage: errorMsg);
      }
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          errorMessage: 'An error occurred. Please try again.');
    }
  }
}

class RegistrationState {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isLoading;
  final String? errorMessage;
  final bool isRegistered;
  final String? userId;

  RegistrationState({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.isLoading,
    this.errorMessage,
    this.userId,
    required this.isRegistered,
  });

  factory RegistrationState.initial() {
    return RegistrationState(
      name: '',
      email: '',
      password: '',
      confirmPassword: '',
      isLoading: false,
      isRegistered: false,
      userId: null,
    );
  }

  factory RegistrationState.success({String? userId}) {
    return RegistrationState(
      name: '',
      email: '',
      password: '',
      confirmPassword: '',
      isLoading: false,
      isRegistered: true,
      userId: userId,
    );
  }

  RegistrationState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isLoading,
    String? errorMessage,
    bool? isRegistered,
  }) {
    return RegistrationState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isRegistered: isRegistered ?? this.isRegistered,
    );
  }
}

final registrationNotifierProvider =
    NotifierProvider<RegistrationNotifier, RegistrationState>(() {
  return RegistrationNotifier();
});
