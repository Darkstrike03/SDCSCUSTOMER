import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

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
  }) =>
      AuthState(
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        email: email ?? this.email,
        name: name ?? this.name,
        isVerifying: isVerifying ?? this.isVerifying,
      );
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _syncWithSupabase();
  }

  GoTrueClient get _auth => Supabase.instance.client.auth;

  void _syncWithSupabase() {
    try {
      // Reflect current session immediately.
      _refreshFromSession(Supabase.instance.client.auth.currentSession);

      // Keep state in sync as the session changes (login, logout, OTP confirm).
      Supabase.instance.client.auth.onAuthStateChange.listen((authState) {
        _refreshFromSession(authState.session);
      });
    } catch (_) {
      // Supabase not initialized (e.g. in tests or missing --dart-define).
      // State stays AuthState() — logged out.
    }
  }

  void _refreshFromSession(Session? session) {
    final user = session?.user;
    final meta = user?.userMetadata;
    final name =
        (meta?['full_name'] ?? meta?['name'] ?? meta?['first_name'] ?? '')
            as String?;

    state = AuthState(
      isLoggedIn: session != null,
      email: user?.email,
      name: name,
    );
  }

  // -----------------------------------------------------------------------
  // Register
  // -----------------------------------------------------------------------

  /// Start email+password sign-up. Returns true if the user is now signed in
  /// (i.e. email confirmation is disabled), otherwise false (needs OTP verify).
  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await _auth.signUp(
        email: email.trim(),
        password: password,
        data: {'full_name': name.trim()},
      );
      final session = response.session;
      if (session != null) {
        _refreshFromSession(session);
        return true;
      }
      // Email confirmation enabled -> awaiting OTP verification.
      state = state.copyWith(
        email: email.trim(),
        name: name.trim(),
        isVerifying: true,
      );
      return false;
    } on AuthException {
      rethrow;
    }
  }

  // -----------------------------------------------------------------------
  // Verify email (OTP path)
  // -----------------------------------------------------------------------

  /// Allow the user to give consent via the 6-digit OTP path.
  /// In this build email+password now relies on direct confirmation; this
  /// method verifies an OTP (part of the passwordless/confirm flow) and, if it
  /// produces a real session, marks the user signed in.
  Future<bool> verifyEmail(String code) async {
    final email = state.email;
    if (email == null) return false;

    try {
      final response = await _auth.verifyOTP(
        type: OtpType.email,
        email: email,
        token: code,
      );
      if (response.session != null) {
        _refreshFromSession(response.session);
        return true;
      }
      // OTP verified but no session (edge case) – treat as needing nothing.
      return false;
    } on AuthException {
      return false;
    }
  }

  /// Re-send the confirmation OTP to the user's email.
  Future<void> resendVerification() async {
    final email = state.email;
    if (email == null) return;
    try {
      await _auth.signInWithOtp(email: email);
    } on AuthException {
      // Ignore – user can retry.
    }
  }

  // -----------------------------------------------------------------------
  // Login
  // -----------------------------------------------------------------------

  Future<bool> login(String email, String password) async {
    try {
      final response = await _auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      _refreshFromSession(response.session);
      return true;
    } on AuthException {
      rethrow;
    }
  }

  // -----------------------------------------------------------------------
  // Logout
  // -----------------------------------------------------------------------

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (_) {
      // ignore network errors – local state reset below regardless.
    }
    state = const AuthState();
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});