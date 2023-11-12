// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thutext/api/apis.dart';
import 'package:thutext/helpers/dialogs.dart';
import '../count_down_timer/countdown_controller.dart';
import '../models/giao_vien/create_description_model.dart';
import '../models/giao_vien/create_question_model.dart';
import '../screen/giaovien_screen/widget/list_gv_question_card.dart';

class ListQuestionGVScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const ListQuestionGVScreen({Key? key, required this.model});
  final CreateDescriptMode model;

  @override
  State<ListQuestionGVScreen> createState() => _ListQuestionScreenState();
}

class _ListQuestionScreenState extends State<ListQuestionGVScreen> {
  List<QuestionModel> list = [];
  List<QuestionModel> searchlist = [];
  bool _isSearching = false;
  final CountdownController countdownController = CountdownController();
  final quesionController = TextEditingController();
  final option1Controller = TextEditingController();
  final option2Controller = TextEditingController();
  final option3Controller = TextEditingController();
  final option4Controller = TextEditingController();
  final optioncorrectController = TextEditingController();

  @override
  void initState() {
    super.initState();
    countdownController.startCountdown(int.parse(widget.model.timeQues));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: _isSearching
                ? TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name, Text.....',
                    ),
                    autofocus: true,
                    style: const TextStyle(fontSize: 16, letterSpacing: 0.5),
                    //when search text changes then updatesd search list
                    onChanged: (val) {
                      searchlist.clear();

                      for (var i in list) {
                        if (i.question
                                .toLowerCase()
                                .contains(val.toLowerCase()) ||
                            i.optioncorrect
                                .toLowerCase()
                                .contains(val.toLowerCase())) {
                          searchlist.add(i);
                        }
                        setState(() {
                          searchlist;
                        });
                      }
                    },
                  )
                : const Text('Thi'),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),
              Obx(() => Text(
                  'Time: ${countdownController.minutes.value}:${countdownController.seconds.value.toString().padLeft(2, '0')}')),
              TextButton(
                onPressed: () {
                  // Handle the "Nộp bài" button click.
                  _showBottomSheetText();
                },
                child: const Text('Tạo'),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: APIs.getQuestion(
                      widget.model.subjectcode, widget.model.id),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final date = snapshot.data?.docs;
                        list = date
                                ?.map((e) => QuestionModel.fromJson(e.data()))
                                .toList() ??
                            [];
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(10),
                          itemCount:
                              _isSearching ? searchlist.length : list.length,
                          itemBuilder: (context, index) {
                            return QuestionCardGVScreen(
                                model: _isSearching
                                    ? searchlist[index]
                                    : list[index],
                                index: index);
                          },
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheetText() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Thay đổi mô tả',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (option1Controller.text != null &&
                      option2Controller.text != null &&
                      option3Controller.text != null &&
                      option4Controller.text != null &&
                      optioncorrectController.text != null &&
                      quesionController.text != null) {
                    APIs.createQuestionandAnswer(
                        option1Controller.text,
                        option2Controller.text,
                        option3Controller.text,
                        option4Controller.text,
                        optioncorrectController.text,
                        quesionController.text,
                        widget.model.namesubject,
                        widget.model.subjectcode);
                    Dialogs.showSnacker(context, 'Thêm câu hỏi thành công ');
                    option1Controller.text = '';
                    option2Controller.text = '';
                    option3Controller.text = '';
                    option4Controller.text = '';
                    optioncorrectController.text = '';
                    quesionController.text = '';
                  }
                },
                child: const Text('Cập nhật'),
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
            style: const TextStyle(
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
