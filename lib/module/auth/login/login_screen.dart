import 'dart:developer';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tahfeez_app/Widgets/my_fill_width_button.dart';
import 'package:tahfeez_app/Widgets/my_text_field_with_label.dart';
import 'package:tahfeez_app/module/auth/email_verification/email_verification_screen.dart';
import 'package:tahfeez_app/module/auth/login/login_controller.dart';
import 'package:tahfeez_app/module/home/home_screen.dart';
import 'package:tahfeez_app/module/auth/signup/user_signup_data/user_signup_data_screen.dart';
import 'package:tahfeez_app/model/Firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tahfeez_app/services/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
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

  // Future<bool> _auth(email, password, context) async {
  //   try {
  //     await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: email, password: password);
  //     return true;
  //   } on FirebaseAuthException catch (e) {
  //     var msg = e.code.toString();
  //     print(" ================ Error ===================");
  //     print(msg);
  //     if (msg == "user-not-found") {
  //       QuickAlert.show(
  //           context: context,
  //           type: QuickAlertType.error,
  //           text:
  //               "لا يوجد مستخدم يملك هذه البيانات, تأكد من بياناتك او أنشأ حساب جديد",
  //           title: " خطأفي تسجيل الدخول");
  //     } else if (msg == "wrong-password") {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text("اسم المستخدم او/و كلمة المرور غير صحيحين")));
  //     } else if (msg == "invalid-email") {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text("البريد الإلكتروني غير مقبول")));
  //     } else if (msg == "network-request-failed") {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text("لا يوجد اتصال بالانترنت")));
  //     } else {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text(msg)));
  //     }
  //     return false;
  //   }
  //   // if(remember)_activeRemember(email, password);
  // }

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
    field == 'password'
        ? _showPassword = !_showPassword
        : _showRePassword = !_showRePassword;
  }

  var isLogin = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(initState: (state) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if (user == null) {
          isLogin = false;
        } else {
          isLogin = await state.controller!.checkUserInFirestore(user.email);
          log('login screen checkUserInFirestore result: $isLogin');
          if (isLogin == false) {
            // log("Halaqa found for email: ${user.email} => go to home screen");
            Get.to(() => UserSignupDataScreen(
                  memorizerEmail: user.email.toString(),
                  password: '',
                ));
            //  isLogin = true;
          }
        }
      });
    }, builder: (controller) {
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
              return Scaffold(body: _newbuild());
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
                  : Text("Error in login process");
            });
      }
    });
  }

  // Widget _build() {
  //   var vw = MediaQuery.of(context).size.width;
  //   var vh = MediaQuery.of(context).size.height;
  //   return Stack(
  //     children: <Widget>[
  //       Image.asset(
  //         "assets/images/background.jpg",
  //         fit: BoxFit.cover,
  //         width: vw,
  //       ),
  //       Scaffold(
  //         backgroundColor: Colors.transparent,
  //         body: Directionality(
  //           textDirection: TextDirection.rtl,
  //           child: ListView(
  //             padding: EdgeInsets.only(top: vh * 0.2, bottom: 50),
  //             children: [
  //               Container(
  //                 alignment: Alignment.center,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     SizedBox(
  //                       height: vh * 0.001,
  //                     ),
  //                     Image.asset(
  //                       "assets/icon/logo.png",
  //                       width: 200,
  //                     ),
  //                     Text(singup ? "إنشاء حساب" : "تسجيل الدخول",
  //                         style: TextStyle(
  //                             color: Colors.black,
  //                             fontSize: 32,
  //                             fontFamily: 'Segoe UI',
  //                             fontWeight: FontWeight.bold)),
  //                     Form(
  //                       key: _formKey,
  //                       child: Column(
  //                         children: [
  //                           Container(
  //                             child: TextFormField(
  //                               textInputAction: TextInputAction.next,
  //                               validator: (value) {
  //                                 if (value == null || value.isEmpty) {
  //                                   return 'يجب تعبئة هذه الخانة';
  //                                 }
  //                                 return null;
  //                               },
  //                               controller: _emailController,
  //                               decoration: InputDecoration(
  //                                   border: UnderlineInputBorder(),
  //                                   label: Text('أدخل بريدك الإلكتروني'),
  //                                   focusColor: Colors.red),
  //                             ),
  //                             width: vw * 0.70,
  //                           ),
  //                           Container(
  //                             child: TextFormField(
  //                               obscureText: !_showPassword,
  //                               textInputAction: singup
  //                                   ? TextInputAction.next
  //                                   : TextInputAction.done,
  //                               controller: _passwordController,
  //                               validator: (value) {
  //                                 if (value == null || value.isEmpty) {
  //                                   return 'يجب تعبئة هذه الخانة';
  //                                 }
  //                                 return null;
  //                               },
  //                               decoration: InputDecoration(
  //                                   suffixIcon: GestureDetector(
  //                                     onTap: () {
  //                                       _togglePassvisibility('password');
  //                                     },
  //                                     child: Icon(
  //                                       !_showPassword
  //                                           ? Icons.visibility
  //                                           : Icons.visibility_off,
  //                                     ),
  //                                   ),
  //                                   border: UnderlineInputBorder(),
  //                                   label: Text('أدخل كملة المرور'),
  //                                   focusColor: Colors.red),
  //                             ),
  //                             width: vw * 0.70,
  //                           ),
  //                           singup
  //                               ? Container(
  //                                   child: TextFormField(
  //                                     obscureText: !_showRePassword,
  //                                     decoration: InputDecoration(
  //                                         suffixIcon: GestureDetector(
  //                                           onTap: () {
  //                                             _togglePassvisibility(
  //                                                 'rePassword');
  //                                           },
  //                                           child: Icon(
  //                                             !_showRePassword
  //                                                 ? Icons.visibility
  //                                                 : Icons.visibility_off,
  //                                           ),
  //                                         ),
  //                                         border: UnderlineInputBorder(),
  //                                         label: Text(' إعادة كلمة المرور'),
  //                                         focusColor: Colors.red),
  //                                     controller: _repasswordController,
  //                                     validator: (value) {
  //                                       if (value == null || value.isEmpty) {
  //                                         return 'يجب تعبئة هذه الخانة';
  //                                       } else if (value.toString() !=
  //                                           _repasswordController.text
  //                                               .toString()) {
  //                                         return 'كلمة السر غير متطابقة';
  //                                       }
  //                                       return null;
  //                                     },
  //                                   ),
  //                                   width: vw * 0.70,
  //                                 )
  //                               : SizedBox(),
  //                         ],
  //                       ),
  //                     ),
  //                     ElevatedButton(
  //                         onPressed: () async {
  //                           if (_formKey.currentState!.validate()) {
  //                             singup
  //                                 ? {
  //                                     // _signUp(
  //                                     //     _emailController.text.trim(),
  //                                     //     _passwordController.text.trim())
  //                                     Navigator.pushAndRemoveUntil(
  //                                       context,
  //                                       MaterialPageRoute(builder: (context) {
  //                                         return UserSignupDataScreen(
  //                                             memorizerEmail: _emailController
  //                                                 .text
  //                                                 .toString(),
  //                                             password: _passwordController.text
  //                                                 .toString());
  //                                       }),
  //                                       (route) => false,
  //                                     )
  //                                   }
  //                                 : {
  //                                     await _auth(_emailController.text.trim(),
  //                                             _passwordController.text.trim())
  //                                         ? {
  //                                             if (FirebaseAuth
  //                                                     .instance.currentUser !=
  //                                                 null)
  //                                               {
  //                                                 Navigator.pushReplacement(
  //                                                     context,
  //                                                     MaterialPageRoute(
  //                                                         builder: (context) {
  //                                                   return FirebaseAuth
  //                                                           .instance
  //                                                           .currentUser!
  //                                                           .emailVerified
  //                                                       ? Home()
  //                                                       : EmailVerification(
  //                                                           memorizerEmail:
  //                                                               _emailController
  //                                                                   .text
  //                                                                   .toString(),
  //                                                           signUp: false);
  //                                                 }))
  //                                               }
  //                                           }
  //                                         : print("Error")
  //                                   };
  //                           }
  //                         },
  //                         child: Text(singup ? "التالي" : "تسجيل الدخول ")),
  //                     SizedBox(
  //                       height: 20,
  //                     ),
  //                     RichText(
  //                       text: TextSpan(
  //                           text:
  //                               singup ? ' لديك حساب ؟ ' : '  ليس لديك حساب ؟',
  //                           style: TextStyle(fontSize: 20, color: Colors.black),
  //                           children: [
  //                             TextSpan(
  //                                 recognizer: TapGestureRecognizer()
  //                                   ..onTap = () {
  //                                     setState(() {
  //                                       singup = !singup;
  //                                     });
  //                                   },
  //                                 text: singup ? ' تسجيل الدخول' : ' أنشأ حساب',
  //                                 style: TextStyle(
  //                                     decoration: TextDecoration.underline,
  //                                     color: Theme.of(context)
  //                                         .colorScheme
  //                                         .primary))
  //                           ]),
  //                     )
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  //   // }
  // }
  bool _isSignUp = false;
  Widget _newbuild() {
    return GetBuilder<LoginController>(
        initState: (state) {},
        builder: (controller) {
          return SizedBox(
            height: 800,
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/login.jpg',
                  width: double.infinity,
                ),
                Positioned(
                  top: 240,
                  child: Container(
                    width: 360,
                    height: 565,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xffffffff),
                    ),
                    padding: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            _isSignUp ? 'Signup' : 'Login',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          MyTextFieldWithLabel(
                              textInputAction: TextInputAction.next,
                              controller: controller.emailController,
                              label: 'Email',
                              icon: Icons.email_outlined,
                              hint: 'example@my.com'),
                          MyTextFieldWithLabel(
                              textInputAction: TextInputAction.done,
                              controller: controller.passwordController,
                              label: 'Password',
                              icon: Icons.lock,
                              hint: '********'),
                          _isSignUp
                              ? MyTextFieldWithLabel(
                                  label: 'Re-Password',
                                  icon: Icons.lock,
                                  hint: '********')
                              : SizedBox(),
                          MyFillWidthButton(
                            label: 'login',
                            onPressed: () {
                              _isSignUp
                                  ? controller.signUp().then((value) {
                                      if (value) {
                                        log(
                                            'Signup successful for email: ${controller.emailController.text}');
                                        MySharedPreferences().setBool(
                                            PreferencesNames.check_login
                                                .toString(),
                                            true);
                                      } else {
                                        log(
                                            'Signup failed for email: ${controller.emailController.text}');
                                      }
                                    })
                                  :
                              controller.login().then((value) {
                                if (value) {
                                  log('Login successful for email: ${controller.emailController.text}');
                                  MySharedPreferences().setBool(
                                      PreferencesNames.check_login.toString(),
                                      true);
                                } else {
                                  log('Login failed for email: ${controller.emailController.text}');
                                }
                              });
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text.rich(TextSpan(
                              text: "Don't have an account? ",
                              children: [
                                TextSpan(
                                    text: _isSignUp ? 'Login' : 'Signup',
                                    style: TextStyle(color: Colors.green),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // state.
                                        log('tapped signup/login');
                                        _isSignUp = true;
                                        controller.update();
                                      }),
                              ])),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'OR',
                            style: TextStyle(
                                fontSize: 22, color: Colors.grey[400]),
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.googleLogin();
                            },
                            child: ClipRRect(
                              // borderRadius: BorderRadius.circular(13),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.2,
                                          color: Colors.grey
                                              .withValues(alpha: 0.1)),
                                      borderRadius: BorderRadius.circular(15),
                                      color:
                                          Colors.grey.withValues(alpha: 0.05)),
                                  padding: EdgeInsets.all(12),
                                  margin: EdgeInsets.all(15),
                                  child: Image.asset(
                                    'assets/images/google.png',
                                    width: 32,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
