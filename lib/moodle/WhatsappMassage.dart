// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:tahfeez_app/sqfDB.dart';
import 'package:url_launcher/url_launcher.dart';

cropDate(String date) {
  return date.split(" ")[0];
}

String getStudentName(List names) {
  return (names[0] + " " + names[1]).toString();
}

class WhatsappMassage {
  SqlDb db = SqlDb();
  List<Map> messageData = [];

  getRecordsToMessage() async {
    String today = cropDate(DateTime.now().toString());
    List<Map> std = await db.readData("SELECT id,f_name,l_name FROM Students");
    String stdName = "";
    for (int i = 0; i < std.length; i++) {
      stdName = getStudentName([std[i]["f_name"], std[i]["l_name"]]);
      List<Map> records = await db
          .readData("SELECT * FROM Records WHERE std_id = '${std[i]['id']}'");
      if (!records.isEmpty) {
        for (int j = 0; j < records.length; j++) {
          if (today == cropDate(records[j]["date"])) {
            messageData.add({
              "name": stdName,
              "surah": records[j]["surah"],
              "from": records[j]["frm"],
              "to": records[j]["t"],
              "pgs": records[j]["pgs_count"]
            });
          } else {
            messageData.add({
              "name": stdName,
              "surah": "لم يسمع",
              "from": "",
              "to": "",
              "pgs": ""
            });
          }
          // messageData.add({
          //   "name": stdName,
          //   "surah": records[i]["surah"],
          //   "from": records[i]["frm"],
          //   "to": records[i]["t"],
          //   "pgs": records[i]["pgs_count"]
          // });
          // print(messageData);
        }
      } else {
        messageData.add({
          "name": stdName,
          "surah": "لم يسمع",
          "from": "",
          "to": "",
          "pgs": ""
        });
      }
      // print(stdName);
      // print(messageData[i]['surah']);
      // print(" 111111111111111111 ");
    }
    //
    getMessageOnFormat(messageData);
  }

  send(String msg) async {
    var url = "whatsapp://send?&text=$msg";
    await launch(url);
  }

  getMessageOnFormat(List<Map> data) {
    String msg = "كشف متابعة الطلاب اليومي";
    for (int i = 0; i < data.length; i++) {
      if (data[i]["surah"] == "لم يسمع")
        msg += '\n 🛑🚨 ${data[i]["name"]}  ${data[i]["surah"]}';
      else
        msg +=
            '\n 🔵 ${data[i]["name"]} سورة ${data[i]["surah"]} من ${data[i]["from"]} الى ${data[i]["to"]}';
    }
    send(msg);
  }
}
