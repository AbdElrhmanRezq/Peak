import '../models/user_model.dart';
import '../services/supabase_service.dart';

class AuthRepository {
  final SupabaseService _supabaseService;

  AuthRepository(this._supabaseService);

  Future<UserModel?> login(String email, String password) async {
    final response = await _supabaseService.login(email, password);
    final user = response.user;

    if (user == null) return null;

    return UserModel(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['name'] ?? '',
    );
  }

  Future<UserModel?> signup(
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (password != confirmPassword) {
      throw Exception('Passwords do not match');
    }

    final response = await _supabaseService.signup(email, password);
    final user = response.user;

    if (user == null) return null;

    return UserModel(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['name'] ?? '',
    );
  }

  Future<void> logout() => _supabaseService.signOut();

  UserModel? get currentUser =>
      _supabaseService.supabase.auth.currentUser != null
      ? UserModel(
          id: _supabaseService.supabase.auth.currentUser!.id,
          email: _supabaseService.supabase.auth.currentUser!.email ?? '',
          name:
              _supabaseService
                  .supabase
                  .auth
                  .currentUser!
                  .userMetadata?['name'] ??
              '',
        )
      : null;

  Future<void> createUser(UserModel user) async {
    await _supabaseService.createUser(user);
  }
}
