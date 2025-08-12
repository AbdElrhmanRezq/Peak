class SetModel {
  String? prev;
  double weight;
  int? reps;
  int? repRangeMin;
  int? repRangeMax;
  String type;

  SetModel({
    this.prev,
    this.weight = 50,
    this.reps = 10,
    this.repRangeMin = 8,
    this.repRangeMax = 12,
    this.type = "Reps",
  });

  SetModel copyWith({
    String? prev,
    double? weight,
    int? reps,
    int? repRangeMin,
    int? repRangeMax,
    String? type,
  }) {
    return SetModel(
      prev: prev ?? this.prev,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      repRangeMin: repRangeMin ?? this.repRangeMin,
      repRangeMax: repRangeMax ?? this.repRangeMax,
      type: type ?? this.type,
    );
  }
}
