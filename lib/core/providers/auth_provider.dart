import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthState {
  const AuthState();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final String userId;
  final String email;

  const AuthAuthenticated({required this.userId, required this.email});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SupabaseClient _supabase;

  AuthNotifier(this._supabase) : super(const AuthLoading()) {
    _init();
  }

  void _init() {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      state = AuthAuthenticated(
        userId: session.user.id,
        email: session.user.email ?? '',
      );
    } else {
      state = const AuthUnauthenticated();
    }

    _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        state = AuthAuthenticated(
          userId: session.user.id,
          email: session.user.email ?? '',
        );
      } else {
        state = const AuthUnauthenticated();
      }
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AuthLoading();
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      state = const AuthUnauthenticated();
      rethrow;
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    state = const AuthLoading();
    try {
      await _supabase.auth.signUp(email: email, password: password);
    } catch (e) {
      state = const AuthUnauthenticated();
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AuthLoading();
    try {
      // Implement specific Google auth logic
    } catch (e) {
      state = const AuthUnauthenticated();
      rethrow;
    }
  }

  Future<void> signInWithApple() async {
    state = const AuthLoading();
    try {
      // Implement specific Apple auth logic
    } catch (e) {
      state = const AuthUnauthenticated();
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = const AuthLoading();
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      // Handle error or force unauthenticated
      state = const AuthUnauthenticated();
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }
}

final supabaseProvider = Provider<SupabaseClient>((ref) => Supabase.instance.client);

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(supabaseProvider));
});
