import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thutext/screen/quantri_screen/bottom_screen/bottom_user_home_screen.dart';
import '../../api/apis.dart';
import 'bottom_screen/bottom_home_qt_screen.dart';
import 'bottom_screen/bottom_notice_qt_screen.dart';
import 'bottom_screen/bottom_profile_qt_screen.dart';


class QTHomeScreen extends StatefulWidget {
  const QTHomeScreen({super.key});

  @override
  State<QTHomeScreen> createState() => _QTHomeScreenState();
}

class _QTHomeScreenState extends State<QTHomeScreen> {

  List<Widget> pages = [
    BottomHomeQTScreen(),
    BotomNoticeQTScreen(),
    BottomUserQTScreen(),
    BottomProfileQTScreen()
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
          BottomNavigationBarItem(icon: Icon(Icons.account_box_outlined), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'User'),
        ],
      ),
    );
  }
}
