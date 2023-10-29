import 'package:flutter/material.dart';

class BottomHSOfGVScreen extends StatefulWidget {
  const BottomHSOfGVScreen({super.key});

  @override
  State<BottomHSOfGVScreen> createState() => _BottomHSOfGVScreenState();
}

class _BottomHSOfGVScreenState extends State<BottomHSOfGVScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Học sinh'),
      ),
    );
  }
}
