import 'dart:convert';
import 'package:http/http.dart' as http;

class ExerciseApiService {
  final String apiKey = '5cdaa879c4msh1d58221fdeb82b7p1d41d3jsn3035b3a57966';

  Future<List<String>> getTargetMuscles() async {
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

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception('Failed to load target muscles');
    }
  }
}
