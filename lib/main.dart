import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proken_stamp_rally/sheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プロ研スタンプラリー'),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(33.8924, 130.8403),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('marker_id_1'),
            position: const LatLng(33.8924, 130.8403),
            infoWindow: InfoWindow(
              title: '東京タワー',
              onTap: () {
                print('タップされました');
              },
            ),
          ),
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SheetPage()),
        );
      }),
    );
  }
}
