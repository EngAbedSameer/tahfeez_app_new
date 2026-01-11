import 'dart:developer';
// import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/quickalert.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tahfeez_app/Widgets/MenuItem.dart';
import 'package:tahfeez_app/Widgets/MenuItems.dart';
import 'package:tahfeez_app/model/Firestore.dart';
import 'package:intl/intl.dart' as intl;

class StudentsController extends GetxController {
  Firestore myFierstor = Firestore();
  Duration? executionTime;
  var memorizerEmail;


  max(a, b) {
    if (double.parse(a['points']) >= double.parse(b['points']))
      return a;
    else
      return b;
  }

  
  Future _uploadeStdDataToFirestore(List<Map<String, dynamic>> data) async {
    print('data in uploud');
    for (int i = 0; i < data.length; i++) {
      data[i].addEntries({'m-email': memorizerEmail}.entries);
      await myFierstor.addStudent(data: data[i], mEmail: memorizerEmail);
    }
  }

  _uploadeRecordaDataToFirestore(List<Map<String, dynamic>> data) async {
    print('Record');
    print(data);
    for (int i = 0; i < data.length; i++) {
      data[i].addEntries({'m-email': memorizerEmail}.entries);
      await myFierstor.addOldRecord(
          data: data[i], mEmail: memorizerEmail, idn: data[i]['IDn']);
    }
  }

  

  Future<List<Map<String, dynamic>>> getStudentsFDate() async {
    List<Map<String, dynamic>> result;
    // result = damyData;
    try {
      var n = await InternetAddress.lookup('google.com');
      if (!n.isEmpty || n != null) {
        print("enable network");
        myFierstor.ref.enableNetwork();
      }
    } catch (exception) {
      myFierstor.ref.disableNetwork();
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text("لا يوجد إتصال بالانترنت")));
      // QuickAlert.show(
      //     context: Get.context,
      //     type: QuickAlertType.error,
      //     title: "لا يوجد انتصال بالانترنت",
      //     text:"سيتم عرض البيانات المحفوظة على الجهاز إن وجدت\n  حاول الاتصال بالانترنت للحصول على احدث البيانات",
      //     );
    
    } finally {
      var std = await myFierstor.getNotDeletedStudentsCollection(
          mEmail: memorizerEmail);
          log('std count  ${std.length}');
      result = std.map((e) => e.data()).toList();
    }

    return result;
  }
}
