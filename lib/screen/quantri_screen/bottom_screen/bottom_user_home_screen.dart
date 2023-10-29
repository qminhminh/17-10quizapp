import 'package:flutter/material.dart';
import 'package:thutext/screen/quantri_screen/tabar/account_gv_screen.dart';
import 'package:thutext/screen/quantri_screen/tabar/account_hs_screen.dart';

class BottomUserQTScreen extends StatefulWidget {
  const BottomUserQTScreen({super.key});

  @override
  State<BottomUserQTScreen> createState() => _BottomUserQTScreenState();
}

class _BottomUserQTScreenState extends State<BottomUserQTScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.account_box_outlined)),
                Tab(icon: Icon(Icons.account_box_sharp)),
              ],
            ),
            title: const Text('Tất cả tài khoản'),
          ),
          body: const TabBarView(
            children: [
              AccountHSScreen(),
              AccountGVScreen(),
            ],
          ),
        ));
  }
}
