// import 'dart:js_interop';
// import 'dart:js_util';
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tahfeez_app/services/MapStyle.dart';
import 'package:tahfeez_app/sqfDB.dart';

class Firestore {
//  static Firestore? _instance;
//  Future<Firestore?> get instance async {
//     if (_instance==null) {
//       _instance = Firestore();
//     }
//     return _instance!;
//   }

  final ref = FirebaseFirestore.instance;
  // SqlDb db = SqlDb();
  // SqlDb db = SqlDb();

  Future<CollectionReference> getHalaqatCollection() async {
    var halaqatColl;
    halaqatColl = await ref.collection("Halaqat");

    return halaqatColl;
  }

  Future<DocumentReference> getHalaqaDoc({required String? mEmail}) async {
    var halaqa = await getHalaqatCollection();
    var temp = await halaqa.where("m-email", isEqualTo: mEmail).get();
    var doc = halaqa.doc(temp.docs.single.id);
    return doc;
  }

  getHalaqaData({String? mEmail}) async {
    DocumentReference halaqaDoc = await getHalaqaDoc(mEmail: mEmail!);
    DocumentSnapshot temp = await halaqaDoc.get();
    return temp.data();
  }

  // Future<String>  getHalaqaDocID({required String? email})async{
  //   var halaqa= await getHalaqaDoc(email: email);
  //   var temp=await halaqa.get();
  //   print(" 333333333333333 ");
  //   print(temp.docs.single.id);
  //   return temp.docs.single.id;
  // }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getNotDeletedStudentsCollection({required String? mEmail}) async {
    var halaqa = await getHalaqaDoc(mEmail: mEmail);
    var temp = await halaqa.collection("Students");
    var temp2 = await temp.where("isDeleted", isNotEqualTo: "true").get();
    return temp2.docs;
  }

  Future<CollectionReference> getStudentsCollection(
      {required String? mEmail}) async {
    var halaqa = await getHalaqaDoc(mEmail: mEmail);
    var temp = await halaqa.collection("Students");
    // var temp2 = await temp.where("isDeleted", isEqualTo: "false").get();
    return temp;
  }

  Future<DocumentReference> getStudentDoc(
      {required String? mEmail, required idn}) async {
    var students = await getStudentsCollection(mEmail: mEmail);
    // var r = await students.get();
    var temp = await students
        .where("IDn",
            isEqualTo:idn!.toString())
        .get();
    var stdDoc = students.doc(temp.docs.first.id);
    return stdDoc;
  }

  Future<Map<String, dynamic>> getStudentData(
      {required String? mEmail, required String? idn}) async {
    DocumentReference studentDoc =
        await getStudentDoc(mEmail: mEmail!, idn: idn!);
    DocumentSnapshot temp = await studentDoc.get();
    return temp.data() as Map<String, dynamic>;
  }

  Future<List<QueryDocumentSnapshot>> getStudentRecords(
      {required String? mEmail, required String? idn}) async {
    CollectionReference records =
        await getRecordsCollection(mEmail: mEmail, idn: idn);
    var temp = await records.get();
    return temp.docs;
  }

  Future<List<QueryDocumentSnapshot>> getStudentTodayRecords(
      {required String? mEmail,
      required String? idn,
      required DateTime today}) async {
    if (doseStdHasRecords(mEmail, idn)) {
      CollectionReference records =
          await getRecordsCollection(mEmail: mEmail, idn: idn);
      var temp = await records.where('date', isGreaterThan: today).get();
      return temp.docs;
    } else {
      return List.empty();
    }
  }

  Future setStudentLastUpdate(
      {required String? mEmail, required String? idn}) async {
    var student = await getStudentDoc(mEmail: mEmail, idn: idn);
    DateTime now = DateTime.now();
    String date = intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    //    String date =
    // '${date.year}-${date.month}-${date.day} ${now.hour}:${now.minute}:${now.second}';
    student.update({'last_update': date});
    print("Students last_update is up to date");
  }

  setStudentData(
      {required String? mEmail,
      required String? idn,
      required Map<Object, Object>? data}) async {
    var student = await getStudentDoc(mEmail: mEmail, idn: idn);
    student.update(data!);
  }

  bool doseStdHasRecords(mEmail, idn) {
    try {
      getRecordsCollection(mEmail: mEmail, idn: idn);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<CollectionReference> getRecordsCollection(
      {required String? mEmail, required idn}) async {
    var halaqa = await getStudentDoc(mEmail: mEmail, idn: idn);
    var temp = halaqa.collection("Records");
    return temp;
  }

  Future<List<QueryDocumentSnapshot>> getRecordDocs(
      {required String? mEmail, required String? idn}) async {
    var redords = await getRecordsCollection(mEmail: mEmail, idn: idn);
    var r = await redords.get();
    // var temp = await redords.where("IDn", isEqualTo: idn!).get();
    print(" 000000000000000000  ${r.docs.first.data()}   $idn");
    // var recordDoc = redords.doc(temp.docs.first.id);
    return r.docs;
  }

  setRecordSynced({String? mEmail, String? idn, String? recordID}) async {
    // should get record id and edit record based on his id
    var records = await getRecordsCollection(mEmail: mEmail, idn: idn);
    var record = records.doc(recordID);
    record.update({'isSynced': "true"});
  }

 Future addMemorizer(Map<String, dynamic> data) async {
    var halaqat = await getHalaqatCollection();
    var temp = halaqat.add({
      'center': data['center'],
      'city': data['city'],
      'm-email': data['email'],
      "memorizer": {"name": data['name'], "phone": data['phone'].toString()}
    }).then((documentSnapshot) =>
        print("Added Memorizer with ID: ${documentSnapshot.id}"));

  }

  addStudent({Map<String, dynamic>? data, mEmail}) async {
    var students = await getStudentsCollection(mEmail: mEmail);
    students.add(data).then((documentSnapshot) =>
        print("Added Student with ID: ${documentSnapshot.id}"));
  }

  addRecord({Map<String, dynamic>? data, idn, mEmail}) async {
    print('''try to add record of 
      $data
      for $idn
      in memorizer $mEmail
      with data : 
      $data''');
    final records = await getRecordsCollection(idn: idn, mEmail: mEmail);
    DateTime now = DateTime.now();
    // DateTime date =  intl.DateFormat('yyyy-MM-dd HH:mm:ss').parse(now.toString(),false);
    // print(now);
    // print('date');
    /*
    the prob is date appear in firebase more than local on 3 hours
    */
    data?.addEntries({"date": now}.entries);
    try {
      records.add(data).then((record) {
        print("Added Record with ID: ${record.id}");
      });
    } catch (e) {
      print('''Error
      
      $e
      ''');
    }
  }

  addOldRecord({Map<String, dynamic>? data, idn, mEmail}) async {
    print('''try to add record of 
      $data
      for $idn
      in memorizer $mEmail
      with data : 
      $data''');
    final records = await getRecordsCollection(idn: idn, mEmail: mEmail);
      records.add(data).then((record) {
        print("Added Record with ID: ${record.id}"); 
      });
   
  }

  deleteStudent(mEmail, stdIDn) async {
    final students = await getStudentsCollection(mEmail: mEmail);
    var s = await students.where("IDn", isEqualTo: stdIDn!).get();
    // students.doc(s.docs.first.id.toString()).delete().then(
    //       (doc) => print("Document deleted"),
    //       onError: (e) => print("Error updating document $e"),
    //     );
  }

/**
 * 
 * **
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 * *
 */

  syncItem(Map cloudData, Map localData, mEmail) {
    var cloudDate = _reformateDate(cloudData['last_update'].toString());
    var localDate = _reformateDate(cloudData['last_update'].toString());
    if (cloudDate.compareTo(localDate) >= 1) {
      // local data is old
      // updateLocalDatabase(cloudData);
      // syncRecords();
    } else if (cloudDate.compareTo(localDate) <= -1) {
      // firestore data is old
      // updateCloud();
    }
  }

  // updateCloud() {
  //   // syncRecords();
  //   setStudentData(
  //       mEmail: mEmail,
  //       data: localData as Map<Object, Object>,
  //       idn: cloudData['IDn'].toString());
  // }

  DateTime _reformateDate(String date) {
    DateTime newDate = intl.DateFormat('yyyy-MM-dd HH:mm:ss').parse(date);
    return newDate;
  }

  // syncData(mEmail) async {
  //   try {
  //     CollectionReference _firestoreData =
  //         await getStudentsCollection(mEmail: mEmail);
  //     QuerySnapshot cloudStudents = await _firestoreData.get();
  //     List<Map<String, dynamic>> localStudents = await db
  //         .readData("select * from Students") as List<Map<String, dynamic>>;

  //     // var cloudDate, localDate;
  //     Map<Object, Object> localStudent = {};
  //     // var cloudStudent;

  //     // syncStudentData(cloudDate, localDate, cloudStudents, localStudent, mEmail);

  //     // if (cloudStudents.docs.length == localStudents.length) {
  //     //   for (int i = 0; i < cloudStudents.docs.length; i++) {
  //     //     cloudStudent = cloudStudents.docs[i].data() as Map;
  //     //     // Map temp = await localStudents
  //     //     //     .where((element) =>
  //     //     //         element['IDn'].toString() == cloudStudent['IDn'].toString())
  //     //     //     .single;
  //     //     List<Map> _temp = await db.readData(
  //     //         'select * from Students where IDn=${cloudStudent['IDn']}');
  //     //     Map temp = _temp.single;
  //     //     temp.forEach((key, value) {
  //     //       Object _key = key as Object;
  //     //       Object _value = value as Object;
  //     //       localStudent.addEntries({_key: _value}.entries);
  //     //     });
  //     //     cloudDate = _reformateDate(cloudStudent['last_update'].toString());
  //     //     localDate = _reformateDate(localStudent['last_update'].toString());
  //     //     if ((localStudent != null && cloudStudent != null) &&
  //     //         (!localStudent.isEmpty && !cloudStudent.isEmpty)) {
  //     //       syncStudentData(
  //     //           cloudDate, localDate, cloudStudent, localStudent, mEmail);
  //     //       // if (cloudDate.compareTo(localDate) >= 1) {
  //     //       //   // local data is old
  //     //       //   updateLocalDatabase(cloudStudent);
  //     //       // } else if (cloudDate.compareTo(localDate) <= -1) {
  //     //       //   // firestore data is old
  //     //       //    setStudentData(
  //     //       //       email: memorizerEmail,
  //     //       //       data: localStudent,
  //     //       //       id: localStudent['IDn'].toString());
  //     //       // } else if (cloudDate.compareTo(localDate) == 0) {
  //     //       // }
  //     //     } else if ((!cloudStudent.isEmpty && localStudent.isEmpty) ||
  //     //         (cloudStudent != null && localStudent == null)) {
  //     //       // updateLocalDatabase(cloudStudent);
  //     //     } else if ((cloudStudent.isEmpty && !localStudent.isEmpty) ||
  //     //         (cloudStudent == null && localStudent != null)) {
  //     //       //  setStudentData(
  //     //       //     email: memorizerEmail,
  //     //       //     data: localStudent as Map<Object, Object>,
  //     //       //     id: localStudent['IDn'].toString());
  //     //     }
  //     //     // } catch (e) {
  //     //     //
  //     //     //   // QuickAlert.show(
  //     //     //   //     context: context,
  //     //     //   //     type: QuickAlertType.error,
  //     //     //   //     text: e.toString(),
  //     //     //   //     title: "حدث خلل غير متوقع, قم بإرسال لقطة شاشة للدعم الفني");
  //     //     // }
  //     //   }
  //     // } else
  //     if (cloudStudents.docs.length <= localStudents.length) {
  //       List<Map> newstudents = List.from(localStudents);
  //       if (cloudStudents.docs.length != 0) {
  //         for (int i = 0; i < localStudents.length; i++) {
  //           for (int j = 0; j < cloudStudents.docs.length; j++) {
  //             if (localStudents[i]['IDn'].toString() ==
  //                 cloudStudents.docs[j]['IDn'].toString()) {
  //               syncItem(cloudStudents.docs[j].data(), localStudent[i]);
  //               setStudentLastUpdate(
  //                   mEmail: mEmail,
  //                   idn: cloudStudents.docs[j]['IDn'].toString());
  //               if (j >= cloudStudents.docs.length &&
  //                   (cloudStudents.docs[j]['isDeleted'].toString() == 'false' ||
  //                       cloudStudents.docs[j]['isDeleted'].toString() ==
  //                           null)) {
  //                 addStudent(mEmail: mEmail, data: localStudents[i]);
  //               } else {
  //                 deleteStudent(mEmail, cloudStudents.docs[j]['IDn']);
  //               }
  //               break;
  //             }
  //           }
  //         }
  //       }
  //       newstudents.forEach((std) async {
  //         await addStudent(data: std as Map<String, dynamic>, mEmail: mEmail);
  //       });
  //     } else if (cloudStudents.docs.length > localStudents.length) {
  //       List newstudents = List.from(cloudStudents.docs.toList());
  //       if (cloudStudents.docs.length != 0) {
  //         for (int i = 0; i < cloudStudents.docs.length; i++) {
  //           for (int j = 0; j < localStudents.length; j++) {
  //             if (localStudents[j]['IDn'].toString() ==
  //                 cloudStudents.docs[i]['IDn'].toString()) {
  //               newstudents.removeWhere((element) =>
  //                   element['IDn'] == cloudStudents.docs[i]['IDn']);
  //               break;
  //             }
  //           }
  //         }
  //       }
  //       for (int s = 0; s < newstudents.length; s++) {
  //         var std = newstudents[s];
  //         int response = await db.insertData(
  //             "INSERT INTO 'Students' (f_name, m_name ,l_name, IDn, DOB ,phone, school, level, score, attendance, commitment, points, lastTest ,lastTestDegree ,last_update) VALUES ('${std['f_name']}', '${std['m_name']}', '${std['l_name']}' , '${std['IDn']}' ,'${std['DOB']}','${std['phone']}', '${std['school']}', '${std['level']}', '${std['score']}','${std['attendance']}','${std['commitment']}','${std['points']}','${std['lastTest']}' , '${std['lastTestDegree']}' , '${std['last_update']}')");
  //         if (response == 0) break;
  //       }
  //     }
  //     // List<Map<String, dynamic>> localData = await db.readData(
  //     //     "SELECT score ,attendance ,commitment ,points FROM Students");
  //     /*
  //     score attendance commitment points previous_points last_update
  //         */
  //     // if ((localStudents != null && students.docs != null) &&
  //     //     (!localStudents.isEmpty && !students.docs.isEmpty)) {
  //     //   for (int i = 0; i < students.docs.length; i++) {
  //     //     var fd = _reformateDate(students.docs[i].data()
  //     //         .elementAt(i)['last_update']
  //     //         .toString()
  //     //         .split("T")[0]); //"2012-02-27 13:27:00"
  //     //     var ld = _reformateDate(
  //     //         localStudents[i]['last_update'].toString().split("T")[0]);
  //     //     if (fd.compareTo(ld) == 1) {
  //     //       // local data is old
  //     //       updateLocalDatabase(
  //     //           students.docs.values.elementAt(i)['id'].toString(),
  //     //           students.docs.values.elementAt(i));
  //     //     } else if (ld.compareTo(fd) == 1) {
  //     //       // firestore data is old
  //     //       fb.updateDocument(localStudents[i]['id'].toString(), localStudents[i]);
  //     //     } else if (ld.compareTo(fd) == 0) {
  //     //     }
  //     //   }
  //     // }
  //     //  else if (localData == null || localData.isEmpty) {
  //     //   Map<dynamic, Map> firestoreRecordData =
  //     //       await getFirestoreDataAsListWithID('record');
  //     //   Map<dynamic, Map> firestoreAtteData =
  //     //       await getFirestoreDataAsListWithID('attendance');
  //     //   // _updateLocalDataBasedOnFirebase(
  //     //   //     firestoreData.values.toList(),
  //     //   //     firestoreRecordData.values.toList(),
  //     //   //     firestoreAtteData.values.toList());
  //     // }
  //     // else if (localData.length > firestoreData.length) {
  //     //   _uploadeDataToFirestore(localData); // update local data
  //     // }
  //     return true;
  //   } on Exception catch (e) {
  //     // Navigator.pop(context);
  //     // QuickAlert.show(
  //     //     context: context,
  //     //     type: QuickAlertType.error,
  //     //     text: e.toString(),
  //     //     title: "حدث خلل غير متوقع, قم بإرسال لقطة شاشة للدعم الفني");
  //     return false;
  //   }
  // }

  // updateLocalDatabase(Map data) async {
  //   String school = data['school'].toString();
  //   await db.updateData(
  //       "UPDATE 'Students' SET school='$school', score= ${data['score']} , attendance=${data['attendance']} ,commitment= ${data['commitment']} , points=${data['points']}, lastTest=${data['lastTest']},lastTestDegree=${data['lastTestDegree']}, phone=${data['phone']} WHERE IDn=${data['IDn']}"); //last_update='${data['last_update']}',
  // }

  // syncStudentData(DateTime cloudDate, DateTime localDate, cloudStudent,
  //     Map<Object, Object> localStudent, mEmail) {
  //   if (cloudDate.compareTo(localDate) >= 1) {
  //     // local data is old
  //     updateLocalDatabase(cloudStudent);
  //     // syncRecords();
  //   } else if (cloudDate.compareTo(localDate) <= -1) {
  //     // firestore data is old
  //     // syncRecords();

  //     setStudentData(
  //         mEmail: mEmail,
  //         data: localStudent,
  //         idn: cloudStudent['IDn'].toString());
  //   }
  // }

  // syncRecords(QuerySnapshot cloudStudents, mEmail) async {
  //   try {
  //     var _cloudStudents = cloudStudents.docs;
  //     for (int i = 0; i < _cloudStudents.length; i++) {
  //       var stdDoc = _cloudStudents[i];
  //       Map cloudStudent = await stdDoc.data() as Map;
  //       MapStyle().printMap(cloudStudent);
  //       DateTime cloudeLastUpdate =
  //           _reformateDate(stdDoc['last_update'].toString());
  //       List<Map> tempLastUpdate = await db.readData(
  //           "select * from Students where IDn=${cloudStudent['IDn']}");
  //       MapStyle().printMap(tempLastUpdate.single);
  //       DateTime localLastUpdate =
  //           _reformateDate(tempLastUpdate[0]['last_update'].toString());
  //       if (cloudeLastUpdate.compareTo(localLastUpdate) >= 1) {
  //         if (doseStdHasRecords(mEmail, cloudStudent['IDn'])) {
  //           var cloudeRecords = List<QueryDocumentSnapshot>.from(
  //               await getStudentRecords(
  //                   mEmail: mEmail, idn: cloudStudent['IDn'].toString()));
  //           // cloudeRecords.forEach((rd) async
  //           for (int j = 0; j < cloudeRecords.length; j++) {
  //             var rd = cloudeRecords[j];
  //             Map record = rd.data() as Map;
  //             if (record['isSynced'] == "false") {
  //               MapStyle().printMap(record);
  //               await db.insertData(
  //                   "INSERT INTO 'Records' (id,std_id, surah, date, frm, t, quality, pgs_count, commitment, type,isSynced) VALUES ('${rd.id}' , '${cloudStudent['IDn'].toString()}','${record['surah']}','${record['date']}',${record['from']},${record['to']},${record['quality']},${record['pgsCount']},${record['commitment']},'${{
  //                 record['type']
  //               }}','true')");
  //               List<Map> oldStudentData = await db.readData(
  //                   " Select score,commitment, points, attendance, last_update From 'Students' WHERE IDn=${cloudStudent['IDn']}");
  //               var _score = record['pgsCount'] * record['quality'];
  //               double _factor = (record['type'] == "مراجعة") ? 0.5 : 1;
  //               var _points = (_score * _factor);
  //               DateTime now = DateTime.now();
  //               DateTime date = _reformateDate(now.toString());
  //               // intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  //               await db.updateData(
  //                   "UPDATE 'Students'  SET commitment= ${record['commitment'] + oldStudentData[0]['commitment']}, points=${_points + oldStudentData[0]['points']} , attendance='${oldStudentData[0]['attendance'] + 1}' , last_update='${date.toString()}' WHERE IDn=${cloudStudent['IDn']}");
  //               MapStyle().printMap(cloudStudent);
  //               await setRecordSynced(
  //                   idn: cloudStudent['IDn'].toString(),
  //                   mEmail: mEmail,
  //                   recordID: rd.id);
  //             }
  //           }
  //         }
  //       } else if (cloudeLastUpdate.compareTo(localLastUpdate) <= -1) {
  //         var localRecords = await db.readData(
  //             "select * from Records where std_id=${cloudStudent['IDn']}");
  //         // localRecords.forEach((record) async {
  //         for (int j = 0; j < localRecords.length; j++) {
  //           var record = localRecords[j];
  //           MapStyle().printMap(record);
  //           if (record['isSynced'] == "false") {
  //             // await db.updateData(
  //             //     "UPDATE Records Set isSynced='true' where id=${record['id']}");
  //             MapStyle().printMap(record);
  //             await addRecord(
  //                 idn: record['std_id'],
  //                 data: record as Map<String, dynamic>,
  //                 mEmail: mEmail);
  //           }
  //         }
  //       }
  //       // var cloudeRecords;
  //       // try {} catch (e) {
  //       // }
  //       // else if (cloudeRecords.length > localRecords.length) {
  //       //   _cloudStudents.forEach((student) async {
  //       //     cloudeRecords.forEach((rd) async {
  //       //       Map record = rd.data() as Map;
  //       //       if (record['isSynced'] == "false") {
  //       //         await db.insertData(
  //       //             "INSERT INTO 'Records' (std_id, surah, date, frm, t, quality, pgs_count, commitment, type,isSynced) VALUES ('${student['IDn'].toString()}','${record['surah']}','${record['date']}',${record['from']},${record['to']},${record['quality']},${record['pgsCount']},${record['commitment']},'${{
  //       //           record['type']
  //       //         }}','true')");
  //       //         DateTime now = DateTime.now();
  //       //         String date = intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  //       //         List<Map> oldStudentData = await db.readData(
  //       //             " Select score,commitment, points, attendance, last_update From 'Students' WHERE IDn=${student['IDn']}");
  //       //         var _score = record['pgsCount'] * record['quality'];
  //       //         double _factor = (record['type'] == "مراجعة") ? 0.5 : 1;
  //       //         var _points = (_score * _factor);
  //       //         await db.updateData(
  //       //             "UPDATE 'Students'  SET commitment= ${record['commitment'] + oldStudentData[0]['commitment']}, points=${_points + oldStudentData[0]['points']} , attendance='${oldStudentData[0]['attendance'] + 1}' , last_update='$date' WHERE IDn=${student['IDn']}");
  //       //       }
  //       //       var cloudRecord = await  setRecordSynced(
  //       //           idn: student['IDn'].toString(), mEmail: memorizerEmail);
  //       //       cloudeRecords;
  //       //     });
  //       //   });
  //       // }
  //     }
  //     return true;
  //   } catch (e) {
  //     // QuickAlert.show(
  //     //     context: context,
  //     //     type: QuickAlertType.error,
  //     //     text: e.toString(),
  //     //     title: "حدث خلل غير متوقع, قم بإرسال لقطة شاشة للدعم الفني");
  //     return false;
  //   }
  // }
}
