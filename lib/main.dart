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
  List<double> distances = [];

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
  BitmapDescriptor? myIcon;
  Position? position;

  void initState() {
    super.initState();
    signInAnonymously();
    getStampData();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _showStartDialog(),
    );
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? newPosition) {
      position = newPosition;
      setState(() {});
      // do what you want to do with the position here
    });
    BitmapDescriptor.asset(
            const ImageConfiguration(size: Size(30, 30)), 'assets/jack.png')
        .then((onValue) {
      myIcon = onValue;
    });
  }

  _onMapCreated(GoogleMapController controller) {
    if (mounted) {
      setState(() {
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

  void getStampData() {
    if (uid == null) {
      print('ユーザーがサインインしていません');
      return;
    }
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
        if (d == StampEnum.gimulabo.displayName) {
          acheck = true;
        }
        if (d == StampEnum.syokudou.displayName) {
          bcheck = true;
        }
        if (d == StampEnum.seimon.displayName) {
          ccheck = true;
        }
        if (d == StampEnum.tosyokan.displayName) {
          dcheck = true;
        }
        if (d == StampEnum.proken.displayName) {
          echeck = true;
        }
        if (d == StampEnum.douzou.displayName) {
          fcheck = true;
        }
        if (d == StampEnum.hyakunen.displayName) {
          gcheck = true;
        }
        if (d == StampEnum.hoken.displayName) {
          hcheck = true;
        }
        if (d == StampEnum.kinen.displayName) {
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
        return SimpleDialog(
          title: Image.asset(
            'assets/startDialog_pin.png',
            width: 55,
            height: 55,
          ),
          children: [
            const Text(
              'マップにある\nピンの近くに行ったら\n右下のボタンを押して\nスタンプをゲット!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            TextButton(
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
        return SimpleDialog(
          title: Image.asset(
            'assets/startDialog_checkCircle.png',
            width: 55,
            height: 55,
          ),
          children: [
            const Text(
              'たまったスタンプは\n右上のボタンを押して\n確認できるよ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            TextButton(
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
        return SimpleDialog(
          title: Image.asset(
            'assets/startDialog_error.png',
            width: 55,
            height: 55,
          ),
          children: [
            const Text(
              '位置情報の取得を\n許可してね',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            TextButton(
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
              builder: (context) {
                return SimpleDialog(
                  title: const Text(
                    "スタンプラリーシート",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/stamp_back.png',
                              width: 80,
                              height: 80,
                            ),
                            if (acheck == true)
                              Image.asset(
                                'assets/stamp_gymlabo.png',
                                width: 80,
                                height: 80,
                              ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/stamp_back.png',
                              width: 80,
                              height: 80,
                            ),
                            if (bcheck == true)
                              Image.asset(
                                'assets/stamp_cafeteria.png',
                                width: 80,
                                height: 80,
                              ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/stamp_back.png',
                              width: 80,
                              height: 80,
                            ),
                            if (ccheck == true)
                              Image.asset(
                                'assets/stamp_main_gage.png',
                                width: 80,
                                height: 80,
                              ),
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
                            Image.asset(
                              'assets/stamp_back.png',
                              width: 80,
                              height: 80,
                            ),
                            if (dcheck == true)
                              Image.asset(
                                'assets/stamp_library.png',
                                width: 80,
                                height: 80,
                              ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/stamp_back.png',
                              width: 80,
                              height: 80,
                            ),
                            if (echeck == true)
                              Image.asset(
                                'assets/stamp_proken.png',
                                width: 80,
                                height: 80,
                              ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/stamp_back.png',
                              width: 80,
                              height: 80,
                            ),
                            if (fcheck == true)
                              Image.asset(
                                'assets/stamp_bronze_statue.png',
                                width: 80,
                                height: 80,
                              ),
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
                            Image.asset(
                              'assets/stamp_back.png',
                              width: 80,
                              height: 80,
                            ),
                            if (gcheck == true)
                              Image.asset(
                                'assets/stamp_memorial_museum.png',
                                width: 80,
                                height: 80,
                              ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/stamp_back.png',
                              width: 80,
                              height: 80,
                            ),
                            if (hcheck == true)
                              Image.asset(
                                'assets/stamp_healthCenter.png',
                                width: 80,
                                height: 80,
                              ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/stamp_back.png',
                              width: 80,
                              height: 80,
                            ),
                            if (icheck == true)
                              Image.asset(
                                'assets/stamp_auditorium.png',
                                width: 80,
                                height: 80,
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'ビンゴできたら景品ゲット！！\nビンゴすればするほど\n景品が豪華になるかも!？',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text(
                        '戻る',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Text(
              'スタンプラリー\nシートはこちら',
              style: TextStyle(color: Color(0xFF5592B4)),
            ),
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(33.893778307446745, 130.84012198995114),
          zoom: 16.82,
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
                    return SimpleDialog(
                      title: const Text(
                        'C-2C プロ研展示',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: <Widget>[
                        const Text("最後はここに来てね！",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18)),
                        Image.asset('assets/proken.png'),
                      ],
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
                    return SimpleDialog(
                      title: const Text('九州工業大学\n戸畑キャンパス記念講堂',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        const Text("土曜日には声優トークショーが開催！",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18)),
                        Image.asset('images/auditorium.jpg'),
                      ],
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
                    return SimpleDialog(
                      title: const Text('正門',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        const Text("九工大生の多くが登校してくる場所。\n入学当初はみんなここで写真撮るよ!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18)),
                        Image.asset('assets/main_gate.jpg'),
                      ],
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
                    return SimpleDialog(
                      title: const Text('九工大保健センター',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        const Text(
                            "九工大の保健室。\n工大祭中に怪我をしたり\n体調が悪くなったりしたら\nここに行こう。",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18)),
                        Image.asset('assets/helethCenter.jpg'),
                      ],
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
                    return SimpleDialog(
                      title: const Text('九州工業大学 附属図書館',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        const Text("勉強場所の定番。\n専門書など、普通の図書館にはない本がいっぱい!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18)),
                        Image.asset('assets/library.jpg'),
                      ],
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
                    return SimpleDialog(
                      title: const Text('九州工業大学生活協同組合 戸畑食堂',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        const Text("九工大生の昼食スポット。\n週ごとにメニューが変わるよ。",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18)),
                        Image.asset('assets/cafeteria.jpg'),
                      ],
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
                    return SimpleDialog(
                      title: const Text('正門付近 銅像',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        const Text("モチーフは九工大に超ゆかりがある人!?\n詳細は銅像の前の説明文をチェック!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18)),
                        Image.asset('assets/bronze_statue.jpg'),
                      ],
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
                    return SimpleDialog(
                      title: const Text('GYMLABO',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        const Text("復刻ノオトや文教祭が開催中!\nピアノ関連のイベントも開催中!\nぜひ参加してね",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18)),
                        Image.asset('assets/gymlabo.jpg'),
                      ],
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
                    return SimpleDialog(
                      title: const Text('百周年中村記念館',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        const Text("大学の歴史の資料が展示されています。",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18)),
                        Image.asset('assets/memorial_museum.jpg'),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Marker(
            markerId: const MarkerId('marker_id_10'),
            position: LatLng(position?.latitude ?? 0, position?.longitude ?? 0),
            icon: myIcon ?? BitmapDescriptor.defaultMarker,
            infoWindow: const InfoWindow(title: '現在地'),
          ),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int k = 0;
          for (final stamp in StampEnum.values) {
            double distncce = distanceBetween(position?.latitude ?? 0,
                position?.longitude ?? 0, stamp.position[0], stamp.position[1]);
            if (distncce <= 8) {
              // if (i == 1) {
              //    saveUserData("a");
              // } else if (i == 2) {
              //    saveUserData("b");
              // } else if (i == 3) {
              //    saveUserData("c");
              // } else if (i == 4) {
              //    saveUserData("d");
              // } else if (i == 5) {
              //    saveUserData("e");
              // } else if (i == 6) {
              //    saveUserData("f");
              // } else if (i == 7) {
              //    saveUserData("g");
              // } else if (i == 8) {
              //    saveUserData("h");
              // } else if (i == 9) {
              //    saveUserData("i");
              // }
              saveUserData(stamp.displayName);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: const Color(0xFF5592B4),
                    title: Image.asset(
                      stamp.imagePath,
                      width: 100,
                      height: 100,
                    ),
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
            } else {
              k += 1;
              if (k == 9) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        backgroundColor: const Color(0xFF5592B4),
                        title: Image.asset(
                          'assets/dialog_error.png',
                          width: 100,
                          height: 100,
                        ),
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
          getStampData();
        },
        backgroundColor: const Color(0xFF5592B4),
        child: const Image(image: AssetImage('assets/floating_image.png')),
      ),
    );
  }
}

enum StampEnum {
  kinen(
    '記念講堂',
    [33.89530804544407, 130.84005321430428],
    'assets/stamp_auditorium.png',
  ),
  douzou(
    '銅像',
    [33.89562274517045, 130.8397637738136],
    'assets/stamp_bronze_statue.png',
  ),
  syokudou(
    '食堂',
    [33.89361218258276, 130.8391702393],
    'assets/stamp_cafeteria.png',
  ),
  seimon(
    '正門',
    [33.89622708644376, 130.83947266423812],
    'assets/stamp_main_gage.png',
  ),
  tosyokan(
    '図書館',
    [33.89428200032459, 130.8401130290263],
    'assets/stamp_library.png',
  ),
  proken(
    'プロ研',
    [33.89424092156493, 130.8391409544224],
    'assets/stamp_proken.png',
  ),
  hoken(
    '保健センター',
    [33.89425708935455, 130.83870339261978],
    'assets/stamp_healthCenter.png',
  ),
  gimulabo(
    'GYMLABO',
    [33.890949698331966, 130.8392117562366],
    'assets/stamp_gymlabo.png',
  ),
  hyakunen(
    '中村記念館',
    [33.89474550776414, 130.84002775948636],
    'assets/stamp_memorial_museum.png',
  );

  const StampEnum(this.displayName, this.position, this.imagePath);

  final String displayName;
  final List<double> position;
  final String imagePath;
}
