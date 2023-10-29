class NoticeScoreHSModel {
  NoticeScoreHSModel({
    required this.id,
    required this.score,
    required this.mahp,
    required this.email,
    required this.time,
    required this.namemh,
  });
  late final String id;
  late final int score;
  late final String mahp;
  late final String email;
  late final String time;
  late final String namemh;

  NoticeScoreHSModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    score = json['score'];
    mahp = json['mahp'] ?? '';
    email = json['email'] ?? '';
    time = json['time'] ?? '';
    namemh = json['namemh'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['score'] = score;
    data['time'] = time;
    data['mahp'] = mahp;
    data['email'] = email;
    data['namemh'] = namemh;
    return data;
  }
}
