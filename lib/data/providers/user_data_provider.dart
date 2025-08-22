import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/user_model.dart';
import 'package:repx/data/providers/auth_providers.dart';
import 'package:repx/data/repository/user_repository.dart';
import 'package:repx/data/services/supabase_service.dart';
import 'package:repx/data/repository/auth_repository.dart';

final userDataProvider = FutureProvider<UserModel>((ref) async {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null) {
    throw Exception("No user found");
  }

  final repo = ref.watch(userRepositoryProvider);
  final user = await repo.getUserById(currentUser.id);
  return user as UserModel;
});

final isLoadingProvider = StateProvider<bool>((ref) => false);

final userRepositoryProvider = Provider<SupabaseUserRepository>((ref) {
  //final supabaseService = ref.watch(supabaseServiceProvider);
  return SupabaseUserRepository();
});

final publicUserProvider = FutureProvider.family<UserModel, String>((
  ref,
  userId,
) async {
  final userRepo = ref.watch(userRepositoryProvider);
  final user = await userRepo.getUserById(userId);

  if (user == null) {
    throw Exception('User not found');
  }

  return user;
});

final searchedUserProvider = StateProvider<List<UserModel?>>((ref) => []);

final followStatusProvider = StateProvider.family<bool, String>((ref, userId) {
  return false;
});

final searchTextProvider = StateProvider<String>((ref) => "");
