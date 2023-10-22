
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
  const ProfileScreen({super.key,required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<UserModel> list=[];
  final formkey=GlobalKey<FormState>();
  String? _image;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('Trang cá nhân'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton.extended(
          icon: Icon(Icons.logout),
          onPressed: () async{
            await APIs.updateActiveStatus(false);
            Dialogs.showProgressBar(context);
            await FirebaseAuth.instance.signOut().then((value) async {
                Navigator.pop(context);
                APIs.auth=FirebaseAuth.instance;
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
            });

          },
          label: Text('Đăng xuất '),
        ),
      ),
      // stream tự động  cập nhật giao diện khi có sự thay đôi
      body:Form(
        key: formkey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(width: 5,height: 3,),
                // use profile picture
                Stack(
                  children: [
                    _image !=null ?
                    ClipRRect(
                      borderRadius: BorderRadius.circular(1),
                      child: Image.file(
                        File(_image!),
                        width: 152,
                        height: 152,
                        fit: BoxFit.cover,
                      ),
                    )
                        :
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        width: 172,
                        height: 172,
                        fit: BoxFit.fill,
                        imageUrl: widget.user.image,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person),),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: MaterialButton(
                        onPressed: (){
                          _showBottomSheet();
                        },
                        elevation: 1,
                        color: Colors.white,
                        shape: CircleBorder(),
                        child: Icon(Icons.edit,color: Colors.blue,),),
                    )
                  ],
                ),
                SizedBox(height: 13,),
                Text(widget.user.email,style: TextStyle(color: Colors.black54,fontSize: 16),),
                SizedBox(height:13,),
                // update cua name
                TextFormField(
                  onSaved: (val)=>APIs.me.name=val??'',
                  validator: (val)=>val!=null&&val.isNotEmpty? null:'Required Field',
                  initialValue: widget.user.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.person,color: Colors.blue,),
                    hintText: 'eg. Quang Minh ',
                    label: Text('Tên bạn'),
                  ),
                ),
                SizedBox(height: 12,),
                // update cua about
                TextFormField(
                  onSaved: (val)=>APIs.me.about=val ?? '',// vadicator kiểm tra dữ liệu nhập
                  validator: (val)=>val !=null && val.isNotEmpty ? null:'Required Field',
                  initialValue: widget.user.about,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.inbox_outlined,color: Colors.blue,),
                    hintText: 'eg. Qsdvsal  ',
                    label: Text('Mô tả thêm'),
                  ),
                ),
                SizedBox(height: 5,),
                // update Profile Button
                ElevatedButton.icon(
                  onPressed: (){
                    if(formkey.currentState!.validate()){
                      formkey.currentState!.save();
                      APIs.userUpdateInfo();
                      Dialogs.showSnacker(context, 'Profile Update Success');
                    }
                  },
                  icon: Icon(Icons.edit,size: 28,),
                  style: ElevatedButton.styleFrom(shape: StadiumBorder(),minimumSize: Size(5, 6)),
                  label: Text('Cập nhật',style: TextStyle(fontSize: 16),),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // bottom sheet for picing a profile picture for user
  void _showBottomSheet(){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
        builder: (_){
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 3,bottom: 5),
            children: [
              Text('Chọn ảnh',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
              SizedBox(height: 2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
                        if(image!=null){
                          setState(() {
                            _image=image.path;
                          });
                          APIs.updateProfilePictureUsers(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }

                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(100,100)
                      ),
                      child: Image.asset('images/add-image.png')
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 80);
                        if(image!=null){
                          setState(() {
                            _image=image.path;
                          });
                          APIs.updateProfilePictureUsers(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(100,100)
                      ),
                      child: Image.asset('images/camera.png')
                  ),
                ],
              )
            ],
          );
        }
    );
  }
}
