import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thutext/api/apis.dart';
import 'package:thutext/models/notice_model.dart';

class NoticeCard extends StatefulWidget {
  final NoticeModel noteMod;
  const NoticeCard({super.key, required this.noteMod});

  @override
  State<NoticeCard> createState() => _NoticeCardState();
}

class _NoticeCardState extends State<NoticeCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4,vertical: 4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(

        leading: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CachedNetworkImage(
            imageUrl: widget.noteMod.image,
            width: 55,
            height: 55,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person),),
          ),
        ),
        title: Text(widget.noteMod.email,style: TextStyle(fontWeight: FontWeight.bold),),
        subtitle: Text(widget.noteMod.des) ,
        trailing: IconButton(onPressed: (){
           APIs.gedeleteNotice(widget.noteMod.time);
        }, icon: Icon(Icons.more_vert)),
      ),
    ) ;
  }
}
