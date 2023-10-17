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
  final subjectTitleController = TextEditingController();
  final timeController = TextEditingController();
  final descriptionTitleController = TextEditingController();
  final countquestionController = TextEditingController();
  final quesionController = TextEditingController();
  final option1Controller = TextEditingController();
  final option2Controller = TextEditingController();
  final option3Controller = TextEditingController();
  final option4Controller = TextEditingController();
  final optioncorrectController = TextEditingController();
  final subjectcodeController = TextEditingController();
  final timetextController = TextEditingController();
  final ourController = TextEditingController();
  final minusController = TextEditingController();
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
               SizedBox(width: 250,),
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
                  if (subjectTitleController.text.isNotEmpty &&
                      subjectcodeController.text.isNotEmpty &&
                      countquestionController.text.isNotEmpty &&
                      timeController.text.isNotEmpty) {
                    // Thực hiện các thao tác khi nhấn nút "Cập nhật"
                    // APIs.createDescripton(...);
                    APIs.userUpdateDesCriptionGV(descriptionTitleController.text, countquestionController.text, subjectcodeController.text, timeController.text,subjectTitleController.text,timetextController.text,ourController.text,minusController.text);
                    Navigator.pop(context);
                    Dialogs.showSnacker(context, 'Cập nhật thành công ');
                  }
                },
                child: Text('Cập nhật'),
              ),
              _buildInputField(
                label: 'Tên môn học:',
                controller: subjectTitleController,
                hint: 'vd: hóa học,..',
              ),
              _buildInputField(
                label: 'Mã môn học:',
                controller: subjectcodeController,
                hint: 'vd: 300,..',
              ),
              _buildInputField(
                label: 'Thời gian:',
                controller: timeController,
                hint: 'vd: 300,..',
              ),
              _buildInputField(
                label: 'Mô tả thêm:',
                controller: descriptionTitleController,
                hint: 'vd: ,..',
              ),
              _buildInputField(
                label: 'Ngày làm bài:',
                controller: timetextController,
                hint: 'vd: ,..',
              ),
              _buildInputField(
                label: 'Số câu hỏi:',
                controller: countquestionController,
                hint: 'vd: 5,..',
              ),
              _buildInputField(
                label: 'Giờ:',
                controller: ourController,
                hint: 'vd: 5,..',
              ),
              _buildInputField(
                label: 'Phút:',
                controller: minusController,
                hint: 'vd: 5,..',
              ),


            ],
          ),
        );
      },
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: hint,
                hintText: 'Nhập...',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Vui lòng nhập thông tin';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

}
