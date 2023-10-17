import 'package:flutter/material.dart';
import 'package:thutext/api/apis.dart';
import '../../../models/giao_vien/create_question_model.dart';


class QuestionCardHSScreen extends StatefulWidget {
  const QuestionCardHSScreen({super.key, required this.model, required this.index});
  final QuestionModel model;
  final int index;

  @override
  State<QuestionCardHSScreen> createState() => _QuestionCardScreenState();
}

class _QuestionCardScreenState extends State<QuestionCardHSScreen> {
  String selectedAnswer='';
  int count = 0;
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
}
