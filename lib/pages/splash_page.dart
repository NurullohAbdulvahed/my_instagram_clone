import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_instagram_clone/pages/home_page.dart';
import 'package:my_instagram_clone/service/prefs_service.dart';


class SplashPage extends StatefulWidget {
  static String id = "SplashPage";

  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  _initTimer() {
    Timer(const Duration(seconds: 2), () {
      _callSignInPage();
    });
  }

  void _callSignInPage() {
    Navigator.pushReplacementNamed(context, HomePage.id);
  }
   initNotification() async {
    await _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      if (kDebugMode) {
        print("Token $token shu yer");
      }
      Prefs.saveFCM(token!);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _initTimer();
    initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: Center(
                      child: SizedBox(
                          height: 200,
                          width: 200,
                          child: Image.asset("assets/images/insta_logo.png"),
                      )
                  )
              ),
              Column(
                children: [
                  const Text(
                    "from",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  SizedBox(
                      height: 40,
                      width: 110,
                      child: Image.asset("assets/images/metaa.png"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
