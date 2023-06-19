// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, implementation_imports, curly_braces_in_flow_control_structures, unused_element
import 'package:intl/intl.dart';
import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
// import 'package:tahfeez_app/NewRecord.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tahfeez_app/moodle/BottomBar.dart';
import 'package:tahfeez_app/moodle/Firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'sqfDB.dart';
import 'dart:ui' as def;

class StudentProfile extends StatefulWidget {
  final studentIDn;
  final String memorizerEmail;

  const StudentProfile({
    super.key,
    required this.studentIDn, required this.memorizerEmail,
  });
  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    ScreenUtil.ensureScreenSize();

    super.initState();
  }

  Firestore myFierstor = Firestore();
  _getStdAge(String dob) {
    int thisYear = DateTime.now().year;
    int stdDate = int.parse(dob.split('/').last);
    return thisYear - stdDate;
  }

  // SqlDb db = SqlDb();
  late TextStyle cardTextStyle =
      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, height: 2.5);
  late TextStyle cardMainTextStyle = TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      height: 2.5,
      color: Colors.green);

_getStudentDate() async{
 return await myFierstor.getStudentData(mEmail: widget.memorizerEmail, idn: widget.studentIDn);
}

  // Future<List<Map>> _getStudentDate() async {
  //   List<Map> result = await db
  //       .readData("SELECT * FROM students WHERE IDn=${widget.studentSysID}");
  //   return result;
  // }


_getStudentHistory()async{
  await myFierstor.getRecordDocs(mEmail: widget.memorizerEmail, idn: widget.studentIDn);

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

 _ageCalc(String birthday){ 
  print(birthday); 

  List<String>date=birthday.split("-");
  String newDate=date[2]+"-"+date[1]+"-"+date[0];
  DateDuration duration = AgeCalculator.age(DateTime.parse(newDate));
  return duration.years.toString();
}

  @override
  Widget build(BuildContext context) {
    var dviceWidth = MediaQuery.of(context).size.width;
    // var dviceHight = MediaQuery.of(context).size.height;
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("ملف الطالب", textAlign: TextAlign.center),
      ),
      body: FutureBuilder(
          future: _getStudentDate(),
          builder: ((context, AsyncSnapshot<List<Map>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              Map stdDate = snapshot.data!.first;
              print(stdDate);
              return Directionality(
                textDirection: def.TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage("assets/images/splash.jpg"),
                        ),
                      ),
                      Text(
                          stdDate["f_name"] +
                              " " +
                              stdDate["m_name"] +
                              " " +
                              stdDate["l_name"],
                          style: TextStyle(
                              fontSize: dviceWidth * 0.067,
                              fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Container(
                            width: (dviceWidth-20 )* 0.47,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "رقم الهوية: " +
                                          stdDate["IDn"].toString(),
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          height: 2.5)),
                                  Text(
                                      "تاريخ الميلاد: " +
                                          stdDate["DOB"].toString(),
                                      textWidthBasis: TextWidthBasis.parent,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          height: 2.5)),
                                  Text("المدرسة: " + stdDate["school"],
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          height: 2.5)),
                                ]),
                          ),
                          Container(
                            width: dviceWidth * 0.48,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final Uri launchUri = Uri(
                                        scheme: 'tel',
                                        path: ' ${stdDate["phone"]}',
                                      );
                                      await launchUrl(launchUri);
                                      // launchUrl('tel://${stdDate["phone"]}');
                                    },
                                    child: Text(
                                      "رقم الجوال: " +
                                          stdDate["phone"].toString(),
                                      textWidthBasis: TextWidthBasis.parent,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 14.sp,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          height: 2.5),
                                    ),
                                  ),
                                  Text("العمر: "+_ageCalc(stdDate["DOB"].toString()).toString(),
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          height: 2.5)),
                                  Text("الصف: " + stdDate["level"].toString(),
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          height: 2.5))
                                ]),
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      Text("السجل",
                          style: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.bold)),
                      FutureBuilder(
                          future: _getStudentHistory(),
                          builder:
                              ((context, AsyncSnapshot<List<Map>> snapshot) {
                            if (snapshot.hasData && snapshot.data!.length > 0) {
                              return Flexible(
                                child: ListView.builder(
                                    itemCount: snapshot.data?.length,
                                    itemBuilder: (context, index) {
                                      var recordData = snapshot.data![index];
                                      return Card(
                                        margin: EdgeInsets.all(6),
                                        child: Stack(
                                          children: [
                                            Card(
                                              shadowColor: Colors.black,
                                              elevation: 0,
                                              margin: EdgeInsets.all(0),
                                              color: Colors.red,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    bottom: 2,
                                                    right: 4),
                                                child: Text(
                                                    recordData['type']
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                      height: 2,
                                                    )),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 18),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text("التاريخ : ",
                                                                style:
                                                                    cardMainTextStyle),
                                                            Text(
                                                                recordData[
                                                                        'date']
                                                                    .toString()
                                                                    .split(
                                                                        " ")[0],
                                                                style:
                                                                    cardTextStyle),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text("الإلتزام: ",
                                                                style:
                                                                    cardMainTextStyle),
                                                            Text(
                                                                recordData[
                                                                        'commitment']
                                                                    .toString(),
                                                                style:
                                                                    cardTextStyle),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text("  الجودة: ",
                                                                style:
                                                                    cardMainTextStyle),
                                                            Text(
                                                                recordData[
                                                                        'quality']
                                                                    .toString(),
                                                                style:
                                                                    cardTextStyle),
                                                          ],
                                                        ),
                                                      ]),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text("سورة : ",
                                                                style:
                                                                    cardMainTextStyle),
                                                            Text(
                                                                maxLines: 1,
                                                                recordData['surah']
                                                                        .toString() +
                                                                    "  ",
                                                                style:
                                                                    cardTextStyle)
                                                          ],
                                                        ),

                                                        // width: dviceWidth * 0.49,
                                                        Row(
                                                          children: [
                                                            Text("من: ",
                                                                style:
                                                                    cardMainTextStyle),
                                                            Text(
                                                                maxLines: 1,
                                                                recordData[
                                                                        'frm']
                                                                    .toString(),
                                                                style:
                                                                    cardTextStyle),
                                                          ],
                                                        ),

                                                        Row(
                                                          children: [
                                                            Text("إلى: ",
                                                                style:
                                                                    cardMainTextStyle),
                                                            Text(
                                                                recordData['t']
                                                                    .toString(),
                                                                style:
                                                                    cardTextStyle),
                                                          ],
                                                        ),

                                                        Row(
                                                          children: [
                                                            Text("(",
                                                                style:
                                                                    cardMainTextStyle),
                                                            Text(
                                                                recordData[
                                                                        'pgs_count']
                                                                    .toString(),
                                                                style:
                                                                    cardTextStyle),
                                                            Text(")صفحات",
                                                                style:
                                                                    cardMainTextStyle),
                                                          ],
                                                        ),
                                                      ]),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );

                                    }),
                              );

                            } else
                              return Center(child: CircularProgressIndicator());
                          }))
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          })),
      bottomNavigationBar: BottomBar(
        dailyReplace: true,
        dailyPush: false,
        home: true,
        addStudent: true,memorizerEmail: widget.memorizerEmail
      ),
    );
  }
}
