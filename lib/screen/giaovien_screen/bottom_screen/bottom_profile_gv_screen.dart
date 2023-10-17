import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../auth/login_screen.dart';

class BottomProfileGVScreen extends StatefulWidget {
  const BottomProfileGVScreen({super.key});

  @override
  State<BottomProfileGVScreen> createState() => _BottomProfileGVScreenState();
}

class _BottomProfileGVScreenState extends State<BottomProfileGVScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child:  TextButton(onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
          }, child: Text('Đăng xuất ')),
        ),
      ),
    );
  }
}
