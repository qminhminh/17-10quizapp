import 'package:flutter/material.dart';
import 'package:thutext/models/quan_tri/malopgv_model.dart';
import 'package:thutext/screen/giaovien_screen/widget/hs_of_gv.dart';

class MonDayOfGvCard extends StatefulWidget {
  final ClassGVModel model;
  const MonDayOfGvCard({super.key, required this.model});

  @override
  State<MonDayOfGvCard> createState() => _MonDayOfGvCardState();
}

class _MonDayOfGvCardState extends State<MonDayOfGvCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HSOFGv(
                model: widget.model,
              );
            },
          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 5, // Increase the elevation for a shadow effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Add rounded corners
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model.tenmon,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.model.mahhp),
          )
        ]),
      ),
    );
  }
}
