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
            position: const LatLng(33.895035283572184, 130.83913257377353),
            infoWindow: InfoWindow(
              title: 'C-2C',
              onTap: () {},
            ),
          ),
          Marker(
            markerId: const MarkerId('marker_id_1'),
            position: const LatLng(33.895372549525625, 130.84023604777587),
            infoWindow: InfoWindow(
              title: '九州工業大学 戸畑キャンパス記念講堂',
              onTap: () {},
            ),
          ),
          Marker(
            markerId: const MarkerId('marker_id_1'),
            position: const LatLng(33.89500932367183, 130.84079013291944),
            infoWindow: InfoWindow(
              title: 'Interactive Educational Building',
              onTap: () {},
            ),
          ),
          Marker(
            markerId: const MarkerId('marker_id_1'),
            position: const LatLng(33.8946155744977, 130.83856023612142),
            infoWindow: InfoWindow(
              title: '九工大保健センター',
              onTap: () {},
            ),
          ),
          Marker(
            markerId: const MarkerId('marker_id_1'),
            position: const LatLng(33.89411685787378, 130.84027543026494),
            infoWindow: InfoWindow(
              title: '九州工業大学 附属図書館',
              onTap: () {},
            ),
          ),
          Marker(
            markerId: const MarkerId('marker_id_1'),
            position: const LatLng(33.893457834998614, 130.83918482825203),
            infoWindow: InfoWindow(
              title: '九州工業大学生活協同組合 戸畑食堂',
              onTap: () {},
            ),
          ),
          Marker(
            markerId: const MarkerId('marker_id_1'),
            position: const LatLng(33.89083059857828, 130.83869218826715),
            infoWindow: InfoWindow(
              title: '檣山館',
              onTap: () {},
            ),
          ),
          Marker(
            markerId: const MarkerId('marker_id_2'),
            position: const LatLng(33.89115121480716, 130.83946466447486),
            infoWindow: InfoWindow(
              title: 'GYMLABO',
              onTap: () {},
            ),
          ),
          Marker(
            markerId: const MarkerId('marker_id_1'),
            position: const LatLng(33.891003891463605, 130.8412420164143),
            infoWindow: InfoWindow(
              title: 'ものづくり工房',
              onTap: () {},
            ),
          ),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SheetPage()),
          );
        },
        child: Image.asset('../assets/images/floating_image.png'),
        backgroundColor: Color(0xFF5592B4),
      ),
    );
  }
}
