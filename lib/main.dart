
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thutext/firebase_options.dart';
import 'package:thutext/screen/spalsh_screen.dart';

late Size mq;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple,
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
