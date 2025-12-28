// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart' as intl;
import 'Firestore.dart';

  Firestore myFierstor = Firestore();

DateTime  _reformateDate(String date) {
  print("ywsterday is $date");
    DateTime newDate = intl.DateFormat('yyyy-MM-dd').parse(date);
    return newDate;
  }

String getStudentName(List names) {
  return (names[0] + " " + names[1]).toString();
}

class WhatsappMassage {
  // SqlDb db = SqlDb();
  List<Map> messageData = [];

  getRecordsToMessage(mEmail) async {
    
    DateTime today =  _reformateDate(DateTime.now().toString());
    CollectionReference temp = await myFierstor.getStudentsCollection(mEmail: mEmail);
    QuerySnapshot std=await temp.get();
    String stdName = "";
    for (int i = 0; i < std.docs.length; i++) {
      stdName = getStudentName([std.docs[i]["f_name"], std.docs[i]["l_name"]]);
  List<QueryDocumentSnapshot> records= await myFierstor.getStudentTodayRecords(mEmail: mEmail, idn:std.docs[i]['IDn'],today:today );

      if (records.isNotEmpty) {
        for (int j = 0; j < records.length; j++) {
         
          // if (today ==  _reformateDate(records[j]["date"])) {
            messageData.add({
              "name": stdName,
              "surah": records[j]["surah"],
              "from": records[j]["from"],
              "to": records[j]["to"],
              "pgs": records[j]["pgsCount"]
            });
          // } else {
          //   messageData.add({
          //     "name": stdName,
          //     "surah": "لم يسمع",
          //     "from": "",
          //     "to": "",
          //     "pgs": ""
          //   });
          // }
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
          "pgs": "0"
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
        msg += '\n❌${data[i]["name"]} ${data[i]["surah"]}';
      else
        msg +=
            '\n✅${data[i]["name"]} سورة ${data[i]["surah"]} من ${data[i]["from"]} الى ${data[i]["to"]} (${data[i]["pgs"]} صفحة)';
    }
    send(msg);
  }
}
