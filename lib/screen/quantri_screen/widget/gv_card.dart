import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thutext/api/apis.dart';
import 'package:thutext/helpers/dialogs.dart';
import 'package:thutext/models/user_model.dart';

class GVCard extends StatefulWidget {
  final UserModel model;
  const GVCard({super.key, required this.model});

  @override
  State<GVCard> createState() => _GVCardState();
}

class _GVCardState extends State<GVCard> {
  @override
  Widget build(BuildContext context) {
    final a = widget.model.email.contains('gv');
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
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            contentPadding: const EdgeInsets.only(
                                left: 24, right: 24, top: 20, bottom: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            title: const Row(
                              children: [Text('Bạn muốn có muốn xóa?')],
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
                                  APIs.gedeleteUserQT(
                                      widget.model.email, widget.model.id);

                                  Dialogs.showSnacker(
                                      context, 'Xóa thành công');
                                },
                                child: const Text(
                                  'Xóa',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.blue),
                                ),
                              )
                            ],
                          ));
                },
                icon: const Icon(Icons.delete_forever)),
          )
        : const Text('');
  }
}
