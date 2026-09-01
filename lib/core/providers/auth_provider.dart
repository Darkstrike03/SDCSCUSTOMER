import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoggedIn;
  final String? email;
  final String? name;
  final bool isVerifying;

  const AuthState({
    this.isLoggedIn = false,
    this.email,
    this.name,
    this.isVerifying = false,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? email,
    String? name,
    bool? isVerifying,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      email: email ?? this.email,
      name: name ?? this.name,
      isVerifying: isVerifying ?? this.isVerifying,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    state = state.copyWith(isLoggedIn: true, email: email, name: email.split('@').first);
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(email: email, name: name, isVerifying: true);
    return true;
  }

  Future<bool> verifyEmail(String code) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (code.length == 6) {
      state = state.copyWith(isLoggedIn: true, isVerifying: false);
      return true;
    }
    return false;
  }

  void logout() {
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
