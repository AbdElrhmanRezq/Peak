import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<AuthResponse> login(String email, String password) {
    return supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signup(String email, String password) {
    return supabase.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() {
    return supabase.auth.signOut();
  }

  Future<User?> get currentUser async {
    final session = supabase.auth.currentSession;
    return session?.user;
  }
}
