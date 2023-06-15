// import 'dart:js_interop';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tahfeez_app/services/MapStyle.dart';

class Firestore {
  final _db = FirebaseFirestore.instance;
  // SqlDb db = SqlDb();

  Future<CollectionReference> getHalaqatCollection() async {
    _db.settings = const Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);


    var halaqatColl = await _db.collection("Halaqat");
    var temp = await halaqatColl.get();
    return halaqatColl;
  }

  Future<DocumentReference> getHalaqaDoc({required String? mEmail}) async {
    var halaqa = await getHalaqatCollection();
    var temp = await halaqa.where("m-email", isEqualTo: mEmail).get();
    var doc = halaqa.doc(temp.docs.single.id);
    return doc;
  }

  // Future<String>  getHalaqaDocID({required String? email})async{
  //   var halaqa= await getHalaqaDoc(email: email);
  //   var temp=await halaqa.get();
  //   print(" 333333333333333 ");
  //   print(temp.docs.single.id);
  //   return temp.docs.single.id;
  // }

  Future<CollectionReference> getStudentsCollection(
      {required String? mEmail}) async {
    var halaqa = await getHalaqaDoc(mEmail: mEmail);
    var temp = await halaqa.collection("Students");
    var temp2 = await temp.get();
    return temp;
  }

  Future<DocumentReference> getStudentDoc(
      {required String? mEmail, required idn}) async {
    var students = await getStudentsCollection(mEmail: mEmail);
    var r = await students.get();
    var temp = await students
        .where("IDn",
            isEqualTo:
                idn!.runtimeType == int ? idn!.parse(idn!) : idn!.toString())
        .get();
    var stdDoc = students.doc(temp.docs.first.id);
    return stdDoc;
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
    // print(" 000000000000000000  ${r.docs.first.data()}   $idn");
    // var recordDoc = redords.doc(temp.docs.first.id);
    return r.docs;
  }


  getHalaqaData({String? mEmail}) async {
    DocumentReference halaqaDoc = await getHalaqaDoc(mEmail: mEmail!);
    DocumentSnapshot temp = await halaqaDoc.get();
    return temp.data();
  }

  getStudentData({required String? mEmail, required String? idn}) async {
    DocumentReference studentDoc =
        await getStudentDoc(mEmail: mEmail!, idn: idn!);
    DocumentSnapshot temp = await studentDoc.get();
    return temp.data();
  }

  Future<List<QueryDocumentSnapshot>> getStudentRecords(
      {required String? mEmail, required String? idn}) async {
    CollectionReference records =
        await getRecordsCollection(mEmail: mEmail, idn: idn);
    var temp = await records.get();
    return temp.docs;
  }

  setStudentLastUpdate({required String? mEmail, required String? idn}) async {
    var student = await getStudentDoc(mEmail: mEmail, idn: idn);
    DateTime now = DateTime.now();
    String date = intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    //    String date =
    // '${date.year}-${date.month}-${date.day} ${now.hour}:${now.minute}:${now.second}';
    student.update({'last_update': date});
    print("Students last_update is up to date");
  }

  setRecordSynced({String? mEmail, String? idn, String? recordID}) async {
    // should get record id and edit record based on his id
    var records = await getRecordsCollection(mEmail: mEmail, idn: idn);
    var record = records.doc(recordID);
    print(" ////////////////////////// *********************  ${record.path}");
    record.update({'isSynced': "true"});
  }

  setStudentData(
      {required String? mEmail,required String? idn, required Map<Object, Object>? data}) async {
    print(idn);
    MapStyle().printMap(data!);
    var student = await getStudentDoc(mEmail: mEmail, idn: idn);
    student.update(data!);
  } 

  doseStdHasRecords(mEmail, idn) {
    try {
      getRecordsCollection(mEmail: mEmail, idn: idn);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }


  addMemorizer(Map<String, dynamic> data) async {
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
    final students = await getStudentsCollection(mEmail: mEmail);
    students.add(data).then((documentSnapshot) =>
        print("Added Student with ID: ${documentSnapshot.id}"));
  }

  Future<String> addRecord({Map<String, dynamic>? data, idn, mEmail}) async {
    /*
    * returns the record ID generated by Firestore
    */
    final records = await getRecordsCollection(idn: idn, mEmail: mEmail);
    DateTime now = DateTime.now();
    String date = intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    data?.addEntries({"date":date}.entries);
    Future<String> result = records.add(data).then<String>((documentSnapshot) {
      print("Added Records with ID: ${documentSnapshot.id}");
      return documentSnapshot.id.toString();
    });

    return result;
  }

  



  

  // Future<Query<Map>> _snapshot(String memorizerEmail) async {
  //   final snapshot = await _db
  //       .collection("Halaqat")
  //       .where("m-email", isEqualTo: memorizerEmail);
  //   return snapshot;
  // }

  // // Future<HalaqaModel> getUserData(String email) async {
  // //   final snapshot =
  // //       await _db.collection("users").where("email", isEqualTo: email).get();
  // //   final userData =
  // //       snapshot.docs.map((e) => HalaqaModel.fromSnapshot(e)).single;
  // //   return userData;
  // // }

  // Future<String> getHalaqaID(String memorizerEmail) async {
  //   final snapshot = await _snapshot(memorizerEmail);
  //   final docs = await snapshot.get();
  //   final halaqaID = docs.docs.single.id.toString();
  //   // print(halaqaID);
  //   return halaqaID;
  // }

  // getStudentCollection({String? stdID, String? memorizerEmail}) async {
  //   final snapshot = await _snapshot(memorizerEmail!);
  //   String halaqaID = await getHalaqaID(memorizerEmail);
  //   // var a=await snapshot.firestore.doc("/Halaqat/pU5Y7bSCLZE1qDXJTBRE").collection("/Students").get();

  //   print(stdID);
  //   print(" ///////////// ");
  //   var halaqa = await snapshot.firestore.doc("/Halaqat/" + halaqaID);
  //   // var gets=await halaqa.collection("/Students")
  //   // .where("IDn", isEqualTo: stdID)
  //   // .get();
  //   var temp = await halaqa
  //       .collection("/Students")
  //       .where("IDn", isEqualTo: int.parse(stdID!))
  //       .get();
  //   var _temp = await halaqa
  //       .collection("/Students")
  //       .where("IDn", isEqualTo: int.parse(stdID));
  //   var tt = await _temp.firestore.collection("Records").add({'sad': 'dsa'});

  //   print(await temp.docs.first.data());
  //   print(await _temp.get());
  //   print(await tt.path);
  //   var studentID = temp.docs.single.id;
  //   print(studentID);
  //   return studentID;
  // }

  // // Future<List> getStudentByPhone(String stdPhone, String memorizerEmail) async {
  // //   final snapshot = await _snapshot(memorizerEmail);
  // //   String halaqaID = await getHalaqaID(memorizerEmail);
  // //   String studentID = await getStudentCollection(stdPhone, memorizerEmail);
  // //   var gets = await snapshot.firestore
  // //       .doc("/Halaqat/" + halaqaID)
  // //       .collection("/Students")
  // //       .where("phone", isEqualTo: stdPhone)
  // //       .get();
  // //   var students = gets.docs;
  // //   // print(students.first.data());
  // //   return students;
  // // }

  // addCollection({Map<String, dynamic>? data, String? collectionName}) async {
  //   CollectionReference halaqat = _db.collection("Halaqat");
  //   var result = await halaqat.add({"m-email": data!['m-email']});
  //   print(result.id);
  //   await addMutiCollection(
  //       halaqaID: result.id, data: data, collectionName: collectionName!);
  // }

  // Future<String?> addMutiCollection(
  //     {String? halaqaID,
  //     Map<String, dynamic>? data,
  //     String? collectionName}) async {
  //   CollectionReference halaqat = _db.collection("Halaqat");
  //   // data!.addEntries({"":""}.entries);
  //   var result =
  //       await halaqat.doc(halaqaID).collection(collectionName!).add(data!);
  //   // print(result.id);
  //   // print(await halaqat.doc(id).collection(collectionName!).doc(result.id).firestore.doc(result.id));
  //   // var result=halaqat.doc(id).collection(collectionName!).add(data!);
  //   return "done";
  // }

  // Future<String?> addMutiCollectionUsingEmail(
  //     {String? email,
  //     Map<String, dynamic>? data,
  //     String? collectionName}) async {
  //   print(email);
  //   CollectionReference halaqat = await _db.collection("Halaqat");
  //   // data!.addEntries({"":""}.entries);
  //   var result = await halaqat.where("m-email", isEqualTo: email);
  //   var x = await result.get();
  //   var id = await x.docs.first.id;
  //   addMutiCollection(halaqaID: id, collectionName: collectionName, data: data);
  //   // result.firestore.collection(collectionName!).add(data!);
  //   // return "done";
  // }

  // Future<String?> addMutiCollectionUsingStdID(
  //     {String? id, Map<String, dynamic>? data, String? collectionName}) async {
  //   CollectionReference students = await _db.collection("Students");
  //   // data!.addEntries({"":""}.entries);
  //   print(students.path);
  //   var result = await students.where("IDn", isEqualTo: int.parse(id!));
  //   print(" ------------- ");
  //   print(result.firestore);
  //   var x = await result.get();
  //   var ids = await x.docs.first.id;
  //   addMutiCollection(halaqaID: id, collectionName: collectionName, data: data);
  //   // result.firestore.collection(collectionName!).add(data!);
  //   // return "done";
  // }

  // addStudent(
  //     String stdPhone, String memorizerEmail, Map<String, dynamic> data) async {

  //        final snapshot = await _db
  //       .collectionGroup("Halaqat").where("m-email",isEqualTo: memorizerEmail);
  //       // snapshot.collection("Halaqat").add({'center':data['center'],'city':data['city'],'m-email':data['email']});
  //   addCollection(data:data,collectionName:"Students");
  //   // final snapshot = await _snapshot(memorizerEmail);
  //   // String halaqaID = await getHalaqaID(memorizerEmail);
  //   // String studentID = await getStudentID(stdPhone, memorizerEmail);
  //   // var r = await snapshot.firestore
  //   //     .doc("/Halaqat/" + halaqaID)
  //   //     .collection("/Students")
  //   //     .add(data);
  //   //     print(r.runtimeType); //add new record
  //   //     print(" rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr "); //add new record
  // }

  // updateStudent(
  //     String stdPhone, String memorizerEmail, Map<Object, Object> data) async {
  //   final snapshot = await _snapshot(memorizerEmail);
  //   String halaqaID = await getHalaqaID(memorizerEmail);
  //   String studentID = await getStudentCollection(stdPhone, memorizerEmail);
  //   var z = await snapshot.firestore
  //       .doc("/Halaqat/" + halaqaID)
  //       .collection("/Students")
  //       .doc(studentID)
  //       .update(data); // add "" to filed ""
  //   //get student by phone
  // }

//   addStudentRecord(
//       {String? stdID,
//       String? memorizerEmail,
//       Map<String, dynamic>? data}) async {
//     print(" ************* ");
//     getStudentCollection(stdID!, memorizerEmail!);
//     addMutiCollectionUsingStdID(
//         id: stdID, collectionName: "Records", data: data);
// //     final snapshot = await _snapshot(memorizerEmail!);
// //     String halaqaID = await getHalaqaID(memorizerEmail);
// //     String studentID = await getStudentCollection(stdID!, memorizerEmail);
// //     var s = await snapshot.firestore.collection("/Students");
// //         print("sssssssssssssss");
// //         print(s.path);
// //         var temp=await s.where("IDn",isEqualTo:int.parse(stdID)).get();

// // print("tttttttttttttt");
// // print(await  temp.docs.first.id);
//     // var r=await temp.collection("/Records")
//     // .add(data!); //add new record
//   }

//   Future<List<HalaqaModel>> getHalaqatData() async {
//     final snapshots = await _db.collection("Halaqat").snapshots().first;
//     var docs = await snapshots.docs;
// // var a=await docs;
//     print(docs.elementAt(0).id);
//     final snapshot = await _db.collection("Halaqat").get();
//     final userData = snapshot.docs
//         .map((halaqa) => HalaqaModel.fromSnapshot(halaqa))
//         .toList();
//     // print(userData);
//     return userData;
//   }

  // Future<Map<dynamic, Map>> getDataWithID(String docName) async {
  //   Map<String, Map> _doc = {};
  //   var i = await FirebaseFirestore.instance.collection(docName).get();
  //   i?.docs.forEach((doc) {
  //     Map temp = doc.data() as Map;
  //     _doc.addEntries({doc.id.toString(): temp}.entries);
  //   });
  //   return _doc;
  // }

  // upload(List<Map<String, dynamic>> dataList) async {
  //   var users = await FirebaseFirestore.instance.collection('users');

  //   dataList.forEach((std) async {
  //     // final json = {
  //     //   'f_name': '${std['f_name']}',
  //     //   'm_name': '${std['m_name']}',
  //     //   'l_name': '${std['l_name']}',
  //     //   'IDn': '${std['IDn']}',
  //     //   'DOB': '${std['DOB']}',
  //     //   'phone': '${std['phone']}',
  //     //   'school': '${std['school']}',
  //     //   'level': '${std['level']}',
  //     //   'score': '${std['score']}',
  //     //   'attendance': '${std['attendance']}',
  //     //   'commitment': '${std['commitment']}',
  //     //   'points': '${std['points']}',
  //     // };
  //     users.doc(std['id'].toString()).set(std);
  //     // .add(json)
  //     // .then((value) => print(" one data added to firestore"));
  //   });

  //   // var records = FirebaseFirestore.instance.collection('records');
  //   // dataList.forEach((std) async {
  //   //   final json = {
  //   //     'std-id': '${std['std-id']}',
  //   //     'sourah': '${std['sourah']}',
  //   //     'date': '${std['date']}',
  //   //     'from': '${std['from']}',
  //   //     'to': '${std['to']}',
  //   //     'quality': '${std['quality']}',
  //   //     'pages-count': '${std['pages-count']}',
  //   //     'commitment': '${std['commitment']}'
  //   //   };
  //   //   await records
  //   //       .add(json)
  //   //       .then((value) => print(" one data added to firestore"));
  //   // });

  //   // var attendance = FirebaseFirestore.instance.collection('attendance');
  //   // dataList.forEach((std) async {
  //   //   final json = {
  //   //     'std-id': '${std['std-id']}',
  //   //     'name': '${std['name']}',
  //   //     'date': '${std['date']}'
  //   //   };
  //   //   await attendance
  //   //       .add(json)
  //   //       .then((value) => print(" one data added to firestore"));
  //   // });
  // }

  // updateDocument(String id, newData) async {
  //   var user = await FirebaseFirestore.instance.collection('users').doc(id);
  //   // print(data);
  //   user.update(newData);
  // }

  // updateDocumentField(String id, String fieldName, newData) async {
  //   var user = await FirebaseFirestore.instance.collection('users').doc(id);
  //   // print(data);
  //   user.update({fieldName: newData});
  // }
}
