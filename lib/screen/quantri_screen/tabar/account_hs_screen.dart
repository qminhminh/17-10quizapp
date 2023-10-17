import 'package:flutter/material.dart';
import 'package:thutext/api/apis.dart';
import 'package:thutext/models/user_model.dart';
import 'package:thutext/screen/quantri_screen/widget/hs_card.dart';

class AccountHSScreen extends StatefulWidget {
  const AccountHSScreen({super.key});

  @override
  State<AccountHSScreen> createState() => _AccountHSScreenState();
}

class _AccountHSScreenState extends State<AccountHSScreen> {
  List<UserModel> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: APIs.getUser(),
          builder: (context, snapshot){
             switch(snapshot.connectionState){
               case ConnectionState.waiting:
               case ConnectionState.none:
                 return Center(child: CircularProgressIndicator(),); // Thêm trường hợp ConnectionState.none
               case ConnectionState.active:
               case ConnectionState.done:
                 final data = snapshot.data?.docs;
                 list = data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];
                 return ListView.builder(
                     shrinkWrap: true,
                     physics: BouncingScrollPhysics(),
                     padding: EdgeInsets.all(6),
                     itemCount: list.length,
                     itemBuilder: (context,index){
                       return HSCard(model: list[index],);
                     }
                 );
             }
          }
      ),
    );
  }
}
