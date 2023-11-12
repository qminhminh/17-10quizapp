import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thutext/api/apis.dart';
import 'package:thutext/helpers/dialogs.dart';
import 'package:thutext/models/hoc_sinh/score_model.dart';
import '../count_down_timer/countdown_controller.dart';
import '../models/giao_vien/create_description_model.dart';
import '../models/giao_vien/create_question_model.dart';
import '../screen/hocsinh_screen/widget/list_hs_question_card.dart';

class ListQuestionHSScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const ListQuestionHSScreen({Key? key, required this.model});
  final CreateDescriptMode model;

  @override
  State<ListQuestionHSScreen> createState() => _ListQuestionScreenState();
}

class _ListQuestionScreenState extends State<ListQuestionHSScreen> {
  List<QuestionModel> list = [];
  int totalScore = 0;
  List<ScoreModel> listScore = [];
  final CountdownController countdownController = CountdownController();

  @override
  void initState() {
    super.initState();
    countdownController.startCountdown(int.parse(widget.model.timeQues));

    countdownController.isRunning.listen((isRunning) {
      if (isRunning &&
          countdownController.minutes.value == 0 &&
          countdownController.seconds.value == 0) {
        APIs.SeeScoreGV(
            '${countdownController.minutes.value}:${countdownController.seconds.value.toString().padLeft(2, '0')}',
            totalScore,
            widget.model.subjectcode);

        APIs.NoticeSeeScoreHS(
            '${countdownController.minutes.value}:${countdownController.seconds.value.toString().padLeft(2, '0')}',
            totalScore,
            widget.model.subjectcode,
            widget.model
                .namesubject); // Replace '/home' with your home screen route
        countdownController.stop();
        Dialogs.showSnackBar(context,
            'Bạn đã nộp bài thành công \n Điểm của bạn là $totalScore');
      }
    });
    getDataFromFirestore();
  }

  Future<void> getDataFromFirestore() async {
    final querySnapshot = await APIs.firestore
        .collection('scoreusers')
        .doc(APIs.auth.currentUser!.uid)
        .collection(widget.model.subjectcode)
        .get();
    final scoreList = querySnapshot.docs
        .map((doc) => ScoreModel.fromJson(doc.data()))
        .toList();

    setState(() {
      listScore = scoreList;

      for (var score in listScore) {
        totalScore += score.score;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
            'Time: ${countdownController.minutes.value}:${countdownController.seconds.value.toString().padLeft(2, '0')}')),
        actions: [
          TextButton(
            onPressed: () {
              // Handle the "Nộp bài" button click.
              APIs.SeeScoreGV(
                  '${countdownController.minutes.value}:${countdownController.seconds.value.toString().padLeft(2, '0')}',
                  totalScore,
                  widget.model.subjectcode);

              APIs.NoticeSeeScoreHS(
                  '${countdownController.minutes.value}:${countdownController.seconds.value.toString().padLeft(2, '0')}',
                  totalScore,
                  widget.model.subjectcode,
                  widget.model.namesubject);

              Dialogs.showSnackBar(context,
                  'Bạn đã nộp bài thành công \n Điểm của bạn là $totalScore');
              Navigator.pop(context);
            },
            child: const Text('Nộp bài'),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  APIs.getQuestion(widget.model.subjectcode, widget.model.id),
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
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return QuestionCardHSScreen(
                            model: list[index], index: index);
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
