import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

double distanceBetween(
  double latitude1,
  double longitude1,
  double latitude2,
  double longitude2,
) {
  toRadians(double degree) => degree * pi / 180;
  const double r = 6378137.0; // 地球の半径
  final double f1 = toRadians(latitude1);
  final double f2 = toRadians(latitude2);
  final double l1 = toRadians(longitude1);
  final double l2 = toRadians(longitude2);
  final num a = pow(sin((f2 - f1) / 2), 2);
  final double b = cos(f1) * cos(f2) * pow(sin((l2 - l1) / 2), 2);
  final double d = 2 * r * asin(sqrt(a + b));
  return d;
}

void Stamp(context, document) {
  FirebaseFirestore.instance.collection('dream').doc().set(document);
  print("スタンプが押せます");
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: Image.network(
          '#',
          height: 200, //写真の高さ指定
          fit: BoxFit.cover,
        ),
        content: const Text("テキストテキスト"),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
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
  bool isSignedIn = false; // サインイン状態の管理
  String? uid;
  Position? currentPosition;

  double? myx;
  double? myy;
  bool? acheck;
  bool? bcheck;
  bool? ccheck;
  bool? dcheck;
  bool? echeck;
  bool? fcheck;
  bool? gcheck;
  bool? hcheck;
  bool? icheck;
  List<String>? contextList;

  static const stamp_position = [
    [33.89622708644376, 130.83947266423812], //正門
    [33.89562274517045, 130.8397637738136], //銅像
    [33.89530804544407, 130.84005321430428], //記念講堂
    [33.89474550776414, 130.84002775948636], //中村記念館
    [33.89428200032459, 130.8401130290263], //図書館
    [33.89424092156493, 130.8391409544224], //c-2c
    [33.89361218258276, 130.8391702393], //食堂
    [33.890949698331966, 130.8392117562366], //GYMLABO
    [33.89425708935455, 130.83870339261978] //保健センター
  ];

  String? _mapStyle;
  GoogleMapController? _mapController;
  late BitmapDescriptor myIcon;

  void initState() {
    super.initState();
    signInAnonymously();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _showStartDialog(),
    );
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    BitmapDescriptor.asset(
            const ImageConfiguration(size: Size(30, 30)), 'assets/images/jack.png')
        .then((onValue) {
      myIcon = onValue;
    });
  }

  _onMapCreated(GoogleMapController controller) {
    if (mounted) {
      setState(() {
        _mapController = controller;
        controller.setMapStyle(_mapStyle);
      });
    }
  }

  Future<void> signInAnonymously() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      uid = userCredential.user?.uid; // サインイン成功後にUIDを取得
      print("匿名でサインインしました: $uid");
      setState(() {
        isSignedIn = true; // サインインが完了したらフラグを更新
      });
    } catch (e) {
      print("サインインエラー: $e");
    }
  }

  void Sign() {
    // ここでFirestoreからデータを取得し、各ドキュメントに対して処理を行います
    FirebaseFirestore.instance
        .collection('dream')
        .where('uid', isEqualTo: uid) // `uid` を使ってフィルタリング
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        String contextdate = data['content'] as String;

        // contextdateをリストに追加
        List<String> contextList = [];
        contextList.add(contextdate);

        // Finddate関数を呼び出す
        Finddate(contextList);
      }
    });
  }

  void Finddate(contextdate) {
    if (contextdate != null) {
      for (String d in contextdate ?? []) {
        if (d == "a") {
          acheck = true;
          print("asdfvgk,h");
        }
        if (d == "b") {
          bcheck = true;
        }
        if (d == "c") {
          ccheck = true;
        }
        if (d == "d") {
          dcheck = true;
        }
        if (d == "e") {
          echeck = true;
        }
        if (d == "f") {
          fcheck = true;
        }
        if (d == "g") {
          gcheck = true;
        }
        if (d == "h") {
          hcheck = true;
        }
        if (d == "i") {
          icheck = true;
        }
      }
    }
  }

  Future<void> saveUserData(String content) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      uid = currentUser.uid; // サインイン後にUIDをセット
      print("ユーザーUID: $uid");

      await FirebaseFirestore.instance.collection('dream').add({
        'content': content,
        'uid': uid,
        'createdAt': Timestamp.now(),
      });
      print("データが保存されました: $content");
    } else {
      print('ユーザーがサインインしていません');
      await signInAnonymously(); // 再度サインインを試みる
    }
  }

  void _showStartDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Image.asset('images/startDialog_pin.png', width: 55, height: 55),
          content: const Text(
            "マップにある\nピンの近くに行ったら\n右下のボタンを押して\nスタンプをゲット!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xFFD9D9D9)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                showSecondDialog(context);
              },
              child: const Text('次へ'),
            ),
          ],
        );
      },
    );
  }

  void showSecondDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext context) {
        return AlertDialog(
          title: Image.asset('images/startDialog_checkCircle.png',
              width: 55, height: 55),
          content: const Text(
            "たまったスタンプは\n右上のボタンを押して\n確認できるよ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xFFD9D9D9)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                showThirdDialog(context);
              },
              child: const Text('次へ'),
            ),
          ],
        );
      },
    );
  }

  void showThirdDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext context) {
        return AlertDialog(
          title: Image.asset('images/startDialog_error.png',
              width: 55, height: 55),
          content: const Text(
            '位置情報の取得を\n許可してね',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xFFD9D9D9)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('スタート'),
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
        backgroundColor: const Color(0xFF5592B4),
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
                            if (acheck == true)
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
                            if (bcheck == true)
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
                            if (ccheck == true)
                              Image.asset('assets/images/stamp_main_gage.png',
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
                            if (dcheck == true)
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
                            if (echeck == true)
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
                            if (fcheck == true)
                              Image.asset(
                                  'assets/images/stamp_bronze_statue.png',
                                  width: 100,
                                  height: 100),
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
                            if (gcheck == true)
                              Image.asset(
                                  'assets/images/stamp_memorial_museum.png',
                                  width: 100,
                                  height: 100),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset('assets/images/stamp_back.png',
                                width: 100, height: 100),
                            if (hcheck == true)
                              Image.asset(
                                  'assets/images/stamp_healthCenter.png',
                                  width: 100,
                                  height: 100),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset('assets/images/stamp_back.png',
                                width: 100, height: 100),
                            if (icheck == true)
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Text(
              'スタンプラリー\nシートはこちら',
              style: TextStyle(color: Color(0xFF5592B4)),
            ),
          ),
        ],
      ),
      body: Expanded(
        flex: 2, // GoogleMapのスペースを調整
        child: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(33.8924, 130.8403),
            zoom: 16,
          ),
          onMapCreated: _onMapCreated,
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          markers: {
            Marker(
              markerId: const MarkerId('marker_id_1'),
              position: LatLng(stamp_position[5][0], stamp_position[5][1]),
              infoWindow: InfoWindow(
                title: 'C-2C プロ研展示',
                snippet: 'ここをタップ！',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('C-2C プロ研展示'),
                        content: Column(
                          children: [
                            const Text("最後はここに来てね！"),
                            Image.asset('images/proken.png'),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Marker(
              markerId: const MarkerId('marker_id_2'),
              position: LatLng(stamp_position[2][0], stamp_position[2][1]),
              infoWindow: InfoWindow(
                title: '九州工業大学 戸畑キャンパス記念講堂',
                snippet: 'ここをタップ！',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('九州工業大学 戸畑キャンパス記念講堂'),
                        content: Column(
                          children: [
                            const Text("土曜日には声優トークショーが開催！"),
                            Image.asset('images/auditorium.jpg'),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Marker(
              markerId: const MarkerId('marker_id_3'),
              position: LatLng(stamp_position[0][0], stamp_position[0][1]),
              infoWindow: InfoWindow(
                title: '正門',
                snippet: 'ここをタップ！',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('正門'),
                        content: Column(
                          children: [
                            const Text("九工大生の多くが登校してくる場所。入学当初はみんなここで写真撮るよ!"),
                            Image.asset('images/main_gate.jpg'),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Marker(
              markerId: const MarkerId('marker_id_4'),
              position: LatLng(stamp_position[8][0], stamp_position[8][1]),
              infoWindow: InfoWindow(
                title: '九工大保健センター',
                snippet: 'ここをタップ！',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('九工大保健センター'),
                        content: Column(
                          children: [
                            const Text("九工大の保健室"),
                            Image.asset('images/helethCenter.jpg'),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Marker(
              markerId: const MarkerId('marker_id_5'),
              position: LatLng(stamp_position[4][0], stamp_position[4][1]),
              infoWindow: InfoWindow(
                title: '九州工業大学 附属図書館',
                snippet: 'ここをタップ！',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('九州工業大学 附属図書館'),
                        content: Column(
                          children: [
                            const Text("勉強場所の定番"),
                            Image.asset('images/library.jpg'),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Marker(
              markerId: const MarkerId('marker_id_6'),
              position: LatLng(stamp_position[6][0], stamp_position[6][1]),
              infoWindow: InfoWindow(
                title: '九州工業大学生活協同組合 戸畑食堂',
                snippet: 'ここをタップ！',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('九州工業大学生活協同組合 戸畑食堂'),
                        content: Column(
                          children: [
                            const Text("九工大生の昼食スポット"),
                            Image.asset('images/cafeteria.jpg'),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Marker(
              markerId: const MarkerId('marker_id_7'),
              position: LatLng(stamp_position[1][0], stamp_position[1][1]),
              infoWindow: InfoWindow(
                title: '正門付近 銅像',
                snippet: 'ここをタップ！',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('正門付近 銅像'),
                        content: Column(
                          children: [
                            const Text("モチーフは九工大に超ゆかりがある人！？君は誰だかわかるかな？"),
                            Image.asset('images/bronze_statue.jpg'),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Marker(
              markerId: const MarkerId('marker_id_8'),
              position: LatLng(stamp_position[7][0], stamp_position[7][1]),
              infoWindow: InfoWindow(
                title: 'GYMLABO',
                snippet: 'ここをタップ！',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('GYMLABO'),
                        content: Column(
                          children: [
                            const Text("復刻ノオトや文教祭が開催中"),
                            Image.asset('images/gymlabo.jpg'),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Marker(
              markerId: const MarkerId('marker_id_9'),
              position: LatLng(stamp_position[3][0], stamp_position[3][1]),
              infoWindow: InfoWindow(
                title: '百周年中村記念館',
                snippet: 'ここをタップ！',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('百周年中村記念館'),
                        content: Column(
                          children: [
                            const Text("大学の歴史の資料が展示されています。"),
                            Image.asset('images/memorial_museum.jpg'),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Marker(
              markerId: const MarkerId('marker_id_10'),
              position: LatLng(myx ?? 0, myy ?? 0),
              icon: myIcon,
              infoWindow: const InfoWindow(title: '現在地'),
            ),
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Future(() async {
            LocationPermission permission = await Geolocator.checkPermission();
            if (permission == LocationPermission.denied) {
              await Geolocator.requestPermission();
            }
            Position position = await Geolocator.getCurrentPosition();
            setState(() {
              myx = position.latitude;
              myy = position.longitude;
            });
            print(myx);
            print(myy);

            int i = 0;
            int k = 0;
            for (final stamp in stamp_position) {
              i = i + 1;
              double distncce = distanceBetween(
                  position.latitude, position.longitude, stamp[0], stamp[1]);
              if (distncce <= 5) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: const Color(0xFF5592B4),
                      title: Image.asset('images/dialog_check.png',
                          width: 100, height: 100),
                      content: const Text(
                        'スタンプ\nGET',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                );
                if (i == 1) {
                  await saveUserData("a");
                } else if (i == 2) {
                  await saveUserData("b");
                } else if (i == 3) {
                  await saveUserData("c");
                } else if (i == 4) {
                  await saveUserData("d");
                } else if (i == 5) {
                  await saveUserData("e");
                } else if (i == 6) {
                  await saveUserData("f");
                } else if (i == 7) {
                  await saveUserData("g");
                } else if (i == 8) {
                  await saveUserData("h");
                } else if (i == 9) {
                  await saveUserData("i");
                }
              } else {
                k += 1;
                if (k == 9) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          backgroundColor: const Color(0xFF5592B4),
                          title: Image.asset('images/dialog_error.png',
                              width: 100, height: 100),
                          content: const Text(
                            '目的地から離れています\nもう少し近づいてください',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ));
                    },
                  );
                }
              }
            }
            Sign();
          });
        },
        backgroundColor: const Color(0xFF5592B4),
        child: const Image(image: AssetImage('images/floating_image.png')),
      ),
    );
  }
}
