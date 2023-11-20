class ScoreModel {
  ScoreModel({
    required this.id,
    required this.score,
    required this.time,
  });
  late final String id;
  late final double score;
  late final String time;

  ScoreModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    score = json['score'];
    time = json['time'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['score'] = score;
    data['time'] = time;
    return data;
  }
}
