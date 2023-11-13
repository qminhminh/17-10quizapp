import 'package:flutter/material.dart';
import 'package:thutext/api/apis.dart';
import 'package:thutext/loader.dart';
import 'package:thutext/models/quan_tri/malopgv_model.dart';
import 'package:thutext/models/user_model.dart';
import 'package:thutext/screen/quantri_screen/widget/card_list_hs_of_gv.dart';

class ListHSOFGV extends StatefulWidget {
  final UserModel model;
  const ListHSOFGV({super.key, required this.model});

  @override
  State<ListHSOFGV> createState() => _ListHSOFGVState();
}

class _ListHSOFGVState extends State<ListHSOFGV> {
  List<ClassGVModel> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: APIs.getMonOFGVClass(widget.model.id),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(
                child: CircularProgressIndicator(),
              ); // Thêm trường hợp ConnectionState.none
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list =
                  data?.map((e) => ClassGVModel.fromJson(e.data())).toList() ??
                      [];

              // ignore: unnecessary_null_comparison
              return list == null
                  ? const Loader()
                  : list.isEmpty
                      ? const Center(child: Text('No messages available'))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: list.length,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(6),
                          itemBuilder: (context, index) {
                            return CardHSOFGV(
                              model: list[index],
                              id: widget.model.id,
                            );
                          },
                        );
          }
        },
      ),
    );
  }
}
