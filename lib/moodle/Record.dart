import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tahfeez_app/moodle/Firestore.dart';
import 'package:tahfeez_app/moodle/student.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tahfeez_app/sqfDB.dart';

class Record {
  String? id, stdID, surah, date, type, isSynced, from, to,memorizerEmail;
  int? quality, pgsCount, commitment;

  Student? std;
SqlDb db = SqlDb();
  Firestore myFierstor = Firestore();

// Record(Student? std){
// this.std=std;
// }

  Record( stdID, surah, from, to, quality, pgsCount, commitment, type,
      isSynced,memorizerEmail) {
    this.stdID = stdID;
    this.surah = surah;
    this.from = from;
    this.to = to;
    this.quality = quality;
    this.pgsCount = pgsCount;
    this.commitment = commitment;
    this.type = type;
    this.isSynced = isSynced;
    this.memorizerEmail=memorizerEmail;
  }

}
