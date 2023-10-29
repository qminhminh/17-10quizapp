import 'package:flutter/material.dart';
import 'package:thutext/api/apis.dart';
import 'package:thutext/models/quan_tri/malopgv_model.dart';
import 'package:thutext/screen/giaovien_screen/widget/list_monday_card.dart';

class BottomHSOfGVScreen extends StatefulWidget {
  const BottomHSOfGVScreen({super.key});

  @override
  State<BottomHSOfGVScreen> createState() => _BottomHSOfGVScreenState();
}

class _BottomHSOfGVScreenState extends State<BottomHSOfGVScreen> {
  List<ClassGVModel> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Môn Học'),
      ),
      body: StreamBuilder(
        stream: APIs.getMonOFGV(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data!.docs;
              list =
                  data.map((e) => ClassGVModel.fromJson(e.data())).toList() ??
                      [];
              if (list.isNotEmpty) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(6),
                    itemBuilder: (context, intdex) {
                      return MonDayOfGvCard(
                        model: list[intdex],
                      );
                    });
              } else {
                return const Center(
                    child: Text(
                  'Chưa có bài nào',
                  style: TextStyle(fontSize: 20),
                ));
              }
          }
        },
      ),
    );
  }
}
