import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tahfeez_app/module/add_record/add_record_screen.dart';
import 'package:tahfeez_app/module/student_profile/student_profile_screen.dart';

class StudentsListTile extends StatelessWidget {
  Map stdData;
  String memorizerEmail;
  // BuildContext context;
  StudentsListTile(
      {required this.stdData,
      // required this.context,
      required this.memorizerEmail});

  Widget build(context) {
    return GestureDetector(
      onTap: () {
        Get.to(
            () => StudentProfile(
                studentIDn: stdData['IDn'], memorizerEmail: memorizerEmail),
            arguments: {
              'studentIDn': stdData['IDn'],
              'memorizerEmail': memorizerEmail
            });
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => StudentProfile(
        //           studentIDn: stdData['IDn'],
        //           memorizerEmail: memorizerEmail,
        //         )));
      },
      child: Container(
        margin: EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Container(
                width: 70,
                height: 70,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(100)),
                // child: GestureDetector(
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(100),
                  child: stdData['image'] == null
                      ? Image.asset(
                          "assets/images/user.png",
                          // fit: BoxFit.cover,
                          cacheHeight: 45,
                          cacheWidth: 45,
                          width: 45,
                          height: 45,
                        )
                      : Image.network(
                          fit: BoxFit.cover,
                          stdData['image'],
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stdData['f_name'].toString()),
                    // Text((stdData['points'] +
                    //         stdData['attendance'])
                    //     .toString())
                    Text(
                      ' النقاط: ${stdData['points']} ',
                      style: TextStyle(fontSize: 12, color: Colors.teal),
                    ),
                    // Text(
                    //   (stdData['points']).toString(),
                    //   style: TextStyle(fontSize: 12, color: Colors.teal),
                    // ),
                  ],
                ),
              )
            ]),
            ElevatedButton(
              style: ButtonStyle(
                padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 5, horizontal: 8)),
                minimumSize: WidgetStatePropertyAll(Size.zero),
              ),
              child: Text(
                'أضف حفظ',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
              onPressed: () async {
                Navigator.push(
                    context,
                    await MaterialPageRoute(
                        builder: (context) => AddRecordScreen(
                              stdID: stdData['IDn'],
                              memorizerEmail: memorizerEmail,
                              stdName:
                                  """${stdData['f_name']} ${stdData['l_name']}""",
                            )));
              },
            )
          ],
        ),
      ),
    );
  }
}
