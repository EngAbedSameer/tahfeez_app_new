import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tahfeez_app/model/Firestore.dart';
import 'package:tahfeez_app/module/home/home_screen.dart';
import 'package:tahfeez_app/services/shared_preferences.dart';

class LoginController extends GetxController {
  late SharedPreferences prefs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
  }

  googleLogin() async {
    MySharedPreferences()
        .setBool(PreferencesNames.check_account_auth.name, false);
    MySharedPreferences()
        .setBool(PreferencesNames.check_account_data_completed.name, false);
    MySharedPreferences()
        .setBool(PreferencesNames.check_email_verified.name, false);
    MySharedPreferences()
        .setBool(PreferencesNames.check_halaqa_created.name, false);
    MySharedPreferences().setBool(PreferencesNames.check_login.name, false);
    MySharedPreferences()
        .setBool(PreferencesNames.check_onboarding_completed.name, false);
    try {
      GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) return;
      log('gUser is not null');
      GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      log('gUser is not null alert');
      QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.loading,
          title: "جاري تجهيز الرسالة");
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .whenComplete(() {
        Get.back();
      });
      MySharedPreferences()
          .setBool(PreferencesNames.check_login.toString(), true);
      if (await checkUserInFirestore(gUser.email)) {
        Get.to(() => HomeScreen());
      }
    } on FirebaseAuthException catch (e) {
      log(e.toString());
          QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          title: "$e");
    }
  }

  Future<bool> login() async {
    MySharedPreferences()
        .setBool(PreferencesNames.check_account_auth.name, false);
    MySharedPreferences()
        .setBool(PreferencesNames.check_account_data_completed.name, false);
    MySharedPreferences()
        .setBool(PreferencesNames.check_email_verified.name, false);
    MySharedPreferences()
        .setBool(PreferencesNames.check_halaqa_created.name, false);
    MySharedPreferences().setBool(PreferencesNames.check_login.name, false);
    MySharedPreferences()
        .setBool(PreferencesNames.check_onboarding_completed.name, false);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      return true;
    } on FirebaseAuthException catch (e) {
      var msg = e.code.toString();
      log(" ================ Error ===================");
      log(msg);
      if (msg == "user-not-found") {
        QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          text:
              "لا يوجد مستخدم يملك هذه البيانات, تأكد من بياناتك او أنشأ حساب جديد",
          title: " خطأ في تسجيل الدخول",
          confirmBtnText: 'إخفاء',
        );
      } else if (msg == "wrong-password") {
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
            content: Text("اسم المستخدم او/و كلمة المرور غير صحيحين")));
      } else if (msg == "invalid-email") {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(content: Text("البريد الإلكتروني غير مقبول")));
      } else if (msg == "network-request-failed") {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text("لا يوجد اتصال بالانترنت")));
      } else {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(msg)));
      }
      return false;
    }
    // if(remember)_activeRemember(email, password);
  }

  Future<bool> signUp() async {
    MySharedPreferences()
        .setBool(PreferencesNames.check_account_auth.name, false);
    MySharedPreferences()
        .setBool(PreferencesNames.check_account_data_completed.name, false);
    MySharedPreferences()
        .setBool(PreferencesNames.check_email_verified.name, false);
    MySharedPreferences()
        .setBool(PreferencesNames.check_halaqa_created.name, false);
    MySharedPreferences().setBool(PreferencesNames.check_login.name, false);
    MySharedPreferences()
        .setBool(PreferencesNames.check_onboarding_completed.name, false);
    try {
      QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.loading,
      );
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((v) {
        Get.back();
      });

      return true;
    } on FirebaseAuthException catch (e) {
      var msg = e.code.toString();

      if (msg == "email-already-in-use") {
        User? gUser = FirebaseAuth.instance.currentUser;
        log('${GoogleAuthProvider.credential()}');
        log('${GoogleAuthProvider.GOOGLE_SIGN_IN_METHOD}');
        log('${GoogleAuthProvider().providerId}');
        // if (gUser == null) return;
        // GoogleSignInAuthentication gAuth = await gUser!.authentication;
        // final credential = GoogleAuthProvider.credential(
        //   accessToken: gAuth.accessToken,
        //   idToken: gAuth.idToken,
        // );
        log('${gUser} ------');
        log('${gUser?.email} ------');
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(content: Text("هذا البريد الإالكتروني مسجل لمستخدم آخر")));
      } else if (msg == "invalid-email") {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(content: Text("البريد الإلكتروني غير مقبول")));
      } else if (msg == "weak-password") {
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
            content: Text("كلمة المرور ضعيفة, يجب ان تكون على الاقل 6 حروف")));
      } else {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(msg)));
      }
      return false;
    }
    // if(remember)_activeRemember(email, password);
  }

  Future<bool> checkUserInFirestore(email) async {
    // var halaqad = await Firestore().getHalaqaDoc(mEmail: email);
    try {
      var halaqa = await Firestore().getHalaqaData(mEmail: email);
      if (halaqa == null) {
        log("No Halaqa found for email: $email => go to singup data completion");
        MySharedPreferences()
            .setBool(PreferencesNames.check_account_auth.toString(), true);
        MySharedPreferences()
            .setBool(PreferencesNames.check_halaqa_created.toString(), false);
        MySharedPreferences()
            .setBool(PreferencesNames.check_email_verified.toString(), true);
        return false;
      } else {
        log("Halaqa found for email: $email => go to home screen");
        MySharedPreferences()
            .setBool(PreferencesNames.check_login.toString(), true);
        MySharedPreferences()
            .setBool(PreferencesNames.check_account_auth.toString(), true);
        MySharedPreferences()
            .setBool(PreferencesNames.check_email_verified.toString(), true);
        MySharedPreferences()
            .setBool(PreferencesNames.check_halaqa_created.toString(), true);
        return true;
      }
    } catch (e) {
      log("Error in fetching Halaqa for email: $email => $e");
      log("No Halaqa found for email: $email => go to singup data completion");
      return false;
    }
  }
}
