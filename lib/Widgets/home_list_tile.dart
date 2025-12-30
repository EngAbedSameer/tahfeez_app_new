import 'package:flutter/material.dart';
import 'package:tahfeez_app/module/add_record/add_record_screen.dart';
import 'package:tahfeez_app/module/student_profile/student_profile_screen.dart';

class HomeListTile extends StatelessWidget {
  Map stdData;
  String memorizerEmail;
  // BuildContext context;
  HomeListTile(
      {required this.stdData,
      // required this.context,
      required this.memorizerEmail});

  Widget build(context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => StudentProfile(
                  studentIDn: stdData['IDn'],
                  memorizerEmail: memorizerEmail,
                )));
      },
      child: Container(
        margin: EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Container(
                width: 45,
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.all(0),
                // child: GestureDetector(
                child: CircleAvatar(
                  radius: 20,
                  child: Image.asset(
                    height: 25,
                    "assets/icon/person.png",
                  ),
                ),
                // onTap: () {
                //   Navigator.of(context).push(
                //       MaterialPageRoute(
                //           builder: (context) =>
                //               StudentProfile(
                //                 studentIDn:
                //                     stdData['IDn'],
                //                 memorizerEmail:
                //                     memorizerEmail,
                //               )));
                // },
                // ),
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
                      (stdData['points']).toString(),
                      style: TextStyle(fontSize: 12, color: Colors.tealAccent),
                    ),
                    Text(
                      (stdData['surah']).toString(),
                      style: TextStyle(fontSize: 12, color: Colors.tealAccent),
                    )
                  ],
                ),
              )
            ]),
            ElevatedButton(
              child: Text(
                'Add Record',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
              ),
              onPressed: () async {
                Navigator.push(
                    context,
                    await MaterialPageRoute(
                        builder: (context) => NewRecord(
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
