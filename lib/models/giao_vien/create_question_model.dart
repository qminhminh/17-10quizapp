class QuestionModel {
  QuestionModel({
    required this.id,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.optioncorrect,
    required this.question,
    required this.subjectcode,
    required this.time
  });
  late final String id;
  late final String option1;
  late final String option2;
  late final String option3;
  late final String option4;
  late final String optioncorrect;
  late final String question;
  late final String subjectcode ;
  late final String time;

  QuestionModel.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
    option1 = json['option1']?? '';
    option2 = json['option2']?? '';
    option3 = json['option3']?? '';
    option4 = json['option4']?? '';
    optioncorrect = json['optioncorrect']?? '';
    question = json['question']?? '';
    subjectcode = json['subject_code'] ?? '';
    time = json['time'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['option1'] = option1;
    data['option2'] = option2;
    data['option3'] = option3;
    data['option4'] = option4;
    data['optioncorrect'] = optioncorrect;
    data['question'] = question;
    data['subject_code'] = subjectcode;
    data['time'] = time;
    return data;
  }
}