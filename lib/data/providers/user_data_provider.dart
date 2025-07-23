import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/user_model.dart';
import 'package:repx/data/providers/auth_providers.dart';
import 'package:repx/data/repository/user_repository.dart';
import 'package:repx/data/services/supabase_service.dart';
import 'package:repx/data/repository/auth_repository.dart';

final userDataProvider = FutureProvider<UserModel>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final currentUserId = authRepo.currentUser?.id;
  print('Current user ID: $currentUserId');

  if (currentUserId == null) {
    throw Exception('No user is currently logged in');
  }

  final userRepo = SupabaseUserRepository();
  final user = await userRepo.getUserById(currentUserId);
  print('Fetched user: $user');

  if (user == null) {
    throw Exception('User not found in database');
  }

  return user;
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

final searchedUserProvider = StateProvider<UserModel?>((ref) => null);
