import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thutext/models/user_model.dart';

class HSCard extends StatefulWidget {
  final UserModel model;
  const HSCard({super.key, required this.model});

  @override
  State<HSCard> createState() => _HSCardState();
}

class _HSCardState extends State<HSCard> {
  @override
  Widget build(BuildContext context) {
    final a = widget.model.email.contains('hs');
    return a
        ? ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: CachedNetworkImage(
                width: 55,
                height: 55,
                imageUrl: widget.model.image,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const CircleAvatar(
                  child: Icon(CupertinoIcons.person),
                ),
              ),
            ),
            title: Text(widget.model.name),
            subtitle: Text(widget.model.email),
            trailing: IconButton(
                onPressed: () {}, icon: const Icon(Icons.delete_forever)),
          )
        : const Text('');
  }
}
