import 'package:flutter/material.dart';
import 'package:thutext/api/apis.dart';
import 'package:thutext/models/giao_vien/create_description_model.dart';
import 'package:thutext/widgets/hs_description_card.dart';

class BottomHomeHSScreen extends StatefulWidget {
  const BottomHomeHSScreen({super.key});

  @override
  State<BottomHomeHSScreen> createState() => _BottomHomeHSScreenState();
}

class _BottomHomeHSScreenState extends State<BottomHomeHSScreen> {
  List<CreateDescriptMode> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Text'),
        leading: const Text(''),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
          stream: APIs.getMaHPId(),
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
                    stream: APIs.getAllQuestion(
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
                                  ?.map((e) =>
                                      CreateDescriptMode.fromJson(e.data()))
                                  .toList() ??
                              [];
                          if (list.isNotEmpty) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: list.length,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.all(6),
                              itemBuilder: (context, index) {
                                return HSDesQesCard(model: list[index]);
                              },
                            );
                          } else {
                            return const Center(
                                child: Text(
                              'Chưa có học phần nào',
                              style: TextStyle(fontSize: 20),
                            ));
                          }
                      }
                    });
            }
          }),
    );
  }
}
