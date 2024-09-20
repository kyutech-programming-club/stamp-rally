import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proken_stamp_rally/sheet.dart';
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
  runApp(
      const MyApp()
     );
}

double distanceBetween(
    double latitude1,
    double longitude1,
    double latitude2,
    double longitude2,
    )
{
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
void Stamp(context,document)
{
  FirebaseFirestore.instance
      .collection('dream')
      .doc()
      .set(document);
  print("スタンプが押せます");
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        title : Image.network(
          '#',
          height: 200,  //写真の高さ指定
          fit: BoxFit.cover,
        ),
        content: Text("テキストテキスト"),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
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


  static const stamp_position = [[33.895035283572184, 130.83913257377353],[33.895372549525625, 130.84023604777587],[33.89500932367183, 130.84079013291944],[33.894275995781406, 130.8386275132089],[33.894183902536696, 130.8400911980695],[33.893457834998614, 130.83918482825203],[33.8904262359517, 130.83873983917533],[33.89094986326708, 130.8392869599504],[33.89082184819561, 130.8411399411388]];
  void initState() {
    super.initState();
    signInAnonymously();
  }

  Future<void> signInAnonymously() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      uid = userCredential.user?.uid; // サインイン成功後にUIDを取得
      print("匿名でサインインしました: $uid");
      setState(() {
        isSignedIn = true; // サインインが完了したらフラグを更新
      });
    } catch (e) {
      print("サインインエラー: $e");
    }
  }
  void Sign()
  {
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


  void Finddate(contextdate)
  {
    if(contextdate != null)
    {
      for(String d in contextdate ??[])
      {
        if(d == "a")
          {
            acheck =true;
            print("asdfvgk,h");
          }
        if(d == "b")
          {
            bcheck =true;
          }
        if(d == "c")
        {
          ccheck =true;
        }
        if(d == "d")
        {
          dcheck =true;
        }
        if(d == "e")
        {
          echeck =true;
        }
        if(d == "f")
        {
          fcheck =true;
        }
        if(d == "g")
        {
          gcheck =true;
        }
        if(d == "h")
        {
          hcheck =true;
        }
        if(d == "i")
        {
          icheck =true;
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
                            if(acheck == true)
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
                            if(bcheck == true)
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
                            if(ccheck == true)
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

                            Image.asset('assets/images/stamp_back.png', width: 100, height: 100),
                            if(dcheck == true)
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
                            if(echeck == true)
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
                            if(fcheck == true)
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
                            if(gcheck == true)
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
                            if(hcheck == true)
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
                            if(icheck == true)
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
        body: Column(
        children: [
          Expanded(
            flex: 2, // GoogleMapのスペースを調整
            child: GoogleMap(
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
                Marker(
                  markerId: const MarkerId('marker_id_10'),
                  position:LatLng(myx??0,myy??0),
                  infoWindow: InfoWindow(
                    title: '自分',
                    onTap: () {},
                  ),
                ),
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          FloatingActionButton(
            onPressed: () {
              Future(() async {
                LocationPermission permission = await Geolocator.checkPermission();
                if(permission == LocationPermission.denied){
                  await Geolocator.requestPermission();
                }
                Position position = await Geolocator.getCurrentPosition();
                setState(() {
                  myx =  position.latitude;
                  myy =  position.longitude;
                });
                print(myx);
                print(myy);

               int i = 0;
                for (final stamp in  stamp_position)
                  {
                    i= i +1;
                    double distncce = distanceBetween(
                        position.latitude,
                        position.longitude,
                        stamp[0],
                        stamp[1]
                    );
                    if(distncce <= 5)
                      {
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
                        if(i == 1)
                          {
                            await saveUserData("a");
                          }
                        else if(i == 2)
                          {
                            await saveUserData("b");
                          }
                        else if(i == 3)
                        {
                          await saveUserData("c");
                        }
                        else if(i == 4)
                        {
                          await saveUserData("d");
                        }
                        else if(i == 5)
                        {
                          await saveUserData("e");
                        }
                        else if(i == 6)
                        {
                          await saveUserData("f");
                        }
                        else if(i == 7)
                        {
                          await saveUserData("g");
                        }
                        else if(i == 8)
                        {
                          await saveUserData("h");
                        }
                        else if(i == 9)
                        {
                          await saveUserData("i");
                        }
                      }
                    else
                    {
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
                Sign();
              });
            },
            child: Text('位置☑'),
          ),
        ],
      ),
    );
  }
}
