class NoticeModel {
  NoticeModel({
    required this.id,
    required this.des,
    required this.time,
    required this.name,
    required this.email,
    required this.image,
  });
  late final String id;
  late final String des;
  late final String time;
  late final String name;
  late final String email;
  late final String image;

  NoticeModel.fromJson(Map<String, dynamic> json){
    id = json['id']?? '';
    des = json['des'] ?? '';
    time = json['time'] ?? '';
    name = json['name'] ?? '';
    email = json['email']?? '';
    image = json['image']?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['des'] = des;
    data['time'] = time;
    data['name'] = name;
    data['email'] = email;
    data['image'] = image;
    return data;
  }

}
