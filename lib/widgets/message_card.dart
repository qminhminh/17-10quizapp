import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:thutext/image_profile.dart';
import '../api/apis.dart';
import '../helpers/dialogs.dart';
import '../helpers/my_date_uti.dart';
import '../models/message.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  const MessageCard({super.key, required this.message});
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage() : _blueMessage(),
    );
  }

  // send or another user message
  Widget _blueMessage() {
    //update laset read mess if sneder and recevier are different
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.lightBlue),
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 17, color: Colors.black54),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(
                        10), // You need to have 'mq' defined
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),

        // time
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
        const SizedBox(
          width: 4,
        )
      ],
    );
  }

  // our or user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // time
        Row(
          children: [
            const SizedBox(
              width: 4,
            ),
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),
            const SizedBox(
              width: 2,
            ),
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),

        // message
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.lightGreen),
                color: Colors.green.shade50,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 17, color: Colors.black54),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(
                        10), // You need to have 'mq' defined
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // botom sheet
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),

              widget.message.type == Type.text
                  ?
                  // option COPY TEXT
                  _OpionItem(
                      icon: const Icon(
                        Icons.copy_all_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: 'Sao chép',
                      onTap: () {
                        Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          Navigator.pop(context);
                        });
                      })
                  :
                  // option COPY TEXT
                  _OpionItem(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: 'Tải ảnh xuống',
                      onTap: () async {
                        try {
                          var response = await Dio().get(
                            widget.message.msg,
                            options: Options(responseType: ResponseType.bytes),
                          );
                          final result = await ImageGallerySaver.saveImage(
                            Uint8List.fromList(response.data),
                          );
                          if (result != null && result['isSuccess']) {
                            log("Image saved successfully!");
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            // ignore: use_build_context_synchronously
                            Dialogs.showSnacker(context, 'Save Image Success');
                          } else {
                            log("Image saving failed.");
                          }
                        } catch (error) {
                          log("Error saving image: $error");
                        }
                      }),

              if (widget.message.type == Type.image)
                _OpionItem(
                    icon: const Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 26,
                    ),
                    name: 'Xem chi tiết ảnh',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ImageProfile(message: widget.message)));
                    }),

              if (isMe)
                const Divider(
                  color: Colors.black54,
                  endIndent: 4,
                  indent: 4,
                ),

              // OPTION EDIT
              if (widget.message.type == Type.text && isMe)
                _OpionItem(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                      size: 26,
                    ),
                    name: 'Sửa',
                    onTap: () {
                      Navigator.pop(context);
                      _showMessageUpdate();
                    }),

              // OPTION DELETE
              if (isMe)
                _OpionItem(
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Colors.blue,
                      size: 26,
                    ),
                    name: 'Xóa tin nhắn',
                    onTap: () async {
                      await APIs.gedeleteMessa(widget.message).then((value) {
                        Navigator.pop(context);
                        Dialogs.showSnacker(context, 'Delete Success');
                      });
                    }),

              const Divider(
                color: Colors.black54,
                endIndent: 4,
                indent: 4,
              ),

              // SEND TIME
              _OpionItem(
                  icon: const Icon(
                    Icons.access_time,
                    color: Colors.blue,
                    size: 26,
                  ),
                  name:
                      'Thời gian gửi: ${MyDateUtil.getMessgaeTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),

              // READ TIME
              _OpionItem(
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.blue,
                    size: 26,
                  ),
                  name: widget.message.read.isEmpty
                      ? 'Read at: Not seen yet'
                      : 'Thời gian đã đọc: ${MyDateUtil.getMessgaeTime(context: context, time: widget.message.read)}',
                  onTap: () {}),
            ],
          );
        });
  }

  void _showMessageUpdate() {
    String updatedMsg = widget.message.msg;
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Row(
                children: [
                  Icon(
                    Icons.message,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Update Message')
                ],
              ),
              content: TextFormField(
                maxLines: null,
                onChanged: (val) => updatedMsg = val,
                //onSaved: (val)=> updatedMsg = val!,
                initialValue: updatedMsg,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancle',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    APIs.UpdateMessa(widget.message, updatedMsg);
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                )
              ],
            ));
  }
}

class _OpionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OpionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, top: 15, bottom: 25),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              '    $name',
              style: const TextStyle(
                fontSize: 15,
              ),
            )),
          ],
        ),
      ),
    );
  }
}
