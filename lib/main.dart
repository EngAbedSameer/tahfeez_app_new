import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:tahfeez_app/Login.dart';
import 'package:tahfeez_app/firebase_options.dart';
import 'package:tahfeez_app/moodle/SenrtyReports.dart';

/*
* TODO: ضيف الية تسجيل مراجعة او سرد مجموعة من السور
* FIXME: limit points in one field after dote 99.5555555 => 99.6 
*/

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
    await SentryReporter.setup(MyHome());
  // runApp(MyHome());
}

class MyHome extends StatelessWidget {
  MyHome({super.key});

  // final SqlDb db = SqlDb();

  @override
  Widget build(BuildContext context) {
    dynamic _nextScreen = "";
    _nextScreen = Login();
    return
        // BugReportOverlay();
        MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahfeez',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: AnimatedSplashScreen(splash: Splash(), nextScreen: _nextScreen),
      ),
      // routes: {
      //   'home': (context) => Home(),
      //   'daily': (context) => Da(),
      // },
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  State<Splash> createState() => _Splash();
}

class _Splash extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Image.asset("assets/icon/logo.png", width: 200),
    ));
  }
}
