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
  static const stamp_position = [
    [33.895035283572184, 130.83913257377353],
    [33.895372549525625, 130.84023604777587],
    [33.89500932367183, 130.84079013291944],
    [33.894275995781406, 130.8386275132089],
    [33.894183902536696, 130.8400911980695],
    [33.893457834998614, 130.83918482825203],
    [33.8904262359517, 130.83873983917533],
    [33.89094986326708, 130.8392869599504],
    [33.89082184819561, 130.8411399411388]
  ];
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'プログラミング研究会 スタンプラリー',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF5592B4),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GridView.count(
                      padding: const EdgeInsets.all(4),
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      crossAxisCount: 3,
                      shrinkWrap: true, // グリッドの高さを内容に合わせる
                      children: List.generate(
                          9,
                          (index) => Container(
                                padding: const EdgeInsets.all(20),
                                child: Center(
                                  child: const Text('STAMP'),
                                ),
                                color: Color(0xFF5592B4),
                              )),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "ビンゴ出来たら 景品ゲット!!\nビンゴすればするほど景品が豪華になるかも!?",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text(
                      '戻る',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            child: const Text(
              'スタンプラリー\nシートはこちら',
              style: TextStyle(color: Color(0xFF5592B4)),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
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
            position: const LatLng(33.894275995781406, 130.8386275132089),
            infoWindow: InfoWindow(
              title: '九工大保健センター',
              onTap: () {},
            ),
          ),
          Marker(
            markerId: const MarkerId('marker_id_5'),
            position: const LatLng(33.894183902536696, 130.8400911980695),
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
            position: const LatLng(33.8904262359517, 130.83873983917533),
            infoWindow: InfoWindow(
              title: '檣山館',
              onTap: () {},
            ),
          ),
          Marker(
            markerId: const MarkerId('marker_id_8'),
            position: const LatLng(33.89094986326708, 130.8392869599504),
            infoWindow: InfoWindow(
              title: 'GYMLABO',
              onTap: () {},
            ),
          ),
          Marker(
            markerId: const MarkerId('marker_id_9'),
            position: const LatLng(33.89082184819561, 130.8411399411388),
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
              Future(() async {
                LocationPermission permission =
                    await Geolocator.checkPermission();
                if (permission == LocationPermission.denied) {
                  await Geolocator.requestPermission();
                }
                Position position = await Geolocator.getCurrentPosition();

                for (final stamp in stamp_position) {
                  double distncce = distanceBetween(
                      // 東京駅
                      position.latitude,
                      position.longitude,
                      stamp[0],
                      stamp[1]);
                  if (distncce <= 3) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          content: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Image.asset('assets/images/star.png'),
                              Positioned(
                                top: 80,
                                child: Text(
                                  'スタンプ\nGET',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          content: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Image.asset('assets/images/rectangle.png'),
                              Positioned(
                                top: 80,
                                child: Text(
                                  '!!!!!!!!!!!!!!!!!!!\n\n目的地から離れています\nもう少し近づいてください\n\n!!!!!!!!!!!!!!!!!!!',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                }
              });
            },
            child: Image.asset('../assets/images/floating_image.png'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ],
      ),
    );
  }
}
