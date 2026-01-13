import 'dart:developer';

import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tahfeez_app/model/Firestore.dart';

class StudentProfileController extends GetxController {
  String? memorizerEmail;
  String? studentIDn;

  @override
  void onInit() {
    if (Get.arguments != null) {
      studentIDn = Get.arguments['studentIDn'];
      memorizerEmail = Get.arguments['memorizerEmail'];
    }
    super.onInit();
  }

  Firestore myFierstor = Firestore();

  // getStdAge(String dob) {
  //   int thisYear = DateTime.now().year;
  //   int stdDate = int.parse(dob.split('/').last);
  //   return thisYear - stdDate;
  // }

  // SqlDb db = SqlDb();
  // late TextStyle cardTextStyle =
  //     TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, height: 2.5);
  // late TextStyle cardMainTextStyle = TextStyle(
  //     fontSize: 14.sp,
  //     fontWeight: FontWeight.bold,
  //     height: 2.5,
  //     color: Colors.green);

  Future<List<Map<dynamic, dynamic>>> getStudentDate() async {
    var r = await myFierstor.getStudentData(
        mEmail: memorizerEmail, idn: studentIDn);
    return List.generate(1, (index) => r);
    // return temp;
  }

  Future<List> getStudentHistory() async {
    // <QueryDocumentSnapshot<Object?>>
    var r =
        await myFierstor.getRecordDocs(mEmail: memorizerEmail, idn: studentIDn);
    log('${r.first.data()}');
    var result = List.generate(r.length, (index) => r[index].data());
    // sortByDate( result);
    return result;
    // var r = [
    //   {
    //     'commitment': '9',
    //     'date': 'July 15, 2023 at 1:12:15 PM UTC+3',
    //     'from': '12',
    //     'isSynced': 'false',
    //     'pgsCount': '3',
    //     'quality': '9',
    //     'surah': 'لقمان',
    //     'to': '34',
    //     'type': '0.5',
    //   },
    //   {
    //     'commitment': '9',
    //     'date': 'July 15, 2023 at 1:12:15 PM UTC+3',
    //     'from': '12',
    //     'isSynced': 'false',
    //     'pgsCount': '3',
    //     'quality': '9',
    //     'surah': 'لقمان',
    //     'to': '34',
    //     'type': '0.5',
    //   },
    //   {
    //     'commitment': '9',
    //     'date': 'July 15, 2023 at 1:12:15 PM UTC+3',
    //     'from': '12',
    //     'isSynced': 'false',
    //     'pgsCount': '3',
    //     'quality': '9',
    //     'surah': 'لقمان',
    //     'to': '34',
    //     'type': '0.5',
    //   },
    // ];
    // return r;
  }

  // Future<List<Map>> _getStudentHistory() async {
  //   List<Map> result = await db
  //       .readData("SELECT * FROM Records WHERE std_id=${widget.studentSysID}");
  //   print(result[0]["date"].split(" ")[0]);
  //   print(" ******************** ");
  //   print(DateTime.now().toString().split(" ")[0]);
  //   return result;
  // }
  // Future<List<Map>> _getStudentTests() async {
  //   List<Map> result = await db
  //       .readData("SELECT * FROM tests WHERE id=${widget.studentSysID}");
  //   return result;
  // }
  ageCalc(String birthday) {
    List<String> date = birthday.split("-");
    String newDate = date[2] + "-" + date[1] + "-" + date[0];
    DateDuration duration = AgeCalculator.age(DateTime.parse(newDate));
    return duration.years.toString();
  }

  String getRecordDate(date) {
    if (date.runtimeType.toString() == "Timestamp") {
      var s = date as Timestamp;
      print(s.toDate().toString());
      return s.toDate().toString().split(" ")[0];
    } else {
      return date.toString().split("T")[0];
    }
  }

  deleteStudent() async {
    await myFierstor.deleteStudent(memorizerEmail, studentIDn);
  }
}
