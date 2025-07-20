import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/user_model.dart';
import 'package:repx/data/services/supabase_service.dart';
import 'package:repx/data/repository/auth_repository.dart';

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabase = ref.read(supabaseServiceProvider);
  return AuthRepository(supabase);
});

final loginLoadingProvider = StateProvider<bool>((ref) => false);

final currentUserProvider = StateProvider<UserModel?>((ref) {
  final auth = ref.read(authRepositoryProvider);
  return auth.currentUser;
});
