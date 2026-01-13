
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:quickalert/quickalert.dart';
import 'dart:ui' as def;
import 'package:tahfeez_app/module/student_profile/edit_student_data/edit_student_data_screen.dart';
import 'package:tahfeez_app/module/student_profile/student_profile_controller.dart';

class StudentProfile extends StatelessWidget {
  final studentIDn;
  final String memorizerEmail;

  StudentProfile({
    super.key,
    required this.studentIDn,
    required this.memorizerEmail,
  });
  StudentProfileController control = Get.put(StudentProfileController());
  @override
  Widget build(BuildContext context) {
    // var dviceWidth = MediaQuery.of(context).size.width;
    // var dviceHight = MediaQuery.of(context).size.height;
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("ملف الطالب"), actions: [
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.confirm,
              title: "هل انت متأكد من عملية الحذف",
              text:
                  "عند حذف الطالب لن تتمكن من الوصول للبيانات القديمة وسيتم حذفها بشكل نهائي ",
              confirmBtnText: "حذف",
              confirmBtnColor: Colors.red,
              onConfirmBtnTap: () {
                // Navigator.pop(context);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            );
          },
        ),
        IconButton(
            onPressed: () {
              Get.to(() => EditStudentData(), arguments: Get.arguments);
            },
            icon: Icon(Icons.edit_outlined))
      ]),
      body: GetBuilder<StudentProfileController>(
          init: control,
          builder: (controller) {
            return FutureBuilder(
                future: controller.getStudentDate(),
                builder: ((context, AsyncSnapshot<List<Map>> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    Map stdDate = snapshot.data!.first;
                    return SingleChildScrollView(
                      child: Directionality(
                        textDirection: def.TextDirection.rtl,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  width: 135,
                                  height: 135,
                                  padding: const EdgeInsets.all(5.0),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadiusGeometry.circular(100),
                                    child: stdDate['image'] == null
                                        ? Image.asset(
                                            "assets/images/person.jpg",
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            fit: BoxFit.cover,
                                            stdDate['image'],
                                          ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                    stdDate["f_name"] + " " + stdDate["l_name"],
                                    style: TextStyle(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Center(
                                  child:
                                      Text('تاريخ الميلاد: ${stdDate["DOB"]}')),
                              Center(
                                  child: Text('الجوال: ${stdDate["phone"]}')),
                              SizedBox(
                                height: 15,
                              ),
                              // Container(
                              //   width: 350.w,
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: [
                              //       Container(
                              //         margin: EdgeInsets.only(left: 5),
                              //         child: Column(
                              //             crossAxisAlignment: CrossAxisAlignment.start,
                              //             children: [
                              //               Text(
                              //                   "رقم الهوية: " +
                              //                       stdDate["IDn"].toString(),
                              //                   style: TextStyle(
                              //                       fontSize: 14.sp,
                              //                       fontWeight: FontWeight.bold,
                              //                       height: 2.5)),
                              //               Text("المدرسة: " + stdDate["school"],
                              //                   style: TextStyle(
                              //                       fontSize: 14.sp,
                              //                       fontWeight: FontWeight.bold,
                              //                       height: 2.5)),
                              //             ]),
                              //       ),
                              //       SizedBox(
                              //         width: 170.w,
                              //         child: Column(
                              //             crossAxisAlignment: CrossAxisAlignment.start,
                              //             children: [
                              //               // GestureDetector(
                              //               //   onTap: () async {
                              //               //     final Uri launchUri = Uri(
                              //               //       scheme: 'tel',
                              //               //       path: ' ${stdDate["phone"]}',
                              //               //     );
                              //               //     await launchUrl(launchUri);
                              //               //     // launchUrl('tel://${stdDate["phone"]}');
                              //               //   },
                              //               //   child: Flexible(
                              //               //     child: Container(
                              //               //       child: Text(
                              //               //         "رقم الجوال: " +
                              //               //             stdDate["phone"].toString(),
                              //               //         textWidthBasis:
                              //               //             TextWidthBasis.parent,
                              //               //         overflow: TextOverflow.ellipsis,
                              //               //         style: TextStyle(
                              //               //             decoration:
                              //               //                 TextDecoration.underline,
                              //               //             fontSize: 14.sp,
                              //               //             color: Colors.blue,
                              //               //             fontWeight: FontWeight.bold,
                              //               //             height: 2.5),
                              //               //       ),
                              //               //     ),
                              //               //   ),
                              //               // ),

                              //               Text(
                              //                   "العمر: " +
                              //                       _ageCalc(stdDate["DOB"].toString())
                              //                           .toString(),
                              //                   style: TextStyle(
                              //                       fontSize: 14.sp,
                              //                       fontWeight: FontWeight.bold,
                              //                       height: 2.5)),
                              //               Text("الصف: " + stdDate["level"].toString(),
                              //                   style: TextStyle(
                              //                       fontSize: 14.sp,
                              //                       fontWeight: FontWeight.bold,
                              //                       height: 2.5))
                              //             ]),
                              //       )
                              //     ],
                              //   ),
                              // ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {}, child: Text('اتصل')),
                                  ElevatedButton(
                                      onPressed: () {}, child: Text('واتساب')),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [Text('نسبة الحفظ'), Text('60%')],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: LinearProgressIndicator(
                                  minHeight: 8,
                                  backgroundColor: Colors.tealAccent,
                                  color: Colors.teal,
                                  value: 0.60,
                                  borderRadius: BorderRadius.circular(50),
                                  semanticsValue: '600%',
                                  semanticsLabel: '60%',
                                ),
                              ),
                              // Divider(
                              //   color: Colors.black,
                              //   thickness: 1,
                              // ),
                              Text(
                                'آخر حفظ',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 45.h,
                                margin: EdgeInsets.only(top: 7, bottom: 15),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 4, color: Colors.black12)
                                    ]),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "سورة المائدة",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal[900]),
                                    ),
                                    Text(
                                      '15-25',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.teal[200]),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'معلومات الطالب',
                                style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        border: BoxBorder.fromLTRB(
                                            top: BorderSide(
                                                color: Colors.teal))),
                                    width: 80.w,
                                    height: 70.h,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('المدرسة'),
                                        Text('${stdDate['school']}')
                                      ],
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                        border: BoxBorder.fromLTRB(
                                            top: BorderSide(
                                                color: Colors.teal))),
                                    width: 80.w,
                                    height: 70.h,
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('السنة الدراسية'),
                                        Text('${stdDate['level']}')
                                      ],
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                    margin:
                                        EdgeInsets.only(left: 50, right: 10),
                                    decoration: BoxDecoration(
                                        border: BoxBorder.fromLTRB(
                                            top: BorderSide(
                                                color: Colors.teal))),
                                    // width: 30.w,
                                    height: 70.h,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('العمر'),
                                        Text(
                                            '${controller.ageCalc(stdDate['DOB'])}')
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "السجل",
                                style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 250.h,
                                child: FutureBuilder(
                                    future: controller.getStudentHistory(),
                                    builder:
                                        ((context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data!.length > 0) {
                                        List data = snapshot.data!;
                                        // data.sort((a, b) => (( b['date'] as Timestamp)
                                        //         .toDate())
                                        //     .compareTo(
                                        //         ((a['date'] as Timestamp).toDate())));
                                        return ListView.builder(
                                            itemCount: snapshot.data?.length,
                                            itemBuilder: (context, index) {
                                              Map recordData = data[index];
                                              // data[index].data() as Map;
                                              var quality = recordData[
                                                          'quality'] <=
                                                      2
                                                  ? 'سيء'
                                                  : recordData['quality'] <= 5
                                                      ? 'جيد'
                                                      : recordData[
                                                                  'quality'] <=
                                                              7
                                                          ? 'جيد جدا'
                                                          : recordData[
                                                                      'quality'] <=
                                                                  9
                                                              ? 'ممتاز'
                                                              : 'ممتاز جدا';
                                              return
                                                  // Card(
                                                  //   margin: EdgeInsets.all(6),
                                                  //   child: Stack(
                                                  //     children: [
                                                  //       Card(
                                                  //         shadowColor: Colors.black,
                                                  //         elevation: 0,
                                                  //         margin: EdgeInsets.all(0),
                                                  //         color: Colors.red,
                                                  //         child: Padding(
                                                  //           padding:
                                                  //               const EdgeInsets.only(
                                                  //                   left: 8.0,
                                                  //                   bottom: 2,
                                                  //                   right: 4),
                                                  //           child: Text(
                                                  //               recordData['type']
                                                  //                           .toString() ==
                                                  //                       "1.0"
                                                  //                   ? "حفظ"
                                                  //                   : "مراجعة",
                                                  //               textAlign:
                                                  //                   TextAlign.center,
                                                  //               style: TextStyle(
                                                  //                 fontSize: 10,
                                                  //                 color: Colors.white,
                                                  //                 height: 2,
                                                  //               )),
                                                  //         ),
                                                  //       ),
                                                  //       Padding(
                                                  //         padding:
                                                  //             const EdgeInsets.symmetric(
                                                  //                 horizontal: 10,
                                                  //                 vertical: 18),
                                                  //         child: Column(
                                                  //           mainAxisAlignment:
                                                  //               MainAxisAlignment.end,
                                                  //           children: [
                                                  //             Row(
                                                  //                 mainAxisAlignment:
                                                  //                     MainAxisAlignment
                                                  //                         .spaceBetween,
                                                  //                 children: [
                                                  //                   Text("التاريخ:",
                                                  //                       style:
                                                  //                           cardMainTextStyle),
                                                  //                   Flexible(
                                                  //                     child: Container(
                                                  //                       width: 80,
                                                  //                       child: Text(
                                                  //                           getRecordDate(
                                                  //                                   recordData[
                                                  //                                       'date'])
                                                  //                               .trim(),
                                                  //                           overflow:
                                                  //                               TextOverflow
                                                  //                                   .ellipsis,
                                                  //                           style:
                                                  //                               cardTextStyle),
                                                  //                     ),
                                                  //                   ),
                                                  //                   Text("الإلتزام:",
                                                  //                       style:
                                                  //                           cardMainTextStyle),
                                                  //                   Text(
                                                  //                       recordData[
                                                  //                               'commitment']
                                                  //                           .toString(),
                                                  //                       style:
                                                  //                           cardTextStyle),
                                                  //                   Text("الجودة:",
                                                  //                       style:
                                                  //                           cardMainTextStyle),
                                                  //                   Text(
                                                  //                       recordData[
                                                  //                               'quality']
                                                  //                           .toString(),
                                                  //                       style:
                                                  //                           cardTextStyle),
                                                  //                 ]),
                                                  //             Row(
                                                  //                 mainAxisAlignment:
                                                  //                     MainAxisAlignment
                                                  //                         .spaceBetween,
                                                  //                 children: [
                                                  //                   Row(
                                                  //                     children: [
                                                  //                       Text("سورة : ",
                                                  //                           style:
                                                  //                               cardMainTextStyle),
                                                  //                       Text(
                                                  //                           maxLines: 1,
                                                  //                           recordData['surah']
                                                  //                                   .toString() +
                                                  //                               "  ",
                                                  //                           style:
                                                  //                               cardTextStyle)
                                                  //                     ],
                                                  //                   ),
                                                  //                   // width: dviceWidth * 0.49,
                                                  //                   Row(
                                                  //                     children: [
                                                  //                       Text("من: ",
                                                  //                           style:
                                                  //                               cardMainTextStyle),
                                                  //                       Text(
                                                  //                           maxLines: 1,
                                                  //                           recordData[
                                                  //                                   'from']
                                                  //                               .toString(),
                                                  //                           style:
                                                  //                               cardTextStyle),
                                                  //                     ],
                                                  //                   ),
                                                  //                   Row(
                                                  //                     children: [
                                                  //                       Text("إلى: ",
                                                  //                           style:
                                                  //                               cardMainTextStyle),
                                                  //                       Text(
                                                  //                           recordData[
                                                  //                                   'to']
                                                  //                               .toString(),
                                                  //                           style:
                                                  //                               cardTextStyle),
                                                  //                     ],
                                                  //                   ),
                                                  //                   Row(
                                                  //                     children: [
                                                  //                       Text("(",
                                                  //                           style:
                                                  //                               cardMainTextStyle),
                                                  //                       Text(
                                                  //                           recordData[
                                                  //                                   'pgsCount']
                                                  //                               .toString(),
                                                  //                           style:
                                                  //                               cardTextStyle),
                                                  //                       Text(")صفحات",
                                                  //                           style:
                                                  //                               cardMainTextStyle),
                                                  //                     ],
                                                  //                   ),
                                                  //                 ]),
                                                  //           ],
                                                  //         ),
                                                  //       )
                                                  //     ],
                                                  //   ),
                                                  // );
                                                  Container(
                                                child: ListTile(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 5),
                                                  title: Text(
                                                      'سورة ${recordData['surah']}'),
                                                  subtitle: Text(
                                                      'الآيات ${recordData['from']}-${recordData['to']}'),
                                                  trailing: Text(
                                                      '${recordData['quality']} $quality'),
                                                ),
                                              );
                                            });
                                      } else
                                        return Center(
                                            child: CircularProgressIndicator());
                                    })),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }));
          }),
      // bottomNavigationBar: BottomBar(
      //     dailyReplace: true,
      //     dailyPush: false,
      //     home: true,
      //     addStudent: true,
      //     memorizerEmail: widget.memorizerEmail),
    );
  }
}
