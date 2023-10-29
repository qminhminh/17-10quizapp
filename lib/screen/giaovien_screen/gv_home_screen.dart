import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thutext/screen/giaovien_screen/bottom_screen/bottom_home_gv_screen.dart';
import 'package:thutext/screen/giaovien_screen/bottom_screen/bottom_hs_of_gv_screen.dart';
import 'package:thutext/screen/giaovien_screen/bottom_screen/bottom_notice_gv_screen.dart';
import 'package:thutext/screen/giaovien_screen/bottom_screen/bottom_profile_gv_screen.dart';
import '../../api/apis.dart';

class GVHomeScreen extends StatefulWidget {
  const GVHomeScreen({super.key});

  @override
  State<GVHomeScreen> createState() => _GVHomeScreenState();
}

class _GVHomeScreenState extends State<GVHomeScreen> {
  List<Widget> pages = [
    const BottomHomeGVcreen(),
    const BottomNoticeGVcreen(),
    const BottomProfileGVScreen(),
    const BottomHSOfGVScreen(),
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
        if (APIs.auth.currentUser != null) {
          if (message.toString().contains('resume'))
            // ignore: curly_braces_in_flow_control_structures
            APIs.updateActiveStatus(true);
          if (message.toString().contains('pause'))
            // ignore: curly_braces_in_flow_control_structures
            APIs.updateActiveStatus(false);
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active_outlined), label: 'Notice'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'HS'),
        ],
      ),
    );
  }
}
