import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:tahfeez_app/Widgets/MenuItem.dart';
import 'package:tahfeez_app/Widgets/MenuItems.dart';
import 'package:tahfeez_app/model/WhatsappMassage.dart';
import 'package:tahfeez_app/module/add_record/add_record_screen.dart';
import 'package:tahfeez_app/module/main/home/home_controller.dart';

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
            centerTitle: true,
            actions: [
              PopupMenuButton<MyMenuItem>(
                  onSelected: (item) => controller.onSelected(context, item),
                  itemBuilder: (context) =>
                      [...MenuItems.items.map(controller.buildItem).toList()]),
            ],
            title: Text("الرئيسية"),
          ),
          body: _newBuild(),
        );
      },
    );
  }

  _newBuild() {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return RefreshIndicator(
          onRefresh: () async {
            controller.update();
          },
          child: FutureBuilder(
              future: controller.damyData1(),
              // getStudentsFDate(),
              builder: ((context, AsyncSnapshot snapshot) {
                // log('test if any student ${snapshot.hasData} && ${snapshot.data!.length > 0}');
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.length > 0) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        // color: Colors.teal,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    // child: GestureDetector(
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(100),
                                      child: Image.asset(
                                        fit: BoxFit.cover,
                                        "assets/images/person.jpg",
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 210.w,
                                        child: Text(
                                          'السلام عليكم محمد',
                                          style: TextStyle(fontSize: 20),
                                          softWrap: true,
                                        ),
                                      ),
                                      Text('محفظ',
                                          style: TextStyle(fontSize: 16)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.all(8),
                              title: Text('عدد الطلاب'),
                              subtitle: Text('15 طالب'),
                              trailing: ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(8),
                                child: Image.asset(
                                  'assets/images/totalStudents.jpg',
                                  fit: BoxFit.cover,
                                  width: 130,
                                  height: 64,
                                ),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.all(8),
                              title: Text('مجموع تسميع الأسبوع'),
                              subtitle: Text('2 آية'),
                              trailing: ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(8),
                                child: Image.asset(
                                  'assets/images/totalStudents.jpg',
                                  fit: BoxFit.cover,
                                  width: 130,
                                  height: 64,
                                ),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.all(8),
                              title: Text('الدورات الفعّالة'),
                              subtitle: Text('20 دورة'),
                              trailing: ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(8),
                                child: Image.asset(
                                  'assets/images/totalStudents.jpg',
                                  fit: BoxFit.cover,
                                  width: 130,
                                  height: 64,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    'أضف طالب',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll(Colors.teal)),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    // var stemp =
                                    //     await myFierstor.getStudentsCollection(
                                    //         mEmail: controller.memorizerEmail);
                                    // var data = await stemp.get();
                                    // controller.exportToExcel(data.docs);
                                     Get.to(()=>AddRecordScreen(
                                        stdID: '1',
                                        memorizerEmail: 'memorizerEmail',
                                        stdName: 'stdName'));
                                  },
                                  child: Text(
                                    'إحصائيات',
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'أحدث التسجيلات',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            ...List.generate(10, (index) {
                              return ListTile(
                                contentPadding: EdgeInsets.all(0),
                                leading: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(),
                                  child: Icon(
                                    Icons.chrome_reader_mode_outlined,
                                    size: 24,
                                  ),
                                ),
                                title: Text('أمير أبو بكر'),
                                subtitle: Text('سورة الزمر, آية 255'),
                              );
                            })
                          ],
                        ),
                      ),
                    ),
                  );
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
