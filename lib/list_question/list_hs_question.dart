
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thutext/api/apis.dart';
import '../count_down_timer/countdown_controller.dart';
import '../models/giao_vien/create_description_model.dart';
import '../models/giao_vien/create_question_model.dart';
import '../screen/hocsinh_screen/widget/list_hs_question_card.dart';

class ListQuestionHSScreen extends StatefulWidget {
  const ListQuestionHSScreen({Key? key, required this.model});
  final CreateDescriptMode model;

  @override
  State<ListQuestionHSScreen> createState() => _ListQuestionScreenState();
}

class _ListQuestionScreenState extends State<ListQuestionHSScreen> {
  List<QuestionModel> list = [];
  final CountdownController countdownController = CountdownController();

  @override
  void initState() {
    super.initState();
    countdownController.startCountdown(int.parse(widget.model.timeQues));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Obx(() => Text('Time: ${countdownController.minutes.value}:${countdownController.seconds.value.toString().padLeft(2, '0')}')),
        actions: [
          TextButton(
            onPressed: () {
              // Handle the "Nộp bài" button click.

            },
            child: Text('Nộp bài'),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: APIs.getQuestion(widget.model.subjectcode, widget.model.id),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final date = snapshot.data?.docs;
                    list = date?.map((e) => QuestionModel.fromJson(e.data())).toList() ?? [];
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(10),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return QuestionCardHSScreen(model: list[index], index: index);
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
