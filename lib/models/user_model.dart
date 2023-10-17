class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.image,
    required this.email,
    required this.checkuser,
  });
  late final String id;
  late final String name;
  late final String image;
  late final String email;
  late final int checkuser;

  UserModel.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    image = json['image']?? '';
    email = json['email']?? '';
    checkuser = json['checkuser'] ;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['email'] = email;
    data['checkuser'] = checkuser;
    return data;
  }
}