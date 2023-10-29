import 'package:flutter/material.dart';
import 'package:thutext/helpers/my_date_uti.dart';
import 'package:thutext/models/hoc_sinh/notice_score.dart';

class ScoreCardHs extends StatefulWidget {
  final NoticeScoreHSModel model;
  const ScoreCardHs({super.key, required this.model});

  @override
  State<ScoreCardHs> createState() => _ScoreCardHsState();
}

class _ScoreCardHsState extends State<ScoreCardHs> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5, // Increase the elevation for a shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Add rounded corners
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Tên môn :${widget.model.namemh}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Email :${widget.model.email}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Mã học phần :${widget.model.mahp}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Điểm :${widget.model.score}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Thời gian nộp :${widget.model.time}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Ngày :${MyDateUtil.getLastActiveTime(context: context, lastActive: widget.model.date)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
      ]),
    );
  }
}
