import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thutext/screen/hocsinh_screen/bottom_screen/bottom_home_hs_screen.dart';
import 'package:thutext/screen/hocsinh_screen/bottom_screen/bottom_notice_hs_screen.dart';
import 'package:thutext/screen/hocsinh_screen/bottom_screen/bottom_profile_hs_screen.dart';

import '../../api/apis.dart';

class HSHomeScreen extends StatefulWidget {
  const HSHomeScreen({super.key});

  @override
  State<HSHomeScreen> createState() => _HSHomeScreenState();
}

class _HSHomeScreenState extends State<HSHomeScreen> {
  List<Widget> pages = [
    BottomHomeHSScreen(),
    BottomNoticeHSScreen(),
    BottomChatHSScreen()
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
      SystemChannels.lifecycle.setMessageHandler((message) {
        if(APIs.auth.currentUser!=null)
        {
          if(message.toString().contains('resume')) APIs.updateActiveStatus(true);
          if(message.toString().contains('pause')) APIs.updateActiveStatus(false);
        }
        return Future.value(message);
      });
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
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Users'),
        ],
      ),
    );
  }
}
