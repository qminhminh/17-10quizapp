// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print

import 'package:flutter/material.dart';
import 'package:thutext/api/apis.dart';
import '../models/giao_vien/create_question_model.dart';

class QuestionCardScreen extends StatefulWidget {
  const QuestionCardScreen(
      {super.key,
      required this.model,
      required this.index,
      required this.length});
  final QuestionModel model;
  final int index;
  final int length;

  @override
  State<QuestionCardScreen> createState() => _QuestionCardScreenState();
}

class _QuestionCardScreenState extends State<QuestionCardScreen> {
  String selectedAnswer = '';
  int count = 0;
  // Câu trả lời đúng

  @override
  Widget build(BuildContext context) {
    double a = 10 / widget.length;
    return Center(
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '     Câu ${widget.index + 1}:  ',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(widget.model.question,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            RadioListTile(
              value: widget.model.option1,
              groupValue: selectedAnswer,
              onChanged: (value) {
                setState(() {
                  selectedAnswer = value!;
                  if (selectedAnswer == widget.model.optioncorrect) {
                    count++;
                    print('Điểm số: ${a}');
                    APIs.createScore(a, widget.model.subjectcode);

                    print('Câu trả lời đúng!');
                  } else {
                    print('Câu trả lời sai.');
                  }
                });
              },
              title: Text(widget.model.option1),
            ),
            RadioListTile(
              value: widget.model.option2,
              groupValue: selectedAnswer,
              onChanged: (value) {
                setState(() {
                  selectedAnswer = value!;
                  if (selectedAnswer == widget.model.optioncorrect) {
                    count++;
                    print('Điểm số: ${a}');
                    APIs.createScore(a, widget.model.subjectcode);
                    print('Câu trả lời đúng!');
                  } else {
                    print('Câu trả lời sai.');
                  }
                });
              },
              title: Text(widget.model.option2),
            ),
            RadioListTile(
              value: widget.model.option3,
              groupValue: selectedAnswer,
              onChanged: (value) {
                setState(() {
                  selectedAnswer = value!;
                  if (selectedAnswer == widget.model.optioncorrect) {
                    count++;
                    print('Điểm số: ${a}');
                    APIs.createScore(a, widget.model.subjectcode);
                    print('Câu trả lời đúng!');
                  } else {
                    print('Câu trả lời sai.');
                  }
                });
              },
              title: Text(widget.model.option3),
            ),
            RadioListTile(
              value: widget.model.option4,
              groupValue: selectedAnswer,
              onChanged: (value) {
                setState(() {
                  selectedAnswer = value!;
                  if (selectedAnswer == widget.model.optioncorrect) {
                    count++;
                    print('Điểm số: ${a}');
                    APIs.createScore(a, widget.model.subjectcode);

                    print('Câu trả lời đúng!');
                  } else {
                    print('Câu trả lời sai.');
                  }
                });
              },
              title: Text(widget.model.option4),
            ),
          ],
        ),
      ),
    );
  }
}
