import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thutext/models/user_model.dart';
import 'package:thutext/screen/auth/login_screen.dart';
import '../api/apis.dart';
import '../helpers/dialogs.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<UserModel> list = [];
  final formkey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang cá nhân'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton.extended(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await APIs.updateActiveStatus(false);
            // ignore: use_build_context_synchronously
            Dialogs.showProgressBar(context);
            await FirebaseAuth.instance.signOut().then((value) async {
              Navigator.pop(context);
              APIs.auth = FirebaseAuth.instance;
              APIs.prefs.setString('hs', '');
              APIs.prefs.setString('gv', '');
              APIs.prefs.setString('qt', '');
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            });
          },
          label: const Text('Đăng xuất '),
        ),
      ),
      // stream tự động  cập nhật giao diện khi có sự thay đôi
      body: Form(
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  width: 5,
                  height: 3,
                ),
                // use profile picture
                Stack(
                  children: [
                    _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(1),
                            child: Image.file(
                              File(_image!),
                              width: 152,
                              height: 152,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              width: 172,
                              height: 172,
                              fit: BoxFit.fill,
                              imageUrl: widget.user.image,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(
                                child: Icon(CupertinoIcons.person),
                              ),
                            ),
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: MaterialButton(
                        onPressed: () {
                          _showBottomSheet();
                        },
                        elevation: 1,
                        color: Colors.white,
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 13,
                ),
                Text(
                  widget.user.email,
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),
                const SizedBox(
                  height: 13,
                ),
                // update cua name
                TextFormField(
                  onSaved: (val) => APIs.me.name = val ?? '',
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : 'Required Field',
                  initialValue: widget.user.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                    hintText: 'eg. Quang Minh ',
                    label: const Text('Tên bạn'),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                // update cua about
                TextFormField(
                  onSaved: (val) => APIs.me.about =
                      val ?? '', // vadicator kiểm tra dữ liệu nhập
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : 'Required Field',
                  initialValue: widget.user.about,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(
                      Icons.inbox_outlined,
                      color: Colors.blue,
                    ),
                    hintText: 'eg. Qsdvsal  ',
                    label: const Text('Mô tả thêm'),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                // update Profile Button
                ElevatedButton.icon(
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      formkey.currentState!.save();
                      APIs.userUpdateInfo();
                      Dialogs.showSnacker(context, 'Profile Update Success');
                    }
                  },
                  icon: const Icon(
                    Icons.edit,
                    size: 28,
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: const Size(5, 6)),
                  label: const Text(
                    'Cập nhật',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // bottom sheet for picing a profile picture for user
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 3, bottom: 5),
            children: [
              const Text(
                'Chọn ảnh',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updateProfilePictureUsers(File(_image!));
                          // for hiding bottom sheet
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: const Size(100, 100)),
                      child: Image.asset('images/add-image.png')),
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updateProfilePictureUsers(File(_image!));
                          // for hiding bottom sheet
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: const Size(100, 100)),
                      child: Image.asset('images/camera.png')),
                ],
              )
            ],
          );
        });
  }
}
