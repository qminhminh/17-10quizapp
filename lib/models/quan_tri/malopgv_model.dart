class ClassGVModel {
  ClassGVModel({
    required this.time,
    required this.tenmon,
    required this.mahhp,
  });
  late String time;
  late String tenmon;
  late String mahhp;

  ClassGVModel.fromJson(Map<String, dynamic> json) {
    tenmon = json['tenmon'] ?? '';
    mahhp = json['mahhp'] ?? '';
    time = json['time'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['tenmon'] = tenmon;
    data['mahhp'] = mahhp;
    data['time'] = time;
    return data;
  }
}
