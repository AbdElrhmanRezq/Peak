import 'dart:convert';
import 'package:http/http.dart' as http;

class ExerciseApiService {
  final String apiKey = '44c38561c2mshf6844ae156474c6p1d46e9jsn1bc156a74ea9';

  Future<List<String>> getTargetBodyParts() async {
    final url = Uri.parse(
      'https://exercisedb.p.rapidapi.com/exercises/bodyPartList',
    );

    final response = await http.get(
      url,
      headers: {
        'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com',
        'X-RapidAPI-Key': apiKey,
      },
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
    String page,
  ) async {
    final offset = ((int.parse(page) - 1) * 10).toString();
    final url = Uri.parse(
      'https://exercisedb.p.rapidapi.com/exercises/bodyPart/${bodyPart}?limit=10&offset=${offset}',
    );

    final response = await http.get(
      url,
      headers: {
        'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com',
        'X-RapidAPI-Key': apiKey,
      },
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
    final url = Uri.parse(
      'https://exercisedb.p.rapidapi.com/exercises/name/${searchText}',
    );

    final response = await http.get(
      url,
      headers: {
        'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com',
        'X-RapidAPI-Key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load exercises');
    }
  }
}
