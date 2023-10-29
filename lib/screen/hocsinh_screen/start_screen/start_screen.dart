import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../list_question/list_hs_question.dart';
import '../../../models/giao_vien/create_description_model.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key, required this.model});
  final CreateDescriptMode model;

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final targetTime = DateFormat('dd/MM/yyyy').parse(widget.model.timetext);
    final our = targetTime.add(Duration(
        hours: int.parse(widget.model.our),
        minutes: int.parse(widget.model.minus)));

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Môn: ',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  Text(
                    widget.model.namesubject,
                    style: const TextStyle(fontSize: 18),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Ngày làm bài: ',
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    widget.model.timetext,
                    style: const TextStyle(fontSize: 17),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Giờ bắt đàu làm bài: ',
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    '${widget.model.our} : ${widget.model.minus}',
                    style: const TextStyle(fontSize: 17),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Thời gian làm bài -: ',
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    '${(int.parse(widget.model.timeQues) / 60).ceil()} phút',
                    style: const TextStyle(fontSize: 17),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Lưu ý: ',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.model.description,
                    style: const TextStyle(fontSize: 17),
                  )
                ],
              ),
              TextButton(
                  onPressed: () {
                    if (now.isAfter(our)) {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                contentPadding: const EdgeInsets.only(
                                    left: 24, right: 24, top: 20, bottom: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                title: const Row(
                                  children: [Text('Sẵn sàng làm bài ')],
                                ),
                                actions: [
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Quay lại',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.blue),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  ListQuestionHSScreen(
                                                      model: widget.model)));
                                    },
                                    child: const Text(
                                      'Bắt đầu',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.blue),
                                    ),
                                  )
                                ],
                              ));
                    } else {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                contentPadding: const EdgeInsets.only(
                                    left: 24, right: 24, top: 20, bottom: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                title: const Row(
                                  children: [
                                    Text('Chưa tới thời gian làm bài ')
                                  ],
                                ),
                                actions: [
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Quay lại',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.blue),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      '',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.blue),
                                    ),
                                  )
                                ],
                              ));
                    }
                  },
                  child: const Text(
                    'Bắt đầu làm',
                    style: TextStyle(fontSize: 19),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
