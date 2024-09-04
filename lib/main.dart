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
        actions: <Widget>[
          TextButton(
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text("Notifications"),
                content: const Text("Do you allow notifications?"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'Approve');
                      // Add any action you want to take on approval here
                    },
                    child: const Text('Approve'),
                  ),
                ],
              ),
            ),
            child: const Text('Show Dialog'),
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(33.8924, 130.8403),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('marker_id_1'),
            position: const LatLng(33.894089406192165, 130.83900584969544),
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
            position: const LatLng(33.89494869947517, 130.8408294074091),
            infoWindow: InfoWindow(
              title: '未来型インタラクティブ教育棟',
              onTap: () {},
            ),
          ),
          Marker(
            markerId: const MarkerId('marker_id_1'),
            position: const LatLng(33.89425866046764, 130.83856570304084),
            infoWindow: InfoWindow(
              title: '九工大保健センター',
              onTap: () {},
            ),
          ),
          Marker(
            markerId: const MarkerId('marker_id_1'),
            position: const LatLng(33.89413213192453, 130.84009168220786),
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
            position: const LatLng(33.890334652977955, 130.83856994989253),
            infoWindow: InfoWindow(
              title: '檣山館',
              onTap: () {},
            ),
          ),
          Marker(
            markerId: const MarkerId('marker_id_2'),
            position: const LatLng(33.890989889065104, 130.83951037139482),
            infoWindow: InfoWindow(
              title: 'GYMLABO',
              onTap: () {},
            ),
          ),
          Marker(
            markerId: const MarkerId('marker_id_1'),
            position: const LatLng(33.89083695908754, 130.84116131415504),
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
