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
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _showStartDialog(),
    );
  }

  void _showStartDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Image.asset('images/startDialog_pin.png', width: 55, height: 55),
        content: Text(
          "マップにある\nピンの近くに行ったら\n右下のボタンを押して\nスタンプをゲット!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xFFD9D9D9)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              showSecondDialog(context);
            },
            child: Text('次へ'),
          ),
        ],
      );
    },
  );
}

void showSecondDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Image.asset('images/startDialog_checkCircle.png', width: 55, height: 55),
        content: Text(
          "たまったスタンプは\n右上のボタンを押して\n確認できるよ",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xFFD9D9D9)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              showThirdDialog(context); 
            },
            child: Text('次へ'),
          ),
        ],
      );
    },
  );
}

void showThirdDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Image.asset('images/startDialog_error.png', width: 55, height: 55),
        content: Text(
          '位置情報の取得を\n許可してね',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xFFD9D9D9)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('スタート'),
          ),
        ],
      );
    },
  );
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset('assets/images/stamp_back.png',
                                width: 100, height: 100),
                            Image.asset('assets/images/stamp_gymlabo.png',
                                width: 100, height: 100),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset('assets/images/stamp_back.png',
                                width: 100, height: 100),
                            Image.asset('assets/images/stamp_cafeteria.png',
                                width: 100, height: 100),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset('assets/images/stamp_back.png',
                                width: 100, height: 100),
                            Image.asset('assets/images/stamp_factory.png',
                                width: 100, height: 100),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset('assets/images/stamp_back.png',
                                width: 100, height: 100),
                            Image.asset('assets/images/stamp_library.png',
                                width: 100, height: 100),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset('assets/images/stamp_back.png',
                                width: 100, height: 100),
                            Image.asset('assets/images/stamp_proken.png',
                                width: 100, height: 100),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset('assets/images/stamp_back.png',
                                width: 100, height: 100),
                            Image.asset('assets/images/stamp_interactive.png',
                                width: 100, height: 100),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset('assets/images/stamp_back.png',
                                width: 100, height: 100),
                            Image.asset('assets/images/stamp_gym.png',
                                width: 100, height: 100),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset('assets/images/stamp_back.png',
                                width: 100, height: 100),
                            Image.asset('assets/images/stamp_healthCenter.png',
                                width: 100, height: 100),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset('assets/images/stamp_back.png',
                                width: 100, height: 100),
                            Image.asset('assets/images/stamp_auditorium.png',
                                width: 100, height: 100),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'ビンゴできたら景品ゲット！！\nビンゴすればするほど景品が豪華になるかも！？',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Future(() async {
            LocationPermission permission = await Geolocator.checkPermission();
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
                      backgroundColor: Color(0xFF5592B4),
                      title: Image.asset('images/dialog_check.png',
                          width: 100, height: 100),
                      content: Text(
                        'スタンプ\nGET',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        backgroundColor: Color(0xFF5592B4),
                        title: Image.asset('images/dialog_error.png',
                            width: 100, height: 100),
                        content: Text(
                          '目的地から離れています\nもう少し近づいてください',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ));
                  },
                );
              }
            }
          });
        },
        child: Image.asset('images/floating_image.png'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
