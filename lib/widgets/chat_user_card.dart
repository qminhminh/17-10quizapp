import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:thutext/chat_screen.dart';
import 'package:thutext/models/user_model.dart';
import '../api/apis.dart';
import '../helpers/my_date_uti.dart';
import '../models/message.dart';

class CharUserCard extends StatefulWidget {
  final UserModel user;
  const CharUserCard({super.key, required this.user});

  @override
  State<CharUserCard> createState() => _CharUserCardState();
}

class _CharUserCardState extends State<CharUserCard> {
  Message? message;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      // inkwell nhạn sự kiện khi nhấn vào
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatScreen(
                        user: widget.user,
                      )));
        },
        child: StreamBuilder(
          stream: APIs.getLastMessages(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) {
              message = list[0];
            }

            return ListTile(
              leading: InkWell(
                onTap: () {
                  /// showDialog(context: context, builder: (_) => ProfileDialog(user: widget.user));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(
                    width: 55,
                    height: 55,
                    imageUrl: widget.user.image,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
                  ),
                ),
              ),
              title: Text(widget.user.name),
              subtitle: Text(message != null ? message!.msg : widget.user.about,
                  maxLines: 2),
              trailing: message == null
                  ? null
                  : message!.read.isEmpty && message!.fromId != APIs.user.uid
                      ? Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                              color: Colors.greenAccent.shade400,
                              borderRadius: BorderRadius.circular(10)),
                        )
                      : Text(MyDateUtil.getLastMessageTime(
                          context: context, time: message!.sent)),
            );
          },
        ),
      ),
    );
  }
}
