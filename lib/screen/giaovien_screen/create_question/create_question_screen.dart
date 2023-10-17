import 'package:flutter/material.dart';
import 'package:thutext/api/apis.dart';
import '../../../helpers/dialogs.dart';

class CreateQuestionGVScreen extends StatefulWidget {
  const CreateQuestionGVScreen({Key? key}) : super(key: key);

  @override
  State<CreateQuestionGVScreen> createState() => _CreateQuestionGVScreenState();
}

class _CreateQuestionGVScreenState extends State<CreateQuestionGVScreen> {
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
  String image = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Question GV Screen'), // Đổi thành tiêu đề của màn hình
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Nhập tên môn học:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold, // Để làm đậm tiêu đề
                    ),
                  ),
                  SizedBox(width: 60,),
                  TextButton(
                      onPressed: (){
                        if(subjectTitleController.text !=null && subjectcodeController.text !=null && countquestionController.text !=null && timeController.text !=null){
                          APIs.createDescripton(image, descriptionTitleController.text, countquestionController.text, subjectcodeController.text, timeController.text,subjectTitleController.text,timetextController.text,ourController.text,minusController.text);
                          Dialogs.showSnacker(context, 'Thêm mô tả thành công ');
                        }
                      },
                      child: Text('Tạo mô tả')
                  )
                ],
              ),

              TextFormField(
                controller: subjectTitleController,
                decoration: InputDecoration(
                  labelText: 'vd: hóa học,..',
                  hintText: 'Nhập tên môn học', // Để hiển thị hướng dẫn
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text(
                'Nhập mã môn học:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: subjectcodeController,
                decoration: InputDecoration(
                  labelText: 'vd: 300,..',
                  hintText: 'Nhập thời gian',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10), // Tăng khoảng cách giữa các trường nhập liệu
              Text(
                'Thời gian:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: timeController,
                decoration: InputDecoration(
                  labelText: 'vd: 300,..',
                  hintText: 'Nhập thời gian',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text(
                'Mô tả thêm:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: descriptionTitleController,
                decoration: InputDecoration(
                  labelText: 'vd: ,..',
                  hintText: 'Nhập mô tả thêm',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text(
                'Thời gian mở bài:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: ourController,
                decoration: InputDecoration(
                  labelText: 'vd: 15,..',
                  hintText: 'Nhập giờ',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(width: 10,),
              TextFormField(
                controller: minusController,
                decoration: InputDecoration(
                  labelText: 'phút,..',
                  hintText: 'Nhập phút',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              Text(
                'Ngày làm bài:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: timetextController,
                decoration: InputDecoration(
                  labelText: 'vd: ,..',
                  hintText: 'Nhập ngày làm bài;',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text(
                'Số câu hỏi:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: countquestionController,
                decoration: InputDecoration(
                  labelText: 'vd: 5,..',
                  hintText: 'Nhập số câu hỏi',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text(
                'Nhập câu hỏi và câu trả lời cho từng câu:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
             Row(
               children: [
                 Text(
                   'Nhập câu hỏi:',
                   style: TextStyle(
                     fontSize: 16.0,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
                 SizedBox(width: 70,),
                 TextButton(
                     onPressed: (){

                       if(option1Controller.text !=null && option2Controller.text !=null && option3Controller.text !=null && option4Controller.text !=null&& optioncorrectController.text !=null && quesionController.text != null){
                         APIs.createQuestionandAnswer(option1Controller.text, option2Controller.text,option3Controller.text, option4Controller.text, optioncorrectController.text, quesionController.text, subjectTitleController.text, subjectcodeController.text);
                         Dialogs.showSnacker(context, 'Thêm câu hỏi thành công ');
                         option1Controller.text='';
                         option2Controller.text='';
                         option3Controller.text='';
                         option4Controller.text='';
                         optioncorrectController.text ='';
                         quesionController.text ='';
                       }

                     },
                     child: Text('Tạo câu hỏi ',)
                 )
               ],
             ),
              TextFormField(
                controller: quesionController,
                decoration: InputDecoration(
                  labelText: 'Câu hỏi',
                  hintText: 'Nhập câu hỏi và câu trả lời',
                ),
              ),
              TextFormField(
                controller: option1Controller,
                decoration: InputDecoration(
                  labelText: 'đáp án 1',
                  hintText: 'Nhập câu hỏi và câu trả lời',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: option2Controller,
                decoration: InputDecoration(
                  labelText: 'đáp án 2',
                  hintText: 'Nhập câu hỏi và câu trả lời',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: option3Controller,
                decoration: InputDecoration(
                  labelText: 'đáp án 3',
                  hintText: 'Nhập câu hỏi và câu trả lời',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: option4Controller,
                decoration: InputDecoration(
                  labelText: 'đáp án 4',
                  hintText: 'Nhập câu hỏi và câu trả lời',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              Text(
                'Đáp án:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: optioncorrectController,
                decoration: InputDecoration(
                  labelText: 'Câu trả lời đúng',
                  hintText: 'Nhập câu hỏi và câu trả lời',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
