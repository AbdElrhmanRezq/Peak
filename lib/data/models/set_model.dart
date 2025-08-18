class SetModel {
  String? prev;
  double weight;
  int? reps;
  int? repRangeMin;
  int? repRangeMax;
  String type;
  int? id;

  SetModel({
    this.prev,
    this.weight = 50,
    this.reps = 10,
    this.repRangeMin = 8,
    this.repRangeMax = 12,
    this.type = "Reps",
    this.id,
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

  Map<String, dynamic> toJson() {
    return {
      'prev': prev,
      'weight': weight,
      'reps': reps,
      'repRangeMin': repRangeMin,
      'repRangeMax': repRangeMax,
      'type': type,
    };
  }

  factory SetModel.fromJson(Map<String, dynamic> json) {
    return SetModel(
      prev: json['prev'] as String?,
      weight: (json['weight'] as num?)?.toDouble() ?? 50,
      reps: json['reps'] as int?,
      repRangeMin: json['repRangeMin'] as int?,
      repRangeMax: json['repRangeMax'] as int?,
      type: json['type'] as String? ?? "Reps",
      id: json['id'] as int,
    );
  }
}
