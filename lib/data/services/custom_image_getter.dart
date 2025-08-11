import 'package:flutter_dotenv/flutter_dotenv.dart';

String getExerciseGifUrl(String exerciseId, {int resolution = 180}) {
  final String apiKey = dotenv.env['RAPIDAPI_KEY'] ?? '';
  return 'https://exercisedb.p.rapidapi.com/image'
      '?exerciseId=$exerciseId'
      '&resolution=$resolution'
      '&rapidapi-key=$apiKey';
}
