import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tahfeez_app/moodle/Firestore.dart';
import 'Student.dart';
import 'package:intl/intl.dart' as intl;
// import 'package:tahfeez_app/sqfDB.dart';

class Record {
  String? id, stdID, surah, date, type, isSynced, from, to, memorizerEmail;
  int? quality, pgsCount, commitment;

  Student? std;
  // SqlDb db = SqlDb();
  Firestore myFierstor = Firestore();

// Record(Student? std){
// this.std=std;
// }

  Record(stdID, surah, from, to, quality, pgsCount, commitment, type, isSynced,
      memorizerEmail) {
    this.stdID = stdID;
    this.surah = surah;
    this.from = from;
    this.to = to;
    this.quality = quality;
    this.pgsCount = pgsCount;
    this.commitment = commitment;
    this.type = type;
    this.isSynced = isSynced;
    this.memorizerEmail = memorizerEmail;
  }

  addRecord(String stdID, String email, String surah, String from, String to,
      double quality, double pgsCount, double commitment, double type) async {
    try {
      // add record to local database
      // String localRecordID = await db.addRecord(
      //     stdID, surah, from, to, quality, pgsCount, commitment, type);
      // add record to cloud database
      String cloudRecordID = await myFierstor
          .addRecord(idn: stdID.toString(), mEmail: email, data: {
        'surah': surah,
        'from': from,
        'to': to,
        'quality': quality,
        'pgsCount': pgsCount,
        'commitment': commitment,
        'type': type,
        'isSynced': 'false'
      });
      // update record id field in local database
      // await db.updateRecordID(localRecordID, cloudRecordID);
      // update lastUpdate field in student cloud doc.
      myFierstor.setStudentLastUpdate(mEmail: email, idn: stdID.toString());
    } catch (e) {
      
  }
}
}