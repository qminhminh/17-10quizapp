import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thutext/api/apis.dart';
import '../helpers/dialogs.dart';
import '../list_question/list_gv_question_screen.dart';
import '../models/giao_vien/create_description_model.dart';

class DesGVQesCard extends StatefulWidget {
  const DesGVQesCard({Key? key, required this.model});
  final CreateDescriptMode model;

  @override
  State<DesGVQesCard> createState() => _DesGVQesCardState();
}

class _DesGVQesCardState extends State<DesGVQesCard> {

  String namesubject= '';
  String mamh= '';
  String timestart= '';
  String descript = '';
  String datelambai = '';
  String socauhoi = '';
  String gio= '';
  String phut= '';
  String? _image;

  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.auth.currentUser!.uid == widget.model.id;

    return isMe ? GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ListQuestionGVScreen(model: widget.model)));
      },
      child: Card(
        color: Colors.white,
        elevation: 5, // Increase the elevation for a shadow effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Add rounded corners
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  _image !=null ?
                  ClipRRect(
                    borderRadius: BorderRadius.circular(1),
                    child: Image.file(
                      File(_image!),
                      fit: BoxFit.cover,
                      width: 110,
                      height: 110,
                    ),
                  )
                      :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(1),
                        child: CachedNetworkImage(
                          width: 300,
                          height: 140,
                          fit: BoxFit.fill,
                          imageUrl: widget.model.image,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(CupertinoIcons.person,),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 17), // Add padding to the text
              child: Text(
                '${widget.model.namesubject}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
           Row(
             children: [
               Padding(
                 padding: const EdgeInsets.only(left: 17), // Add padding to the text
                 child: Text(
                   'Mã học phần - ${widget.model.subjectcode}',
                   style: TextStyle(
                     fontSize: 16,
                   ),
                 ),
               ),
               SizedBox(width: 100,),
               PopupMenuButton(
                   onSelected: (value){
                     if(value == 'edit'){
                       _showBottomSheet();
                     }else if (value == 'editdes'){
                       _showBottomSheetText();
                     }
                     else if (value == 'delete'){
                       showDialog(context: context,
                           builder: (_)=> AlertDialog(
                             contentPadding: EdgeInsets.only(left: 24,right: 24,top: 20,bottom: 10),
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                             title: Row(
                               children: [
                                 Text('Bạn muốn có muốn xóa tất cả kể cả câu hỏi?')
                               ],
                             ),

                             actions: [

                               MaterialButton(
                                 onPressed: (){ Navigator.pop(context);},
                                 child: Text('Quay lại',style: TextStyle(fontSize: 16,color: Colors.blue),),
                               ),

                               MaterialButton(
                                 onPressed: () {
                                   Navigator.pop(context);
                                   APIs.gedeleteDesCriptionGV(widget.model.subjectcode);
                                   Dialogs.showSnacker(context, 'Xóa thành công');
                                 },
                                 child: Text('Xóa',style: TextStyle(fontSize: 16,color: Colors.blue),),
                               )
                             ],
                           )
                       );
                     }
                   },
                   itemBuilder: (context){
                     return [
                       PopupMenuItem(
                         child: Text('Thêm ảnh mô tả'),
                         value: 'edit',
                       ),
                       PopupMenuItem(
                         child: Text('Sửa mô tả'),
                         value: 'editdes',
                       ),
                       PopupMenuItem(
                         child: Text('Xóa'),
                         value: 'delete',
                       ),
                     ];
                   }
               ),
             ],
           ),
            Padding(
              padding: const EdgeInsets.only(left: 17), // Add padding to the text
              child: Text(
                'Thời gian làm bài - ${(int.parse(widget.model.timeQues)/60).ceil()} phút',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    ) : Center(child: Text('Chưa có bài tập nào'),);
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
                          APIs.updateProfilePicture(File(_image!), widget.model.subjectcode);
                          Navigator.pop(context);
                        }

                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(100,100)
                      ),
                      child: Image.asset('images/add-image.png',height: 40,)
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
                          APIs.updateProfilePicture(File(_image!), widget.model.subjectcode);
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


  void _showBottomSheetText() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Thay đổi mô tả',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {

                   if(widget.model != null){
                     Navigator.pop(context);
                   }
                   else{
                     Dialogs.showSnacker(context, 'false');
                   }
                   APIs.userUpdateDesCriptionGV(descript == '' ? widget.model.description : descript, socauhoi == '' ? widget.model.countQues : socauhoi, mamh == '' ? widget.model.subjectcode : mamh, timestart == '' ? widget.model.timeQues : timestart,namesubject == '' ? widget.model.namesubject : namesubject,datelambai == '' ? widget.model.timetext : datelambai,gio == '' ? widget.model.our : gio,phut == '' ? widget.model.minus : phut);

                   setState(() {
                     descript = '';
                     socauhoi = '';
                     mamh = '';
                     timestart = '';
                     namesubject = '';
                     datelambai = '';
                     gio ='';
                     phut ='';
                   });
                   Dialogs.showSnacker(context, 'Cập nhật thành công');
                },
                child: Text('Cập nhật'),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Tên môn học:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(

                        onChanged: (val)=> namesubject = val ?? '',
                        validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field',
                        initialValue: widget.model.namesubject,
                        decoration: InputDecoration(
                          hintText: 'eg. Toan',
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Mã môn học:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (val) => mamh = val ?? '',
                        validator: (val)=>val!=null&&val.isNotEmpty? null : 'Required Field',
                        initialValue: widget.model.subjectcode,
                        decoration: InputDecoration(
                          hintText: 'eg. 1234',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Thời gian:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (val) => timestart = val ?? '',
                        validator: (val)=>val!=null&&val.isNotEmpty? null:'Required Field',
                        initialValue: widget.model.timeQues,
                        decoration: InputDecoration(
                          hintText: 'eg. 15 phut',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Mô tả thêm:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (val) =>descript = val ?? '',
                        validator: (val)=> val!=null&&val.isNotEmpty? null:'Required Field',
                        initialValue: widget.model.description,
                        decoration: InputDecoration(
                          hintText: 'eg. Mô tả ',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Ngày làm bài:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (val) => datelambai = val ?? '',
                        validator: (val)=> val!=null&&val.isNotEmpty? null:'Required Field',
                        initialValue: widget.model.timetext,
                        decoration: InputDecoration(
                          hintText: 'eg. 12/10/2023',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Số câu hỏi:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (val) => socauhoi = val ?? '',
                        validator: (val)=> val!=null&&val.isNotEmpty? null:'Required Field',
                        initialValue: widget.model.countQues,
                        decoration: InputDecoration(
                          hintText: 'eg. 5',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Giờ:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (val) => gio = val ?? '',
                        validator: (val)=> val!=null&&val.isNotEmpty? null:'Required Field',
                        initialValue: widget.model.our,
                        decoration: InputDecoration(
                          hintText: 'eg. 5 gio',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Phút:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (val) => phut = val ?? '',
                        validator: (val)=> val!=null&&val.isNotEmpty? null:'Required Field',
                        initialValue: widget.model.minus,
                        decoration: InputDecoration(
                          hintText: 'eg. 5 gio',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        );
      },
    );
  }

}
