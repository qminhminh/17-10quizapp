import 'package:flutter/material.dart';
import 'package:thutext/api/apis.dart';
import 'package:thutext/models/user_model.dart';
import 'package:thutext/screen/quantri_screen/widget/gv_card.dart';

class AccountGVScreen extends StatefulWidget {
  const AccountGVScreen({super.key});

  @override
  State<AccountGVScreen> createState() => _AccountGVScreenState();
}

class _AccountGVScreenState extends State<AccountGVScreen> {
  List<UserModel> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: APIs.getUser(),
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
                    data?.map((e) => UserModel.fromJson(e.data())).toList() ??
                        [];
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(6),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return GVCard(
                        model: list[index],
                      );
                    });
            }
          }),
    );
  }
}
