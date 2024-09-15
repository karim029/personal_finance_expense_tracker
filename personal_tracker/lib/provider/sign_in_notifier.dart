import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_tracker/data/repositories/user_repository.dart';
import 'package:personal_tracker/domain/entities/signin_user_model.dart';
import 'package:personal_tracker/provider/user_Repository_provider.dart';

class SignInNotifier extends Notifier<SignInState> {
  late final UserRepository _userRepository;
  SignInUserModel user = SignInUserModel(
    signInUserEmail: '',
    signInPass: '',
  );
  @override
  SignInState build() {
    _userRepository = ref.watch(userRepositoryProvider);
    return SignInState.initial();
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  bool validateFields() {
    if (state.email.isEmpty || state.password.isEmpty) {
      state = state.copyWith(errorMessage: 'All fields are required');
      return false;
    }
    if (!state.email.contains('@')) {
      state = state.copyWith(errorMessage: 'Invalid email');
      return false;
    }
    return true;
  }

  void logoutUser() {
    state = SignInState.initial();
  }

  Future<void> signInUser() async {
    if (!validateFields()) {
      return;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);

    user = SignInUserModel(
      signInUserEmail: state.email,
      signInPass: state.password,
    );

    try {
      final response = await _userRepository.signInUser(user);
      print(response.success);
      if (response.success) {
        // take the userid from the response body
        state = SignInState.success(
          name: response.name,
          userId: response.userId,
        );
      } else {
        state = state.copyWith(
            isLoading: false, errorMessage: response.error, isSignedIn: false);
      }
    } catch (e) {
      print(e.toString());
      state = state.copyWith(
          isLoading: false,
          errorMessage: 'An error occurred. Please try again.');
    }
  }
}

class SignInState {
  final String email;
  final String password;
  final bool isLoading;
  final String? errorMessage;
  final bool isSignedIn;
  final String? name;
  String? userId;

  SignInState(
      {required this.email,
      required this.password,
      required this.isLoading,
      this.errorMessage,
      required this.isSignedIn,
      this.name,
      this.userId});

  factory SignInState.initial() {
    return SignInState(
      email: '',
      password: '',
      isLoading: false,
      isSignedIn: false,
    );
  }

  factory SignInState.success({String? userId, String? name}) {
    return SignInState(
      email: '',
      password: '',
      isLoading: false,
      isSignedIn: true,
      userId: userId,
      name: name,
    );
  }

  SignInState copyWith(
      {String? email,
      String? password,
      String? name,
      bool? isLoading,
      bool? isSignedIn,
      String? errorMessage,
      String? userId}) {
    return SignInState(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        isLoading: isLoading ?? this.isLoading,
        isSignedIn: isSignedIn ?? this.isSignedIn,
        errorMessage: errorMessage ?? this.errorMessage,
        userId: userId ?? this.userId);
  }
}

final signInNotifierProvider =
    NotifierProvider<SignInNotifier, SignInState>(() {
  return SignInNotifier();
});
