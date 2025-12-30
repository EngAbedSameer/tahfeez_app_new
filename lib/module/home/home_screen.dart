import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tahfeez_app/Widgets/MenuItem.dart';
import 'package:tahfeez_app/Widgets/MenuItems.dart';
import 'package:tahfeez_app/Widgets/home_list_tile.dart';
import 'package:tahfeez_app/module/auth/login/login_screen.dart';
import 'package:tahfeez_app/module/add_record/add_record_screen.dart';
import 'package:tahfeez_app/module/home/home_controller.dart';
import 'package:tahfeez_app/module/student_profile/student_profile_screen.dart';
import 'package:tahfeez_app/widgets/BottomBar.dart';
import 'package:tahfeez_app/model/WhatsappMassage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tahfeez_app/model/Firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      initState: (state) {
        Get.lazyPut(() => HomeController());
        state.controller?.memorizerEmail = 'eng@test.com';
      },
      builder: (controller) {
        controller.memorizerEmail = 'eng@test.com';
        // FirebaseAuth.instance.currentUser?.email.toString();
        return Scaffold(
            appBar: AppBar(
              actions: [
                PopupMenuButton<MyMenuItem>(
                    onSelected: (item) => controller.onSelected(context, item),
                    itemBuilder: (context) => [
                          ...MenuItems.items.map(controller.buildItem).toList()
                        ]),
              ],
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("الرئيسية"),
                  IconButton(
                    icon: Icon(Icons.message_outlined),
                    onPressed: () {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.loading,
                          title: "جاري تجهيز الرسالة");
                      WhatsappMassage()
                          .getRecordsToMessage(controller.memorizerEmail)
                          .then((value) => Navigator.pop(context));
                    },
                  )
                ],
              ),
            ),
            body: _newBuild(),
            bottomNavigationBar: BottomBar(
              dailyReplace: false,
              dailyPush: true,
              home: false,
              addStudent: true,
              memorizerEmail: '${controller.memorizerEmail}',
            ));
      },
    );
  }

  // _build() {
  //   RefreshIndicator(
  //     onRefresh: () async {
  //       await Navigator.pushReplacement(
  //           context,
  //           PageRouteBuilder(
  //               pageBuilder: (a, b, c) => HomeScreen(),
  //               transitionDuration: Duration(seconds: 0)));
  //     },
  //     child: FutureBuilder(
  //         future: _getStudentsFDate(),
  //         builder: ((context, AsyncSnapshot snapshot) {
  //           if (snapshot.hasData && snapshot.data!.length > 0) {
  //             List<Map> data = snapshot.data;
  //             data.sort((a, b) => double.parse(a['points'])
  //                 .compareTo(double.parse(b['points'])));
  //             data = data.reversed.toList();
  //             // var data = sortList(snapshot.data!);
  //             return ListView.builder(
  //                 itemCount: data.length,
  //                 itemBuilder: (context, index) {
  //                   var stdData = data.elementAt(index);
  //                   // getFirestoreDataAsListWithID(
  //                   //     stdData, snapshot.data!.elementAt(index).id);
  //                   return GestureDetector(
  //                     onTap: () {
  //                       Navigator.of(context).push(MaterialPageRoute(
  //                           builder: (context) => StudentProfile(
  //                                 studentIDn: stdData['IDn'],
  //                                 memorizerEmail: memorizerEmail,
  //                               )));
  //                     },
  //                     child: Card(
  //                       margin: EdgeInsets.all(6),
  //                       child: Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 12, vertical: 15),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Row(children: [
  //                               Container(
  //                                 width: 35,
  //                                 padding: EdgeInsets.all(0),
  //                                 margin: EdgeInsets.all(0),
  //                                 // child: GestureDetector(
  //                                 child: CircleAvatar(
  //                                   radius: 20,
  //                                   child: Image.asset(
  //                                     height: 25,
  //                                     "assets/icon/person.png",
  //                                   ),
  //                                 ),
  //                                 // onTap: () {
  //                                 //   Navigator.of(context).push(
  //                                 //       MaterialPageRoute(
  //                                 //           builder: (context) =>
  //                                 //               StudentProfile(
  //                                 //                 studentIDn:
  //                                 //                     stdData['IDn'],
  //                                 //                 memorizerEmail:
  //                                 //                     memorizerEmail,
  //                                 //               )));
  //                                 // },
  //                                 // ),
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.symmetric(
  //                                     horizontal: 10),
  //                                 child: Column(
  //                                   children: [
  //                                     Text(stdData['f_name'].toString() +
  //                                         " " +
  //                                         stdData['l_name'].toString()),
  //                                     // Text((stdData['points'] +
  //                                     //         stdData['attendance'])
  //                                     //     .toString())
  //                                     Text((stdData['points']).toString())
  //                                   ],
  //                                 ),
  //                               )
  //                             ]),
  //                             CircleAvatar(
  //                               backgroundColor: Colors.green,
  //                               child: IconButton(
  //                                 icon: Icon(
  //                                   Icons.add,
  //                                   color: Colors.white,
  //                                 ),
  //                                 onPressed: () async {
  //                                   print("object");
  //                                   print(await stdData['IDn']);
  //                                   Navigator.push(
  //                                       context,
  //                                       await MaterialPageRoute(
  //                                           builder: (context) => NewRecord(
  //                                                 stdID: stdData['IDn'],
  //                                                 memorizerEmail:
  //                                                     memorizerEmail,
  //                                                 stdName:
  //                                                     """${stdData['f_name']} ${stdData['l_name']}""",
  //                                               )));
  //                                 },
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //                 });
  //           } else {
  //             // try {
  //             //   ScaffoldMessenger.of(context).showSnackBar(
  //             //       SnackBar(content: Text("لا يوجد بيانات لعرضها ")));
  //             // } catch (e) {
  //             //   print(e);
  //             // }
  //             return Center(child: CircularProgressIndicator());
  //           }
  //         })),
  //   );
  // }

  _newBuild() {
    log('message from get builder');

    return GetBuilder<HomeController>(
      builder: (controller) {
        return RefreshIndicator(
          onRefresh: () async {
            controller.update();
          },
          child: FutureBuilder(
              future: controller.getStudentsFDate(),
              builder: ((context, AsyncSnapshot snapshot) {
                // log('test if any student ${snapshot.hasData} && ${snapshot.data!.length > 0}');
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.length > 0) {
                  List<Map> data = snapshot.data;
                  data.sort((a, b) => double.parse(a['points'])
                      .compareTo(double.parse(b['points'])));
                  data = data.reversed.toList();
                  // var data = sortList(snapshot.data!);
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        Map stdData = data.elementAt(index);
                        // getFirestoreDataAsListWithID(
                        //     stdData, snapshot.data!.elementAt(index).id);
                        return HomeListTile(
                            // context: Get.context,
                            memorizerEmail: controller.memorizerEmail,
                            stdData: stdData);
                      });
                } else if (!snapshot.hasData) {
                  // try {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(content: Text("لا يوجد بيانات لعرضها ")));
                  return Center(child: Text('لا يوجد بيانات لعرضها'));
                  // } catch (e) {
                  //   print(e);
                  // }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })),
        );
      },
    );
  }
}
