import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thutext/screen/giaovien_screen/bottom_screen/bottom_home_gv_screen.dart';
import 'package:thutext/screen/giaovien_screen/bottom_screen/bottom_notice_gv_screen.dart';
import 'package:thutext/screen/giaovien_screen/bottom_screen/bottom_profile_gv_screen.dart';

class GVHomeScreen extends StatefulWidget {
  const GVHomeScreen({super.key});

  @override
  State<GVHomeScreen> createState() => _GVHomeScreenState();
}

class _GVHomeScreenState extends State<GVHomeScreen> {

  List<Widget> pages = [
   BottomHomeGVcreen(),
    BottomNoticeGVcreen(),
    BottomProfileGVScreen()
  ];
  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }
  @override
  void initState() {
    super.initState();
    SystemChannels.lifecycle.setMessageHandler((message) async {
      if(message.toString().contains('pause')) await FirebaseAuth.instance.signOut();
      return Future.value(message);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active_outlined), label: 'Notice'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Users'),
        ],
      ),
    );
  }
}