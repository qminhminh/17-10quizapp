import 'package:flutter/material.dart';

class Dialogs{
  static void showSnacker(BuildContext context,String msg){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg),
      backgroundColor: Colors.orangeAccent,
      behavior: SnackBarBehavior.floating,
    ));
  }

  static void showProgressBar(BuildContext context){
     showDialog(context: context, builder: (_)=>Center(child: CircularProgressIndicator()));
  }
}