import 'package:flutter/material.dart';
import 'package:thutext/models/quan_tri/malopgv_model.dart';
import 'package:thutext/screen/quantri_screen/widget/list_of_gvhs.dart';

class CardHSOFGV extends StatefulWidget {
  const CardHSOFGV({super.key, required this.model, required this.id});
  final ClassGVModel model;
  final String id;

  @override
  State<CardHSOFGV> createState() => _CardHSOFGVState();
}

class _CardHSOFGVState extends State<CardHSOFGV> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ListHS(
                      mahp: widget.model.mahhp,
                      id: widget.id,
                    )));
      },
      child: Card(
        child: Column(children: [
          Text(
            widget.model.tenmon,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(widget.model.mahhp),
        ]),
      ),
    );
  }
}
