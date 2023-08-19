// ignore_for_file: avoid_print, use_build_context_synchronously, curly_braces_in_flow_control_structures, sort_child_properties_last, file_names, prefer_const_constructors, prefer_final_fields, sized_box_for_whitespace, unused_element
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tahfeez_app/EmailVerification.dart';
import 'package:tahfeez_app/Home.dart';
import 'package:tahfeez_app/UserSignupData.dart';
import 'package:tahfeez_app/moodle/Firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:tahfeez_app/Home.dart';
// import 'package:tahfeez_app/moodle/firebase-oprations.dart';
// import 'package:tahfeez_app/moodle/DataSet.dart' as data;
// import 'package:tahfeez_app/sqfDB.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  final _formKey = GlobalKey<FormState>();
  final Firestore myFirestore = Firestore();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _centerController = TextEditingController();
  final _cityController = TextEditingController();
  final _nameController = TextEditingController();
  // SqlDb db = SqlDb();
  dynamic singup = false;
  bool _showPassword = false;
  bool _showRePassword = false;

  // _signUp(email, password) async {
  //   try {
  //     await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(email: email, password: password);
  //   } on FirebaseAuthException catch (e) {
  //     var msg = e.code.toString();
  //     print(msg);
  //     if (msg == "email-already-in-use") {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text("هذا البريد الإالكتروني مسجل لمستخدم آخر")));
  //     } else if (msg == "invalid-email") {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text("البريد الإلكتروني غير مقبول")));
  //     } else if (msg == "weak-password") {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text("كلمة المرور ضعيفة, يجب ان تكون على الاقل 6 حروف")));
  //     } else {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text(msg)));
  //     }
  //   }
  //   // if(remember)_activeRemember(email, password);
  //   return true;
  // }

  Future<bool> _auth(email, password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      var msg = e.code.toString();
      print(" ================ Error ===================");
      print(msg);
      if (msg == "user-not-found") {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text:
                "لا يوجد مستخدم يملك هذه البيانات, تأكد من بياناتك او أنشأ حساب جديد",
            title: " خطأفي تسجيل الدخول");
      } else if (msg == "wrong-password") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("اسم المستخدم او/و كلمة المرور غير صحيحين")));
      } else if (msg == "invalid-email") {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("البريد الإلكتروني غير مقبول")));
      } else if (msg == "network-request-failed") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("لا يوجد اتصال بالانترنت")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
      }
      return false;
    }
    // if(remember)_activeRemember(email, password);
  }

  // _isRemembered() async {
  //   List<Map> loginData = await db.readData("select * from Login");
  //   // print(loginData.first.entries.last.value.toString());
  //   // await db.printDatabaseTable("select * from Login");
  //   if (loginData.first.entries.first.value != null &&
  //       loginData.first.entries.elementAt(1).value != null) if (loginData
  //           .first.entries.last.value
  //           .toString()
  //           .compareTo("true") ==
  //       0) {
  //     Navigator.pushAndRemoveUntil(context,
  //         MaterialPageRoute(builder: (context) {
  //       return Home();
  //     }), (route) => false);
  //     // _emailController.text=loginData.first.entries.first.value;
  //     // _passwordController.text=loginData.first.entries.elementAt(1).value;
  //   }
  // }
  // _activeRemember(email,password)async{
  //   List<Map> loginData=await db.readData("select * from Login");
  //   if(loginData.isEmpty)
  //     await db.insertData("INSERT INTO 'Login' (email, password, remember) VALUES ('$email' , '$password' , 'true') ");
  //   else
  //     await db.updateData("UPDATE 'Login' SET email='$email',password='$password',remember= 'true' ");

  // }
  _togglePassvisibility(field) {
    setState(() {
      field == 'password'
          ? _showPassword = !_showPassword
          : _showRePassword = !_showRePassword;
    });
  }

  var isLogin = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      print('''
user is 
${user}''');
      if (user == null) {
        setState(() {
          isLogin = false;
        });
      } else {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
// _isRemembered();
    var vw = MediaQuery.of(context).size.width;
    var vh = MediaQuery.of(context).size.height;

    if (!isLogin) {
      return StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshots) {
            // if (snapshots.hasData && !snapshots.data!.emailVerified) {
            //   print('Email not ver ${snapshots.data!.email}');
            //   return EmailVerification(
            //     memorizerEmail: snapshots.data!.email.toString(),
            //     signUp: singup,
            //   );
            // } else {
            return Stack(
              children: <Widget>[
                Image.asset(
                  "assets/images/background.jpg",
                  fit: BoxFit.cover,
                  width: vw,
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListView(
                      padding: EdgeInsets.only(top: vh * 0.2, bottom: 50),
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: vh * 0.001,
                              ),
                              Image.asset(
                                "assets/icon/logo.png",
                                width: 200,
                              ),
                              Text(singup ? "إنشاء حساب" : "تسجيل الدخول",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 32,
                                      fontFamily: 'Segoe UI',
                                      fontWeight: FontWeight.bold)),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'يجب تعبئة هذه الخانة';
                                          }
                                          return null;
                                        },
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                            border: UnderlineInputBorder(),
                                            label:
                                                Text('أدخل بريدك الإلكتروني'),
                                            focusColor: Colors.red),
                                      ),
                                      width: vw * 0.70,
                                    ),
                                    Container(
                                      child: TextFormField(
                                        obscureText: !_showPassword,
                                        textInputAction: singup
                                            ? TextInputAction.next
                                            : TextInputAction.done,
                                        controller: _passwordController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'يجب تعبئة هذه الخانة';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            suffixIcon: GestureDetector(
                                              onTap: () {
                                                _togglePassvisibility(
                                                    'password');
                                              },
                                              child: Icon(
                                                !_showPassword
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                              ),
                                            ),
                                            border: UnderlineInputBorder(),
                                            label: Text('أدخل كملة المرور'),
                                            focusColor: Colors.red),
                                      ),
                                      width: vw * 0.70,
                                    ),
                                    singup
                                        ? Container(
                                            child: TextFormField(
                                              obscureText: !_showRePassword,
                                              decoration: InputDecoration(
                                                  suffixIcon: GestureDetector(
                                                    onTap: () {
                                                      _togglePassvisibility(
                                                          'rePassword');
                                                    },
                                                    child: Icon(
                                                      !_showRePassword
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                    ),
                                                  ),
                                                  border:
                                                      UnderlineInputBorder(),
                                                  label: Text(
                                                      ' إعادة كلمة المرور'),
                                                  focusColor: Colors.red),
                                              controller: _repasswordController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'يجب تعبئة هذه الخانة';
                                                } else if (value.toString() !=
                                                    _repasswordController.text
                                                        .toString()) {
                                                  return 'كلمة السر غير متطابقة';
                                                }
                                                return null;
                                              },
                                            ),
                                            width: vw * 0.70,
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      singup
                                          ? {
                                              // _signUp(
                                              //     _emailController.text.trim(),
                                              //     _passwordController.text.trim())
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return UserSignupData(
                                                      memorizerEmail:
                                                          _emailController.text
                                                              .toString(),
                                                      password:
                                                          _passwordController
                                                              .text
                                                              .toString());
                                                }),
                                                (route) => false,
                                              )
                                            }
                                          : {
                                              await _auth(
                                                      _emailController.text
                                                          .trim(),
                                                      _passwordController.text
                                                          .trim())
                                                  ? {
                                                      if (FirebaseAuth.instance
                                                              .currentUser !=
                                                          null)
                                                        {
                                                          Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                            return FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .emailVerified
                                                                ? Home()
                                                                : EmailVerification(
                                                                    memorizerEmail:
                                                                        _emailController
                                                                            .text
                                                                            .toString(),
                                                                    signUp:
                                                                        false);
                                                          }))
                                                        }
                                                    }
                                                  : print("Error")
                                            };
                                    }
                                  },
                                  child: Text(
                                      singup ? "التالي" : "تسجيل الدخول ")),
                              SizedBox(
                                height: 20,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: singup
                                        ? ' لديك حساب ؟ '
                                        : '  ليس لديك حساب ؟',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                    children: [
                                      TextSpan(
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              setState(() {
                                                singup = !singup;
                                              });
                                            },
                                          text: singup
                                              ? ' تسجيل الدخول'
                                              : ' أنشأ حساب',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary))
                                    ]),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
            // }
          });
    } else {
      return StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshots) {
            return snapshots.hasData
                ? EmailVerification(
                    memorizerEmail: snapshots.data!.email.toString(),
                    signUp: singup,
                  )
                : Text("sd");
          });
    }
  }
}
