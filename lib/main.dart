import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proken_stamp_rally/sheet.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:math';
void main() {
  runApp(const MyApp());
}
double distanceBetween(
    double latitude1,
    double longitude1,
    double latitude2,
    double longitude2,
    ) {
  final toRadians = (double degree) => degree * pi / 180;
  final double r = 6378137.0; // 地球の半径
  final double f1 = toRadians(latitude1);
  final double f2 = toRadians(latitude2);
  final double l1 = toRadians(longitude1);
  final double l2 = toRadians(longitude2);
  final num a = pow(sin((f2 - f1) / 2), 2);
  final double b = cos(f1) * cos(f2) * pow(sin((l2 - l1) / 2), 2);
  final double d = 2 * r * asin(sqrt(a + b));
  return d;
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
  Position? currentPosition;
  @override
  static const stamp_position = [[33.895035283572184, 130.83913257377353],[33.895372549525625, 130.84023604777587],[33.895372549525625, 130.84023604777587],[33.8946155744977, 130.83856023612142],[33.89411685787378, 130.84027543026494],[33.893457834998614, 130.83918482825203],[33.89083059857828, 130.83869218826715],[33.891003891463605, 130.8412420164143]];
  void initState() {
    super.initState();
  }
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
            markerId: const MarkerId('marker_id_2'),
            position: const LatLng(33.895372549525625, 130.84023604777587),
            infoWindow: InfoWindow(
              title: '九州工業大学 戸畑キャンパス記念講堂',
              onTap: () {},
            ),
          ),
          Marker(

            markerId: const MarkerId('marker_id_3'),
            position: const LatLng(33.89500932367183, 130.84079013291944),
            infoWindow: InfoWindow(
              title: '未来型インタラクティブ教育棟',
              onTap: () {},
            ),
          ),
          Marker(

            markerId: const MarkerId('marker_id_4'),
            position: const LatLng(33.8946155744977, 130.83856023612142),
            infoWindow: InfoWindow(
              title: '九工大保健センター',
              onTap: () {},
            ),
          ),
          Marker(

            markerId: const MarkerId('marker_id_5'),
            position: const LatLng(33.89411685787378, 130.84027543026494),
            infoWindow: InfoWindow(
              title: '九州工業大学 附属図書館',
              onTap: () {},
            ),
          ),
          Marker(
            markerId: const MarkerId('marker_id_6'),
            position: const LatLng(33.893457834998614, 130.83918482825203),
            infoWindow: InfoWindow(
              title: '九州工業大学生活協同組合 戸畑食堂',
              onTap: () {},
            ),
          ),
          Marker(

            markerId: const MarkerId('marker_id_7'),
            position: const LatLng(33.89083059857828, 130.83869218826715),
            infoWindow: InfoWindow(
              title: '檣山館',
              onTap: () {},
            ),
          ),
          Marker(

            markerId: const MarkerId('marker_id_8'),
            position: const LatLng(33.89115121480716, 130.83946466447486),
            infoWindow: InfoWindow(
              title: 'GYMLABO',
              onTap: () {},
            ),
          ),
          Marker(

            markerId: const MarkerId('marker_id_9'),
            position: const LatLng(33.891003891463605, 130.8412420164143),
            infoWindow: InfoWindow(
              title: 'ものづくり工房',
              onTap: () {},
            ),
          ),
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          FloatingActionButton(
            onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SheetPage()),
                  );
            },
            child: Image.asset('../assets/images/floating_image.png'),
            backgroundColor: Color(0xFF5592B4),
          ),
          FloatingActionButton(
            onPressed: () {
              Future(() async {
                LocationPermission permission = await Geolocator.checkPermission();
                if(permission == LocationPermission.denied){
                  await Geolocator.requestPermission();
                }
                Position position = await Geolocator.getCurrentPosition();

                for (final stamp in  stamp_position)
                  {
                    double distncce = distanceBetween(
                      // 東京駅
                        position.latitude,
                        position.longitude,
                        stamp[0],
                        stamp[1]
                    );
                    if(distncce <= 3)
                      {
                       print("スタンプが押せます");
                      }
                    else
                      {
                        print("距離が遠いです");
                      }

                  }

              });
            },
            child: Text('位置☑'),
          ),
        ],
      ),
    );
  }
}
