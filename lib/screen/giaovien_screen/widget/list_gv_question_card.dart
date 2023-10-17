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
  final quesionController = TextEditingController();
  final option1Controller = TextEditingController();
  final option2Controller = TextEditingController();
  final option3Controller = TextEditingController();
  final option4Controller = TextEditingController();
  final optioncorrectController = TextEditingController();
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
                  if(option1Controller.text !=null && option2Controller.text !=null && option3Controller.text !=null && option4Controller.text !=null&& optioncorrectController.text !=null && quesionController.text != null){
                   APIs.userUpdateQuestionnGV(widget.model.subjectcode, widget.model.time, quesionController.text, option1Controller.text, option2Controller.text, option3Controller.text, option4Controller.text, optioncorrectController.text);
                    Dialogs.showSnacker(context, 'Thêm câu hỏi thành công ');
                    option1Controller.text='';
                    option2Controller.text='';
                    option3Controller.text='';
                    option4Controller.text='';
                    optioncorrectController.text ='';
                    quesionController.text ='';
                  }
                },
                child: Text('Cập nhật'),
              ),
              _buildInputField(
                label: 'Nhập câu hỏi:',
                controller: quesionController,
                hint: 'vd: hóa học,..',
              ),
              _buildInputField(
                label: 'Đáp án 1:',
                controller: option1Controller,
                hint: 'vd: ,..',
              ),
              _buildInputField(
                label: 'Đáp án 2:',
                controller: option2Controller,
                hint: 'vd: ,..',
              ),
              _buildInputField(
                label: 'Đáp án 3:',
                controller: option3Controller,
                hint: 'vd: ,..',
              ),
              _buildInputField(
                label: 'Đáp án 4:',
                controller: option4Controller,
                hint: 'vd: ,..',
              ),
              _buildInputField(
                label: 'Đáp án đúng:',
                controller: optioncorrectController,
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
