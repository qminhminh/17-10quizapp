import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thutext/models/user_model.dart';

class CardListHS extends StatefulWidget {
  const CardListHS({super.key, required this.model});
  final UserModel model;

  @override
  State<CardListHS> createState() => _CardListHSState();
}

class _CardListHSState extends State<CardListHS> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: CachedNetworkImage(
          width: 55,
          height: 55,
          imageUrl: widget.model.image,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const CircleAvatar(
            child: Icon(CupertinoIcons.person),
          ),
        ),
      ),
      title: Text(
        widget.model.name,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(widget.model.email),
    );
  }
}
