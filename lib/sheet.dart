import 'package:flutter/material.dart';

class SheetPage extends StatelessWidget {
  const SheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プロ研スタンプラリーシート'),
      ),
      body: const Center(
        child: Text('スタンプラリーのスタート地点です'),
      ),
    );
  }
}
