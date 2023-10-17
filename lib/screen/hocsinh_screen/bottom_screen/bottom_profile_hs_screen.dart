import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../auth/login_screen.dart';

class BottomProfileHSScreen extends StatefulWidget {
  const BottomProfileHSScreen({super.key});

  @override
  State<BottomProfileHSScreen> createState() => _BottomProfileHSScreenState();
}

class _BottomProfileHSScreenState extends State<BottomProfileHSScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child:  TextButton(onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
        }, child: Text('Đăng xuất ')),
      ),
    );
  }
}
