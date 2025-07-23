import 'package:repx/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseUserRepository {
  final supabase = Supabase.instance.client;

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final data = await supabase
          .from('users')
          .select()
          .eq('email', email)
          .single();
      return UserModel.fromJson(data);
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      return null;
    } catch (e) {
      print('Unknown error: $e');
      return null;
    }
  }

  Future<UserModel?> getUserById(String id) async {
    try {
      final data = await supabase.from('users').select().eq('id', id).single();
      print('Fetched user data: $data');
      return UserModel.fromJson(data);
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      return null;
    } catch (e) {
      print('Unknown error: $e');
      return null;
    }
  }

  Future<UserModel?> getUserByUsernameOrPhone(String text) async {
    try {
      final data = await supabase
          .from('users')
          .select()
          .or('username.ilike.$text,phone_number.eq.$text')
          .limit(1)
          .maybeSingle();

      if (data != null) {
        print('Fetched user data: $data');
        return UserModel.fromJson(data);
      } else {
        print('No matching user found.');
        return null;
      }
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      return null;
    } catch (e) {
      print('Unknown error: $e');
      return null;
    }
  }

  Future<void> updateUser(UserModel user) async {
    print('Updating user: ${user.toJson()}============================');
    try {
      final updatedUser = await supabase
          .from('users')
          .update(user.toJson())
          .eq('email', user.email as String)
          .select();

      print('Updated user: $updatedUser');
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<List<UserModel>> getUserFollowers(String id) async {
    List<UserModel> followers = [];
    try {
      final data = await supabase
          .from('follows')
          .select()
          .eq('followed_id', id);

      if (data != null) {
        for (var item in data) {
          final user = await getUserById(item['follower_id']);
          if (user != null) {
            followers.add(user);
          }
        }
      }
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
    } catch (e) {
      print('Unknown error: $e');
    }
    return followers;
  }

  Future<List<UserModel>> getUserFollowings(String id) async {
    List<UserModel> followings = [];
    try {
      final data = await supabase
          .from('follows')
          .select()
          .eq('follower_id', id);

      if (data != null) {
        for (var item in data) {
          final user = await getUserById(item['followed_id']);
          if (user != null) {
            followings.add(user);
          }
        }
      }
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
    } catch (e) {
      print('Unknown error: $e');
    }
    return followings;
  }

  Future<bool> isUserFollowed(String followerId, String followedId) async {
    try {
      final data = await supabase
          .from('follows')
          .select()
          .eq('follower_id', followerId)
          .eq('followed_id', followedId)
          .maybeSingle();

      print('Fetched follow data: $data');

      return data != null;
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      return false;
    } catch (e) {
      print('Unknown error: $e');
      return false;
    }
  }

  Future<void> followUser(String followerId, String followedId) async {
    try {
      await supabase.from('follows').insert([
        {'follower_id': followerId, 'followed_id': followedId},
      ]);

      print('Inserted User');
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }

  Future<void> unfollowUser(String followerId, String followedId) async {
    try {
      await supabase
          .from('follows')
          .delete()
          .eq('follower_id', followerId)
          .eq('followed_id', followedId);

      print('Deleted User');
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw e;
    } catch (e) {
      print('Unknown error: $e');
      throw e;
    }
  }
}
