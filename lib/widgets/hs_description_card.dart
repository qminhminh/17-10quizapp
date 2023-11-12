import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:thutext/screen/hocsinh_screen/start_screen/start_screen.dart';
import '../models/giao_vien/create_description_model.dart';

class HSDesQesCard extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const HSDesQesCard({Key? key, required this.model});
  final CreateDescriptMode model;

  @override
  State<HSDesQesCard> createState() => _DesGVQesCardState();
}

class _DesGVQesCardState extends State<HSDesQesCard> {
  String? img;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => StartScreen(model: widget.model)));
      },
      child: Card(
        color: Colors.white,
        elevation: 5, // Increase the elevation for a shadow effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Add rounded corners
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Center(
              child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: widget.model.image,
                  height: 160,
                  width: 350,
                  fit: BoxFit
                      .cover, // Use 'cover' to make the image cover the entire area
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.person)),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 17), // Add padding to the text
              child: Text(
                widget.model.namesubject,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 17), // Add padding to the text
              child: Text(
                'Mã học phần - ${widget.model.subjectcode}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 17), // Add padding to the text
              child: Text(
                'Thời gian làm bài - ${(int.parse(widget.model.timeQues) / 60).ceil()} phút',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
