import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tahfeez_app/bindings.dart';
import 'package:tahfeez_app/module/auth/login/login_screen.dart';
import 'package:tahfeez_app/module/home/home_screen.dart';
import 'package:tahfeez_app/services/firebase_options.dart';
import 'package:tahfeez_app/model/SenrtyReports.dart';
import 'package:tahfeez_app/services/shared_preferences.dart';
// import 'package:tahfeez_app/sqfDB.dart';

// ضيف الية تسجيل مراجعة او سرد مجموعة من السور
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  await MySharedPreferences().init();
  await SentryReporter.setup(MyHome());
  // runApp(MyHome());
}

class MyHome extends StatelessWidget {
  MyHome({super.key});

  // final SqlDb db = SqlDb();

  @override
  Widget build(BuildContext context) {
    dynamic _nextScreen = "";
    _nextScreen = HomeScreen();
    return
        // BugReportOverlay();
        GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahfeez',
      initialBinding: Binding(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 159, 14,
              14), //button text , text field on select border, circuler progress indicator
          secondary: const Color(0xFF797D7E),
          primaryContainer: Colors.greenAccent, // CircleAvatar background
          surfaceContainer: const Color.fromARGB(
              255, 164, 136, 206), // menu list background, app bar after scroll
          surface: Colors.white,
          error: Colors.redAccent,
          errorContainer: const Color.fromARGB(255, 228, 77, 77),
          inversePrimary: Colors.blue,
          inverseSurface: const Color.fromARGB(255, 5, 71, 124), //snackbar
          onInverseSurface: const Color.fromARGB(255, 0, 0, 0),
          onSurface: const Color.fromARGB(255, 0, 0, 0), // main text color
          onPrimary: const Color.fromARGB(255, 81, 0, 255),
          onSecondary: Colors.yellow,
          onError: const Color.fromARGB(255, 245, 190, 190),
          brightness: Brightness.light,
          outline:
              const Color.fromARGB(255, 0, 250, 25), // text field border color
          shadow: Colors.grey,
          tertiary: Colors.purple,
          tertiaryContainer: const Color.fromARGB(255, 234, 117, 255),
          outlineVariant: Colors.black54,
          scrim: const Color.fromARGB(255, 64, 97, 87),
          surfaceTint: const Color.fromARGB(255, 243, 33, 170),
          secondaryContainer: const Color.fromARGB(255, 65, 51, 7),
          onPrimaryContainer: const Color.fromARGB(255, 125, 45, 45),
          onPrimaryFixed: Colors.white,
          onPrimaryFixedVariant: Colors.blue,
          onSecondaryContainer: const Color.fromARGB(255, 121, 9, 9),
          onTertiary: Colors.white,
          onTertiaryContainer: Colors.black,
          onSecondaryFixed: Colors.blue,
          onSecondaryFixedVariant: Colors.white,
          onSurfaceVariant: const Color.fromARGB(137, 137, 210, 11),
          onTertiaryFixed: Colors.amberAccent,
          onTertiaryFixedVariant: Colors.purpleAccent,
          primaryFixed: Colors.blue,
          primaryFixedDim: Colors.blueAccent,
          secondaryFixed: Colors.amber,
          secondaryFixedDim: Colors.amberAccent,
          tertiaryFixed: Colors.purple,
          tertiaryFixedDim: Colors.purpleAccent,
          surfaceBright: const Color.fromARGB(255, 0, 7, 212),
          surfaceDim: const Color.fromARGB(255, 35, 143, 143),
          surfaceContainerLow: Color.fromARGB(
              255, 114, 125, 69), // button background, card color,
          surfaceContainerHighest: Colors.cyan,
          surfaceContainerLowest: Colors.cyanAccent,
          onErrorContainer: Colors.white,
        ),
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
