class CreateDescriptMode {
  CreateDescriptMode({
    required this.id,
    required this.timeQues,
    required this.description,
    required this.countQues,
    required this.subjectcode,
    required this.image,
    required this.namesubject,
    required this.timetext,
    required this.our,
    required this.minus,
  });
  late final String id;
  late final String timeQues;
  late final String description;
  late final String countQues;
  late final String subjectcode ;
  late final String image ;
  late final String namesubject;
  late final String timetext;
  late final String our;
  late final String minus;

  CreateDescriptMode.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
    timeQues = json['time_ques'] ;
    description = json['description'] ?? '';
    countQues = json['count_ques'] ?? '';
    subjectcode = json['subject_code'] ?? '';
    image = json['image'] ?? '';
    namesubject = json['namesubject']?? '';
    timetext = json['timetext']?? '';
    our = json['our']?? '';
    minus = json['minus']?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['time_ques'] = timeQues;
    data['description'] = description;
    data['count_ques'] = countQues;
    data['subject_code'] = subjectcode;
    data['image'] = image;
    data['namesubject'] = namesubject;
    data['timetext'] = timetext;
    data['our'] = our;
    data['minus'] = minus;
    return data;
  }
}