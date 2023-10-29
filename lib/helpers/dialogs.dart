import 'package:flutter/material.dart';

class Dialogs {
  static void showSnacker(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.orangeAccent,
      behavior: SnackBarBehavior.floating,
    ));
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => const Center(child: CircularProgressIndicator()));
  }

  static void showSnackBar(BuildContext context, String mss) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 100,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Text(
            mss,
            style: const TextStyle(fontSize: 20, color: Colors.black54),
          ),
        ),
      ),
      duration: const Duration(milliseconds: 4500),
      backgroundColor: Colors.grey[300],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          right: 20,
          left: 20),
    ));
  }
}
