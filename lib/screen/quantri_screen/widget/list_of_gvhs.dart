import 'package:flutter/material.dart';
import 'package:thutext/api/apis.dart';
import 'package:thutext/loader.dart';
import 'package:thutext/models/user_model.dart';
import 'package:thutext/screen/quantri_screen/widget/card_list_hs.dart';

class ListHS extends StatefulWidget {
  const ListHS({super.key, required this.mahp, required this.id});
  final String mahp;
  final String id;

  @override
  State<ListHS> createState() => _ListHSState();
}

class _ListHSState extends State<ListHS> {
  List<UserModel> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: APIs.getNoticeIdHS(widget.id),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(
                  child: CircularProgressIndicator(),
                ); // Thêm trường hợp ConnectionState.none
              case ConnectionState.active:
              case ConnectionState.done:
                return StreamBuilder(
                    stream: APIs.getAllUser(
                        snapshot.data!.docs.map((e) => e.id).toList() ?? []),
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
                          list = data
                                  ?.map((e) => UserModel.fromJson(e.data()))
                                  .toList() ??
                              [];
                          // ignore: unnecessary_null_comparison
                          return list == null
                              ? const Loader()
                              : list.isEmpty
                                  ? const Center(
                                      child: Text('No messages available'))
                                  : ListView.builder(
                                      itemCount: list.length,
                                      padding: const EdgeInsets.only(top: 2),
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return CardListHS(model: list[index]);
                                      });
                      }
                    });
            }
          }),
    );
  }
}
