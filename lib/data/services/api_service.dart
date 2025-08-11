import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ExerciseApiService {
  final String apiKey = dotenv.env['RAPIDAPI_KEY'] ?? '';
  final String baseURL = dotenv.env['EXERCISE_API_BASE_URL'] ?? '';
  final String rapidAPIHost = dotenv.env['RAPIDAPI_HOST'] ?? '';

  Future<List<String>> getTargetBodyParts() async {
    final url = Uri.parse('${baseURL}exercises/bodyPartList');

    final response = await http.get(
      url,
      headers: {'X-RapidAPI-Host': rapidAPIHost, 'X-RapidAPI-Key': apiKey},
    );
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception('Failed to load target muscles');
    }
  }

  Future<List<Map<String, dynamic>>> getTargetBodyPartsExercises(
    String bodyPart,
    String page, {
    int limit = 10,
  }) async {
    final offset = ((int.parse(page) - 1) * 10).toString();
    final url = Uri.parse(
      '${baseURL}exercises/bodyPart/${bodyPart}?limit=${limit.toString()}&offset=${offset}',
    );

    final response = await http.get(
      url,
      headers: {'X-RapidAPI-Host': rapidAPIHost, 'X-RapidAPI-Key': apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  Future<List<Map<String, dynamic>>> getExercises({int limit = 10}) async {
    final url = Uri.parse('${baseURL}exercises?limit=$limit');

    final response = await http.get(
      url,
      headers: {'X-RapidAPI-Host': rapidAPIHost, 'X-RapidAPI-Key': apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  Future<List<Map<String, dynamic>>> getSearchedExercises(
    String searchText,
  ) async {
    final url = Uri.parse('${baseURL}exercises/name/${searchText}');

    final response = await http.get(
      url,
      headers: {'X-RapidAPI-Host': rapidAPIHost, 'X-RapidAPI-Key': apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load exercises');
    }
  }
}
