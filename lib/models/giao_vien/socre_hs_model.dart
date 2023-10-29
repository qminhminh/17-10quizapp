class ScoreHSModel {
  ScoreHSModel({
    required this.id,
    required this.score,
    required this.mahp,
    required this.email,
    required this.time,
  });
  late final String id;
  late final int score;
  late final String mahp;
  late final String email;
  late final String time;

  ScoreHSModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    score = json['score'];
    mahp = json['mahp'] ?? '';
    email = json['email'] ?? '';
    time = json['time'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['score'] = score;
    data['time'] = time;
    data['mahp'] = mahp;
    data['email'] = email;
    return data;
  }
}
