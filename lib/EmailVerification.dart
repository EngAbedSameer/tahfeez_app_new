import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tahfeez_app/Home.dart';
import 'package:tahfeez_app/UserSignupData.dart';
import 'package:tahfeez_app/Login.dart';

class EmailVerification extends StatefulWidget {
  final String memorizerEmail;
  final bool signUp;

  const EmailVerification({super.key, required this.memorizerEmail, required this.signUp});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendEmailVerification();
      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVarified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVarified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer!.cancel();
  }

  sendEmailVerification() async {
    try {
      var user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? widget.signUp?UserSignupData(memorizerEmail:widget.memorizerEmail):Home()
      : Scaffold(
          appBar: AppBar(
            title: Text("Email Verification"),
          ),
          body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(textAlign: TextAlign.center,
                  "تم ارسال رابط على عنوان بريدك الإلكتروني ,  يرجى النقر على الرابط للتاكد من هويتك"),
              // CircularProgressIndicator()
              ElevatedButton(onPressed: (){
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) {return Login();}),(route)=>false);

                
              }, child: Text("رجوع"))
            ],
          )),
        );
}
