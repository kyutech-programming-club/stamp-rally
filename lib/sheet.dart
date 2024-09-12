import 'package:flutter/material.dart';

class SheetPage extends StatelessWidget {
  const SheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('プログラミング研究会 スタンプラリー'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/image.png', width: 200, height: 200),
                      Image.asset('assets/images/image(1).png', width: 100, height: 100),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/image.png', width: 200, height: 200),
                      Image.asset('assets/images/image(2).png', width: 100, height: 100),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/image.png', width: 200, height: 200),
                      Image.asset('assets/images/image(3).png', width: 100, height: 100),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/image.png', width: 200, height: 200),
                      Image.asset('assets/images/image(4).png', width: 100, height: 100),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/image.png', width: 200, height: 200),
                      Image.asset('assets/images/image(5).png', width: 100, height: 100),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/image.png', width: 200, height: 200),
                      Image.asset('assets/images/image(6).png', width: 100, height: 100),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/image.png', width: 200, height: 200),
                      Image.asset('assets/images/image(7).png', width: 100, height: 100),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/image.png', width: 200, height: 200),
                      Image.asset('assets/images/image(8).png', width: 100, height: 100),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/image.png', width: 200, height: 200),
                      Image.asset('assets/images/image(9).png', width: 100, height: 100),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 50),
              const Text(
                'ビンゴできたら景品ゲット！！\nビンゴすればするほど景品が豪華になるかも！？',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
