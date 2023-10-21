import 'package:flutter/material.dart';
import 'package:thutext/api/apis.dart';
import '../../../helpers/dialogs.dart';
import '../../../models/giao_vien/create_question_model.dart';


class QuestionCardGVScreen extends StatefulWidget {
  const QuestionCardGVScreen({super.key, required this.model, required this.index});
  final QuestionModel model;
  final int index;

  @override
  State<QuestionCardGVScreen> createState() => _QuestionCardScreenState();
}

class _QuestionCardScreenState extends State<QuestionCardGVScreen> {
  String selectedAnswer='';
  int count = 0;
  String cauhoi ='';
  String cautraloi1 ='';
  String cautraloi2 ='';
  String cautraloi3 ='';
  String cautraloi4 ='';
  String cautraloidung ='';

  // Câu trả lời đúng


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Row(
              children: [
                Text('     Câu ${widget.index+1}:  ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                Text('${widget.model.question}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                SizedBox(width: 10,),
                PopupMenuButton(
                    onSelected: (value){
                      if(value == 'edit'){
                        _showBottomSheetText();
                      }else if (value == 'delete'){
                        showDialog(context: context,
                            builder: (_)=> AlertDialog(
                              contentPadding: EdgeInsets.only(left: 24,right: 24,top: 20,bottom: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              title: Row(
                                children: [
                                  Text('Bạn muốn có muốn xóa?')
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
                                    APIs.gedeleteQuestionGV(widget.model.time, widget.model.subjectcode);
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
                          child: Text('Sửa'),
                          value: 'edit',
                        ),
                        PopupMenuItem(
                          child: Text('Xóa'),
                          value: 'delete',
                        ),
                      ];
                    }
                ),
                // IconButton(onPressed: (){
                //   _showBottomSheetText();
                // }, icon: Icon(Icons.edit)),
                // IconButton(onPressed: (){
                //   showDialog(context: context,
                //       builder: (_)=> AlertDialog(
                //         contentPadding: EdgeInsets.only(left: 24,right: 24,top: 20,bottom: 10),
                //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                //         title: Row(
                //           children: [
                //             Text('Bạn muốn có muốn xóa?')
                //           ],
                //         ),
                //
                //         actions: [
                //
                //           MaterialButton(
                //             onPressed: (){ Navigator.pop(context);},
                //             child: Text('Quay lại',style: TextStyle(fontSize: 16,color: Colors.blue),),
                //           ),
                //
                //           MaterialButton(
                //             onPressed: () {
                //               Navigator.pop(context);
                //               APIs.gedeleteQuestionGV(widget.model.time, widget.model.subjectcode);
                //               Dialogs.showSnacker(context, 'Xóa thành công');
                //             },
                //             child: Text('Xóa',style: TextStyle(fontSize: 16,color: Colors.blue),),
                //           )
                //         ],
                //       )
                //   );
                // }, icon: Icon(Icons.delete_forever))
              ],
            ),
            RadioListTile(
              value: '${widget.model.option1}',
              groupValue: selectedAnswer,
              onChanged: (value) {
                setState(() {
                  selectedAnswer = value!;
                  if (selectedAnswer == widget.model.optioncorrect) {
                    count++;
                    print('Điểm số: ${count}');
                    APIs.createScore(count,widget.model.subjectcode);

                    print('Câu trả lời đúng!');
                  } else {
                    print('Câu trả lời sai.');
                  }
                });
              },
              title: Text('${widget.model.option1}'),
            ),
            RadioListTile(
              value: '${widget.model.option2}',
              groupValue: selectedAnswer,
              onChanged: (value) {
                setState(() {
                  selectedAnswer = value!;
                  if (selectedAnswer == widget.model.optioncorrect) {

                    count++;
                    print('Điểm số: ${count}');
                    APIs.createScore(count,widget.model.subjectcode);
                    print('Câu trả lời đúng!');
                  } else {
                    print('Câu trả lời sai.');
                  }
                });
              },
              title: Text('${widget.model.option2}'),
            ),
            RadioListTile(
              value: '${widget.model.option3}',
              groupValue: selectedAnswer,
              onChanged: (value) {
                setState(() {
                  selectedAnswer = value!;
                  if (selectedAnswer == widget.model.optioncorrect) {

                    count++;
                    print('Điểm số: ${count}');
                    APIs.createScore(count,widget.model.subjectcode);
                    print('Câu trả lời đúng!');
                  } else {
                    print('Câu trả lời sai.');
                  }
                });
              },
              title: Text('${widget.model.option3}'),
            ),
            RadioListTile(
              value: '${widget.model.option4}',
              groupValue: selectedAnswer,
              onChanged: (value) {
                setState(() {
                  selectedAnswer = value!;
                  if (selectedAnswer == widget.model.optioncorrect) {
                    count++;
                    print('Điểm số: ${count}');
                    APIs.createScore(count,widget.model.subjectcode);

                    print('Câu trả lời đúng!');
                  } else {
                    print('Câu trả lời sai.');
                  }
                });
              },
              title: Text('${widget.model.option4}'),
            ),
          ],
        ),
      ),
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
                   APIs.userUpdateQuestionnGV(widget.model.subjectcode, widget.model.time, cauhoi == ''? widget.model.question : cauhoi, cautraloi1 == '' ? widget.model.option1 : cautraloi1,cautraloi2 == '' ? widget.model.option2 : cautraloi2 ,cautraloi3 == '' ? widget.model.option3 : cautraloi3,cautraloi4 == '' ? widget.model.option4 : cautraloi4, cautraloidung == '' ? widget.model.optioncorrect : cautraloidung);
                    Dialogs.showSnacker(context, 'Sua câu hỏi thành công ');
                    setState(() {
                      cauhoi = '';
                      cautraloi1 ='';
                      cautraloi2 ='';
                      cautraloi3='';
                      cautraloi4='';
                      cautraloidung='';
                    });
                     Navigator.pop(context);
                  }
                },
                child: Text('Cập nhật'),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Nhập câu hỏi:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(

                        onChanged: (val)=> cauhoi = val ?? '',
                        validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field',
                        initialValue: widget.model.question,
                        decoration: InputDecoration(
                          hintText: 'eg. Câu hỏi là gì?',
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
                      'Đáp án 1:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        onChanged: (val)=> cautraloi1 = val ?? '',
                        validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field',
                        initialValue: widget.model.option1,
                        decoration: InputDecoration(
                          hintText: 'eg. Đáp án 1',
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
                      'Đáp án 2:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        onChanged: (val)=> cautraloi2 = val ?? '',
                        validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field',
                        initialValue: widget.model.option2,
                        decoration: InputDecoration(
                          hintText: 'eg.Đáp án 2',
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
                      'Đáp án 3:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        onChanged: (val)=> cautraloi3 = val ?? '',
                        validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field',
                        initialValue: widget.model.option3,
                        decoration: InputDecoration(
                          hintText: 'eg. Đáp án 3',
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
                      'Đáp án 4:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        onChanged: (val)=> cautraloi4 = val ?? '',
                        validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field',
                        initialValue: widget.model.option4,
                        decoration: InputDecoration(
                          hintText: 'eg. Đáp án 4:',
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
                      'Đáp án đúng:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        onChanged: (val)=> cautraloidung = val ?? '',
                        validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field',
                        initialValue: widget.model.optioncorrect,
                        decoration: InputDecoration(
                          hintText: 'eg. Đáp án đúng',
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
