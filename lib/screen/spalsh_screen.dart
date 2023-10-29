import 'package:flutter/material.dart';
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
    Future.delayed(const Duration(seconds: 2), () {
      // if(APIs.auth.currentUser!.email!.contains('hs')){
      //   Navigator.push(context, MaterialPageRoute(builder: (_) => HSHomeScreen()));
      // }
      // else if(APIs.auth.currentUser!.email!.contains('gv')){
      //   Navigator.push(context, MaterialPageRoute(builder: (_) => GVHomeScreen()));
      // }
      // else if(APIs.auth.currentUser!.email!.contains('qt')){
      //   Navigator.push(context, MaterialPageRoute(builder: (_) => QTHomeScreen()));
      // }
      // else {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      //}
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
