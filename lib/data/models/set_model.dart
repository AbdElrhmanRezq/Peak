class SetModel {
  double? prevWeight;
  double weight;
  int? reps;
  int? repRangeMin;
  int? repRangeMax;
  String type;
  SetModel({
    this.prevWeight,
    required this.weight,
    this.reps,
    this.repRangeMin,
    this.repRangeMax,
    required this.type,
  });
}
