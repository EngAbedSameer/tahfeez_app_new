import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:tahfeez_app/Login.dart';
import 'package:tahfeez_app/firebase_options.dart';
import 'package:tahfeez_app/moodle/SenrtyReports.dart';
/*
* TODO: ضيف الية تسجيل مراجعة او سرد مجموعة من السور
* FIXME: fix date width in record card
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
        child: AnimatedSplashScreen(
            splashIconSize: 600,
            splash: Splash(),
            nextScreen: _nextScreen,
            duration: 2000),
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
