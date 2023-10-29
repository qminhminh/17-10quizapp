class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.image,
    required this.email,
    required this.checkuser,
    required this.about,
    required this.pushtoken,
    required this.isOnline,
    required this.password,
  });
  late String id;
  late String name;
  late String image;
  late String email;
  late int checkuser;
  late String about;
  late String pushtoken;
  late bool isOnline;
  late String password;

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    image = json['image'] ?? '';
    email = json['email'] ?? '';
    checkuser = json['checkuser'];
    about = json['about'] ?? '';
    pushtoken = json['push_token'] ?? '';
    isOnline = json['is_Online'] ?? false;
    password = json['password'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['email'] = email;
    data['checkuser'] = checkuser;
    data['about'] = about;
    data['push_token'] = pushtoken;
    data['is_Online'] = isOnline;
    data['password'] = password;
    return data;
  }
}
