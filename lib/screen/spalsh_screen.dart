// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thutext/screen/giaovien_screen/gv_home_screen.dart';
import 'package:thutext/screen/hocsinh_screen/hs_home_screen.dart';
import 'package:thutext/screen/quantri_screen/qt_home_screen.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');
      if (email == null || email.isEmpty) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      } else if (email.contains('hs')) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const HSHomeScreen()));
      } else if (email.contains('gv')) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const GVHomeScreen()));
      } else if (email.contains('qt')) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const QTHomeScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * .15,
            right: MediaQuery.of(context).size.width * .25,
            width: MediaQuery.of(context).size.width * .5,
            child: Image.asset(
              'images/quizz.png',
              width: 400,
              height: 400,
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * .15,
            width: MediaQuery.of(context).size.width * .8,
            child: const Center(
                child: Text(
              'Hãy đến với quizz app ❤ 💖',
              style: TextStyle(
                  fontSize: 16, color: Colors.black, letterSpacing: .5),
              textAlign: TextAlign.center,
            )),
          ),
        ],
      ),
    );
  }
}
