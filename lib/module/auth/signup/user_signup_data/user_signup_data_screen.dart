import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tahfeez_app/Widgets/my_fill_width_button.dart';
import 'package:tahfeez_app/Widgets/my_text_field_with_label.dart';
import 'package:tahfeez_app/module/auth/email_verification/email_verification_screen.dart';
import 'package:tahfeez_app/model/Firestore.dart';
import 'package:tahfeez_app/services/shared_preferences.dart';

class UserSignupDataScreen extends StatefulWidget {
  final String memorizerEmail;
  final String password;
  const UserSignupDataScreen(
      {super.key, required this.memorizerEmail, required this.password});

  @override
  State<UserSignupDataScreen> createState() => _UserSignupDataState();
}

class _UserSignupDataState extends State<UserSignupDataScreen> {
  var _phoneController = TextEditingController();
  var _centerController = TextEditingController();
  var _cityController = TextEditingController();
  var _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Firestore myFirestore = Firestore();

  _createAccount(email, password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      var msg = e.code.toString();
      print(msg);
      if (msg == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("هذا البريد الإالكتروني مسجل لمستخدم آخر")));
      } else if (msg == "invalid-email") {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("البريد الإلكتروني غير مقبول")));
      } else if (msg == "weak-password") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("كلمة المرور ضعيفة, يجب ان تكون على الاقل 6 حروف")));
      } else {
        print(msg);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
      }
    }
    // if(remember)_activeRemember(email, password);
    return true;
  }

  Future _signUp(phone, center, city, name) async {
    myFirestore.addMemorizer({
      'phone': phone,
      'center': center,
      'city': city,
      'name': name,
      'email': widget.memorizerEmail
    }).then((value) {
      log("Memorizer data added for email: ${widget.memorizerEmail} -> $value");
      if (value != null) {
        MySharedPreferences().setBool(
            PreferencesNames.check_account_data_completed.toString(), true);
        MySharedPreferences()
            .setBool(PreferencesNames.check_account_auth.toString(), true);
        MySharedPreferences()
            .setBool(PreferencesNames.check_halaqa_created.toString(), true);
        MySharedPreferences()
            .setBool(PreferencesNames.check_login.toString(), true);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("تم التسجيل بنجاح")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var vw = MediaQuery.of(context).size.width;
    var vh = MediaQuery.of(context).size.height;
    return
        // Image.asset(
        //   "assets/images/background.jpg",
        //   fit: BoxFit.cover,
        //   width: vw,
        // ),
        Scaffold(
      // backgroundColor: Colors.transparent,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: EdgeInsets.only(top: vh * 0.1, right: 10, left: 10),
          children: [
            Container(
              alignment: Alignment.center,
              height: 680.h,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   "assets/icon/logo.png",
                    //   width: 200,
                    // ),
                    Text("بيانات الحلقة",
                        style: TextStyle(
                            // color: Colors.black,
                            fontSize: 32,
                            // fontFamily: 'Segoe UI',
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 20,
                    ),
                    MyTextFieldWithLabel(
                      hint: 'اسم المحفظ رباعي',
                      filled: true,
                      textInputAction: TextInputAction.next,
                      controller: _nameController,
                      fillColor: const Color(0xFFC2E7E1),
                      borderColor: Colors.white,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يجب تعبئة هذه الخانة';
                        }
                        return null;
                      },
                    ),
                    MyTextFieldWithLabel(
                      hint: 'أسم مركز التحفيظ',
                      filled: true,
                      textInputAction: TextInputAction.next,
                      controller: _centerController,
                      fillColor: const Color(0xFFC2E7E1),
                      borderColor: Colors.white,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يجب تعبئة هذه الخانة';
                        }
                        return null;
                      },
                    ),
                    MyTextFieldWithLabel(
                      hint: 'المدينة',
                      filled: true,
                      textInputAction: TextInputAction.next,
                      controller: _cityController,
                      fillColor: const Color(0xFFC2E7E1),
                      borderColor: Colors.white,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يجب تعبئة هذه الخانة';
                        }
                        return null;
                      },
                    ),
                    MyTextFieldWithLabel(
                      hint: 'رقم الجوال',
                      filled: true,
                      textInputAction: TextInputAction.next,
                      controller: _phoneController,
                      fillColor: const Color(0xFFC2E7E1),
                      borderColor: Colors.white,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يجب تعبئة هذه الخانة';
                        } else if (value.length != 13) {
                          print(value.length);
                          return 'رقم الجوال غير صحيح، يجب أن يبدء بمقدمة الواتساب(+972)';
                        }
                        return null;
                      },
                    ),

                    // Container(
                    //   child: TextFormField(
                    //     keyboardType: TextInputType.phone,
                    //     textInputAction: TextInputAction.next,
                    //     decoration: InputDecoration(
                    //         border: UnderlineInputBorder(),
                    //         label: Text("رقم الجوال"),
                    //         hintText: '+970592654021',
                    //         focusColor: Colors.red),
                    //     controller: _phoneController,
                    //     validator: (value) {
                    //       if (value == null || value.isEmpty) {
                    //         print(" ******************* ");
                    //         return 'يجب تعبئة هذه الخانة';
                    //       } else if (value.length != 13) {
                    //         print(value.length);
                    //         return 'رقم الجوال غير صحيح';
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    //   width: vw * 0.70,
                    // ),

                    // Container(
                    //   child: TextFormField(
                    //     textInputAction: TextInputAction.next,
                    //     decoration: InputDecoration(
                    //         border: UnderlineInputBorder(),
                    //         label: Text("المدينة"),
                    //         focusColor: Colors.red),
                    //     controller: _cityController,
                    //     validator: (value) {
                    //       if (value == null || value.isEmpty) {
                    //         print(" ******************* ");
                    //         return 'يجب تعبئة هذه الخانة';
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    //   width: vw * 0.70,
                    // ),

                    // Container(
                    //   child: TextFormField(
                    //     decoration: InputDecoration(
                    //         border: UnderlineInputBorder(),
                    //         label: Text("أسم مركز التحفيظ"),
                    //         hintText:
                    //             "يجب ان يكون موحد لجميع المحفظين في المركز",
                    //         focusColor: Colors.red),
                    //     controller: _centerController,
                    //     validator: (value) {
                    //       if (value == null || value.isEmpty) {
                    //         print(" ******************* ");
                    //         return 'يجب تعبئة هذه الخانة';
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    //   width: vw * 0.70,
                    // ),

                    Spacer(),
                    MyFillWidthButton(
                      backgroundColor: Colors.teal,
                      textColor:Colors.white,
                      label: 'انشاء حساب',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _createAccount(
                              widget.memorizerEmail, widget.password);
                          await _signUp(
                              _phoneController.text.toString().trim(),
                              _centerController.text.toString().trim(),
                              _cityController.text.toString().trim(),
                              _nameController.text.toString().trim());
                          log("Signup completed for email: ${await FirebaseAuth.instance.currentUser}");
                          log('${MySharedPreferences().getAllKeys()}');
                          log('${MySharedPreferences().getBool(PreferencesNames.check_account_data_completed.name)}');

                          if (FirebaseAuth.instance.currentUser != null &&
                              MySharedPreferences().getBool(PreferencesNames
                                  .check_account_data_completed.name)!)
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return EmailVerification(
                                  memorizerEmail: widget.memorizerEmail,
                                  signUp: false,
                                );
                              }),
                              (route) => false,
                            );
                        }
                      },
                      // child: Text(" انشاء حساب ")
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
