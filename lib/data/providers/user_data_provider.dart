import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/user_model.dart';
import 'package:repx/data/providers/auth_providers.dart';
import 'package:repx/data/repository/user_repository.dart';

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

final followStatusProvider = FutureProvider.family<bool, String>((
  ref,
  userId,
) async {
  final repo = ref.watch(userRepositoryProvider);
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null) return false;

  return await repo.isUserFollowed(currentUser.id, userId);
});

final searchTextProvider = StateProvider<String>((ref) => "");

final profileUserProvider = FutureProvider.family<UserModel, String?>((
  ref,
  userId,
) async {
  final repo = ref.watch(userRepositoryProvider);

  if (userId == null) {
    final currentUser = ref.watch(currentUserProvider);
    if (currentUser == null) throw Exception("No logged-in user found");

    final user = await repo.getUserById(currentUser.id);
    if (user == null) throw Exception("User not found");
    return user;
  } else {
    final user = await repo.getUserById(userId);
    if (user == null) throw Exception("User not found");
    return user;
  }
});
final friendsProvider = FutureProvider.family<List<UserModel>, String>((
  ref,
  userId,
) async {
  final userRepo = ref.watch(userRepositoryProvider);

  final userFollowers = await userRepo.getUserFollowers(userId);
  final userFollowings = await userRepo.getUserFollowings(userId);

  final allFriends = [...userFollowers, ...userFollowings];

  final uniqueFriends = {
    for (var user in allFriends) user.id: user,
  }.values.toList();

  if (uniqueFriends.isEmpty) {
    throw Exception('No friends found');
  }

  return uniqueFriends;
});

final createdUserProvider = StateProvider<UserModel>(
  (ref) => UserModel(id: ' ', email: ' '),
);
final passwordProvider = StateProvider<String>((ref) => ' ');

final suggestedFriendsProvider = FutureProvider<List<UserModel>>((ref) async {
  final repo = ref.watch(userRepositoryProvider);
  final suggestedFriends = await repo.getSuggestedFriends();
  return suggestedFriends;
});
