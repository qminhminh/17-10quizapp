class ScoreHSModel {
  ScoreHSModel({
    required this.id,
    required this.score,
    required this.mahp,
    required this.email,
    required this.time,
    required this.date,
  });
  late final String id;
  late final int score;
  late final String mahp;
  late final String email;
  late final String time;
  late final String date;

  ScoreHSModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    score = json['score'];
    mahp = json['mahp'] ?? '';
    email = json['email'] ?? '';
    time = json['time'] ?? '';
    date = json['date'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['score'] = score;
    data['time'] = time;
    data['mahp'] = mahp;
    data['email'] = email;
    data['date'] = date;
    return data;
  }
}
