import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thutext/screen/auth/login_screen.dart';
import 'package:thutext/screen/auth/signup_screen.dart';
import 'package:thutext/screen/quantri_screen/add_users_hs_vs_gv/add_users_screen.dart';

class BottomHomeQTScreen extends StatefulWidget {
  const BottomHomeQTScreen({super.key});

  @override
  State<BottomHomeQTScreen> createState() => _BottomHomeQTScreenState();
}

class _BottomHomeQTScreenState extends State<BottomHomeQTScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black12,
            child: IconButton(
                splashRadius: 20,
                icon: Icon(Icons.search,
                    size: 24, color: Theme.of(context).iconTheme.color),
                onPressed: () {}),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignUpScreen()));
                    },
                    icon: const Icon(Icons.add)),
                TextButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignUpScreen()));
                    },
                    child:
                        const Text('Tạo tài khoản cho sinh viên và học sinh'))
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const QTAddUsersScreen()));
                    },
                    icon: const Icon(Icons.add)),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const QTAddUsersScreen()));
                    },
                    child: const Text('Thêm học sinh cho giáo viên'))
              ],
            ),
            TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                child: const Text('Đăng xuất '))
          ],
        ),
      ),
    );
  }
}
