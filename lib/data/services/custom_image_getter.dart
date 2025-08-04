String getExerciseGifUrl(String exerciseId, {int resolution = 180}) {
  const String apiKey = '44c38561c2mshf6844ae156474c6p1d46e9jsn1bc156a74ea9'; //
  return 'https://exercisedb.p.rapidapi.com/image'
      '?exerciseId=$exerciseId'
      '&resolution=$resolution'
      '&rapidapi-key=$apiKey';
}
