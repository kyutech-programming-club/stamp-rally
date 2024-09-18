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
      body: Column(
        children: [
          Expanded(
            child: isSignedIn && uid != null
                ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('dream')
                  .where('uid', isEqualTo: uid) // 取得したUIDでフィルタリング
                  .snapshots(),
              builder: (context, snapshots) {
                if (snapshots.hasError) {
                  return const Center(child: Text("エラーが発生しました"));
                }
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator()); // ローディング中
                }

                if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
                  return const Center(child: Text("データがありません"));
                }

                final queryDocSnapshot = snapshots.data!.docs; // 取得したデータリスト
                return ListView.builder(
                  itemCount: queryDocSnapshot.length,
                  itemBuilder: (context, index) {
                    final data = queryDocSnapshot[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['content'] ?? '内容がありません'),
                    );
                  },
                );
              },
            )
                : const Center(child: CircularProgressIndicator()), // ローディング表示
          ),


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
                    if(distncce >= 5)
                      {
                        if(i == 8)
                          {
                            await saveUserData("a");
                          }
                        else if(i == 1)
                          {
                            await saveUserData("b");
                          }
                        else if(i == 2)
                        {
                          await saveUserData("c");
                        }
                        else if(i == 3)
                        {
                          await saveUserData("d");
                        }
                        else if(i == 4)
                        {
                          await saveUserData("e");
                        }
                        else if(i == 5)
                        {
                          await saveUserData("f");
                        }
                        else if(i == 6)
                        {
                          await saveUserData("g");
                        }
                        else if(i == 7)
                        {
                          await saveUserData("h");
                        }
                          final document = <String, dynamic>{
                          'context' : "a",
                          'createdAt': Timestamp.fromDate(DateTime.now()),
                        };
                        Stamp(context,document);
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
