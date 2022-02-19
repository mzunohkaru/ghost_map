import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ghost_position_maps/pages/first_page.dart';
import 'package:ghost_position_maps/pages/map_page.dart';
import 'package:ghost_position_maps/utils/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.setInstance();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ghost Map',
      home: CheckPage(),
    );
  }
}

class CheckPage extends StatefulWidget {
  const CheckPage({Key? key}) : super(key: key);

  @override
  _CheckPageState createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  bool isFirst = true;

  @override
  void initState() {
    super.initState();

    //端末のアカウント情報を取得
    String uid = SharedPrefs.getUid();
    //端末にアカウント情報がない場合
    if (uid == '') {
      print("##################################初めての方");
      isFirst = true;
    } else {
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2回目の方");
      isFirst = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("心スポ　マップ"),
        centerTitle: true,
      ),
      body: isFirst ? const MyAppFirst() : MapSample(),
    );
  }
}
