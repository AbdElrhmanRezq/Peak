import 'package:repx/data/models/exercise_model.dart';
import 'package:repx/data/models/user_model.dart';
import 'package:repx/data/services/api_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiRepository {
  final apiService = ExerciseApiService();

  Future<List<String>> getTargetBodyParts() async {
    try {
      final dataList = await apiService.getTargetBodyParts();
      return dataList;
    } catch (e) {
      print('Error getting target body parts: $e');
      return [];
    }
  }

  Future<List<ExerciseModel>> getTargetBodyPartsExercises(
    String bodyPart,
    String page,
  ) async {
    try {
      final dataList = await apiService.getTargetBodyPartsExercises(
        bodyPart,
        page,
      );
      return dataList.map((json) => ExerciseModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      return [];
    } catch (e) {
      print('Unknown error: $e');
      return [];
    }
  }

  Future<List<ExerciseModel>> getSearchedExercises(String searchText) async {
    try {
      final dataList = await apiService.getSearchedExercises(searchText);
      return dataList.map((json) => ExerciseModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      return [];
    } catch (e) {
      print('Unknown error: $e');
      return [];
    }
  }
}
