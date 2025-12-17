// ignore_for_file: avoid_print, use_build_context_synchronously, avoid_function_literals_in_foreach_calls, curly_braces_in_flow_control_structures, file_names, no_leading_underscores_for_local_identifiers, await_only_futures, unnecessary_cast, prefer_interpolation_to_compose_strings, prefer_const_constructors, unused_element, annotate_overrides, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'dart:ffi';
import 'dart:io';
// import 'dart:js_interop';
import 'package:age_calculator/age_calculator.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/models/quickalert_options.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_container.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tahfeez_app/ContactUs.dart';
import 'package:tahfeez_app/Login.dart';
import 'package:tahfeez_app/NewRecord.dart';
import 'package:tahfeez_app/StudenProfile.dart';
import 'package:tahfeez_app/moodle/BottomBar.dart';
import 'package:tahfeez_app/moodle/MenuItem.dart';
import 'package:tahfeez_app/moodle/MenuItems.dart';
import 'package:tahfeez_app/moodle/bug-report-overlay.dart';
import 'package:tahfeez_app/moodle/Student.dart';
import 'package:tahfeez_app/services/MapStyle.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'sqfDB.dart';
import 'package:tahfeez_app/moodle/WhatsappMassage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'moodle/Firestore.dart';

class Home extends StatefulWidget {
  // final String memorizerEmail;

  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  // SqlDb db = SqlDb();
  Firestore myFierstor = Firestore();
  Duration? executionTime;
  // Future<dynamic> _exportAllStudetDate() async {
  //   List<Map> result = await _getStudentsDate();
  //   return result;
  //   // exportToExcel(result, "AllStdData.xlsx");
  // }

  // Future<dynamic> _exportAllRecordsDate() async {
  //   List<Map> result = await db.readData("SELECT * FROM Records");
  //   return result;
  //   // exportToExcel(result, "AllStdRecords.xlsx");
  // }

  // Future<dynamic> _exportAllAttendanceDate() async {
  //   List<Map> result = await db.readData("SELECT * FROM Attendance");
  //   return result;
  //   // exportToExcel(result, "AllStdAttendance.xlsx");
  // }

  // sortList(List<Map> list) {
  //   List<Map> _list = list.toList();
  //   List<Map> sorted = [];
  //   Map _max = {};
  //   for (var i = 0; i < list.length; i++) {
  //     _max = _list[0];
  //     for (var j = 0; j < _list.length; j++) {
  //       _max = max(_max, _list[j]);
  //     }

  //     _list.removeWhere((element) {
  //       return element['id'] == _max['id'];
  //       // if (t == 0) {
  //       //   return true;
  //       // } else
  //       //   return false;
  //     });
  //     sorted.add(_max);
  //   }
  //   return sorted;
  // }

  max(a, b) {
    if (double.parse(a['points']) >= double.parse(b['points']))
      return a;
    else
      return b;
  }

  // Future<List<Map>> _getStudentsDate() async {
  //   List<Map> result = await db.readData("SELECT * FROM Students");
  //   return result;
  // }

  Future exportToExcel(
    List<QueryDocumentSnapshot<Object?>> data,
  ) async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: "جاري التصدير...",
    );
    var records;
    // print(" ============ ON Export 11===========");

    List<Map> t1 = List<Map>.empty(growable: true);
    List<Map> t2 = List<Map>.empty(growable: true);
    for (int j = 0; j < data.length; j++) {
      t1.add(data[j].data() as Map);
      var stdData = data[j].data() as Map;
      var rtemp = await myFierstor.getRecordsCollection(
          mEmail: memorizerEmail, idn: stdData['IDn']);
      var records = await rtemp.get();
      Map record;
      for (int i = 0; i < records.docs.length; i++) {
        print("rec.id");
        print(records.docs[i].id);
        record = await records.docs[i].data() as Map;
        record.addEntries({"IDn": stdData['IDn']}.entries);
        t2.add(await record);
      }
    }
    List<List<Map>> _data = [];
    _data.add(t1);
    _data.add(t2);
    final stopwatch = Stopwatch()..start();
    _data[0].insert(
        0,
        {
          'f_name': 'الإسم الأول',
          'm_name': 'الإسم الأوسط',
          'l_name': 'الإسم الأخير',
          'IDn': 'رقم الهوية',
          'DOB': 'تاريخ الميلاد',
          'phone': 'رقم الجوال',
          'school': 'المدرسة',
          'level': 'المستوى',
          'attendance': 'عدد ايام الحضور',
          'points': 'النقاط',
          'lastTest': ' اخر اختبار ',
          'lastTestDegree': 'درجة اخر اختبار ',
          'last_update': 'اخر تحديث'
        } as Map);
    // _data[2].insert(
    //     0,
    //     {
    //       "id": "م",
    //       "std_id": "معرف الطالب في النظام ",
    //       'name': 'الإسم ',
    //       "date": "التاريخ"
    //     } as Map);
    _data[1].insert(
        0,
        {
          "IDn": "رقم هوية الطالب",
          "surah": "السورة",
          "from": "من",
          "to": "الى",
          "date": "التاريخ",
          "quality": "جودة التسميع",
          "pgsCount": "عدد الصفحات",
          "commitment": "الالتزام",
          "type": 'نوع التسجيل',
          // "isSynced": "تمت المزامنة؟"
        } as Map);
    final excel = Excel.createExcel();

    print(excel.sheets.keys);
    // excel.link("data", sheet);
    Sheet sheet = excel['data'];
    print(excel.sheets.keys);
    excel.link("records", sheet);
    // excel.link("data", sheet);
    // excel.rename("Sheet1", "data");
    // excel.link("attendance", sheet);
    excel.unLink("Sheet1");
    excel.delete("Sheet1");

    excel.unLink("records");
    print(excel.sheets.keys);

    // excel.unLink("attendance");
    // print(_data[1].keys);
    for (var j = 0; j < _data.length; j++) {
      sheet = excel.sheets.values.elementAt(j);
      print(excel.sheets.values.elementAt(j).sheetName);
      var list = _data[j];
      /* add  titles row  */
      for (var i = 0; i < list[0].keys.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = list[0].keys.elementAt(i);
      }

      for (var row = 0; row < list.length; row++) {
        if (j == 0) {
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
              .value = TextCellValue(list[row]['f_name'].toString());
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
              .value = TextCellValue( list[row]['m_name'].toString());
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
              .value = TextCellValue(list[row]['l_name'].toString());
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
              .value = TextCellValue(list[row]['IDn'].toString());
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
              .value = TextCellValue(list[row]['DOB'].toString());
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
              .value = TextCellValue(list[row]['phone'].toString());
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row))
              .value = TextCellValue(list[row]['school'].toString());
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row))
              .value = TextCellValue(list[row]['level'].toString());
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: row))
              .value = TextCellValue(list[row]['attendance'].toString());
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: row))
              .value = TextCellValue(list[row]['points'].toString());
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: row))
              .value = TextCellValue(list[row]['lastTest'].toString());
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: row))
              .value = TextCellValue(list[row]['lastTestDegree'].toString());
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: row))
              .value = TextCellValue(list[row]['last_update'].toString());
        } else if (j == 1) {
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
              .value = TextCellValue(list[row]['IDn'].toString());
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
              .value = TextCellValue(list[row]['surah'].toString());
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
              .value = TextCellValue(list[row]['from'].toString());
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
              .value = TextCellValue(list[row]['to'].toString());
          if (list[row]['date'].runtimeType == Timestamp) {
            var s = list[row]['date'] as Timestamp;
            print(s.toDate().toString() + " 1111111111");
            sheet
                .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
                .value = TextCellValue(s.toDate().toString());
          } else {
            sheet
                .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
                .value = TextCellValue(list[row]['date'].toString());
          }
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
              .value = TextCellValue(list[row]['quality'].toString());
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row))
              .value = TextCellValue(list[row]['pgsCount'].toString());
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row))
              .value = TextCellValue(list[row]['commitment'].toString());
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: row))
              .value = TextCellValue((list[row]['type'].toString() == '1') ? "مراجعة" : "حفظ");
        }

//         print('''
// 12212121212121212
// ${sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value}              ''');

        print(" ============ ON Export ===========");
        // print(list[row]);
      }
    }
    var fileBytes = excel.save(fileName: 'data.xlsx');
    saveFile(fileBytes, 'data.xlsx').then((value) {
      Navigator.pop(context);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: "تم التصدير بنجاح",
      );
      //  Navigator.pop(context);
    });
    setState(() {
      executionTime = stopwatch.elapsed;
    });
  }

  Future<bool> saveFile(fileBytes, fileName) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.manageExternalStorage)) {
          await _requestPermission(Permission.accessMediaLocation);
          directory = await getExternalStorageDirectory();
          String newPath = "";
          List<String> paths = directory!.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/Tahfeez";
          directory = Directory(newPath);
          directory.create(recursive: true);
        } else {
          return false;
        }
      }

      File saveFile = File('${directory!.path}/$fileName');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        saveFile.create();
        saveFile.writeAsBytes(fileBytes);
      }
      return false;
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<String> get localPath async {
    Directory path = await getApplicationDocumentsDirectory();
    return path.path;
  }

  Future<List<List<Map<String, dynamic>>>> _exportFromExcelAsListOfMaps(
      filePath) async {
    List<List<Map<String, dynamic>>> fileData = [];
    var bytes = File(filePath).readAsBytesSync();
    print(filePath);
    var excel = Excel.decodeBytes(bytes);
    print(excel.tables.keys);
    for (var table in excel.tables.keys) {
      if (table.characters.toString() == "data") {
        print(" ================= Data ================= ");
        List<Map<String, dynamic>> temp = [];
        for (var row in excel.tables[table]!.rows) {
          // print(' 33333333333333333 ');
          // print(data[0]['last_update']);
          // print(row);
          // print("\n");
          temp.add({
            'f_name': row[0]!.value.toString().trim(),
            'm_name': row[1]!.value.toString().trim(),
            'l_name': row[2]!.value.toString().trim(),
            'IDn': row[3]!.value.toString().trim(),
            'DOB': row[4]!.value.toString().trim(),
            'phone': row[5]!.value.toString().trim(),
            'school': row[6]!.value.toString().trim(),
            'level': row[7]!.value.toString().trim(),
            'attendance': row[8]!.value.toString().trim(),
            'points': row[9]!.value.toString().trim(),
            'lastTest': row[10]!.value.toString().trim(),
            'lastTestDegree': row[11]!.value.toString().trim(),
            'last_update': row[12]!.value.toString().trim(),
            'isDeleted': 'false',
          });
        }
        temp.removeAt(0);
        fileData.add(temp);
        // print(" ============== Data =============");
        print(table.characters.toString());
      }
      /* This method is ready to use, just un-command it */
      // else if (table.characters.toString() == "attendances") {
      //   print(" ================= attendences ================= ");
      //   List<Map<String, dynamic>> temp = [];
      //   for (var row in excel.tables[table]!.rows) {
      //     // print(row[0]!.value);
      //     // print("\n");
      //     temp.add({
      //       'std-id': row[1]!.value,
      //       'name': row[2]!.value,
      //       'date': row[3]!.value
      //     });
      //     // print('${row}');
      //     print('${row[2]!.value}');
      //   }
      //   temp.removeAt(0);
      //   fileData.add(temp);
      //   // print(" ============== Atte =============");
      //   // print(fileData);
      // }
      else if (table.characters.toString() == "records") {
        print(
            " ================= records ================= ${excel.tables[table]!.rows.length} ");
        List<Map<String, dynamic>> temp = [];
//         print(
//             "excel.tables[table]!.cu.length = ${excel.tables[table]!.rows.length}");
//         print(
//             "excel.tables[table]!.cu.length = ${excel.tables[table]!.rows.first.length}");
//         for (int j = 0; j < excel.tables[table]!.rows.length; j++) {
//           print('''${excel.tables[table]!.rows.first[j]!.cellIndex}
// ${excel.tables[table]!.rows.first[j]!.colIndex}
// ${excel.tables[table]!.rows.first[j]!.rowIndex}
// ${excel.tables[table]!.rows.first[j]!.cellType}
// ${excel.tables[table]!.rows.elementAt(2)[0]!.value}
// ${excel.tables[table]!.rows.elementAt(2)[1]!.value}
// ${excel.tables[table]!.rows.elementAt(2)[2]!.value}
// ${excel.tables[table]!.rows.elementAt(2)[3]!.value}
// ${excel.tables[table]!.rows.elementAt(2)[4]!.value}
// ${excel.tables[table]!.rows.elementAt(2)[5]!.value}
// ${excel.tables[table]!.rows.elementAt(2)[6]!.value}
// ${excel.tables[table]!.rows.elementAt(2)[7]!.value}
// ${excel.tables[table]!.rows.elementAt(2)[8]!.value}

// -------------------------------------------------------
//             ''');
//         }
        for (var row in excel.tables[table]!.rows) {
          print(row[0]!.value);
          temp.add({
            'IDn': row[0]!.value,
            'surah': row[1]!.value,
            'from': row[2]!.value,
            'to': row[3]!.value,
            'date': row[4]!.value,
            'quality': row[5]!.value,
            'pgsCount': row[6]!.value,
            'commitment': row[7]!.value,
            'type': row[8]!.value,
          });
        }
        temp.removeAt(0);
        fileData.add(temp);
        // print(" ============== Records =============");
        // print(fileData);
      }
    }
    return fileData;
  }

  // _importDateToLocalDB(List<List<Map>> dataList) async {
  //   dataList[0].forEach((std) {
  //     //previous_points
  //     var sql =
  //         '''INSERT INTO 'students' ( f_name, m_name, l_name, IDn, DOB, phone, school, level, score , attendance , commitment , points, lastTest, lastTestDegree,last_update)VALUES ( '${std['f_name'].toString().trim()}' , '${std['m_name'].toString().trim()}' , '${std['l_name'].toString().trim()}' , '${std['IDn']}' , '${std['DOB'].toString().trim()}' , '${std['phone']}' , '${std['school'].toString().trim()}' , '${std['level'].toString().trim()}' , ${std['score']} , ${std['attendance']} , ${std['commitment']} , ${std['points']} ,'${std['lastTest'].toString().trim()}' ,'${std['lastTestDegree'].toString().trim()}', '${std['last_update'].toString().trim()}' ) ''';
  //     // print(std);
  //     // print("\n");
  //     db.insertData(sql);
  //   });
  //   /* This method is ready to use, just un-command it */
  //   // print(" ============== Atten 22=============");
  //   // dataList[1].forEach((std) {
  //   //   var sql =
  //   //       '''INSERT INTO 'Attendance' (std_id, name, date )VALUES ( '${std['std-id']}' , '${std['name']}' , '${std['date']}'  ) ''';
  //   //   // print(std);
  //   //   // print("\n");
  //   //   db.insertData(sql);
  //   // });
  //   // print(" ============== Records 22=============");
  //   // dataList[2].forEach((std) {
  //   //   // print("std");
  //   //   // print(std);
  //   //   var sql =
  //   //       '''INSERT INTO 'Records'(std_id, surah, date, frm, t, quality, pgs_count, commitment, type) VALUES ( '${std['std-id']}' , '${std['sourah']}' , '${std['date']}' , '${std['from']}' , '${std['to']}' , '${std['quality']}' , '${std['pages-count']}' , '${std['commitment']}', '${std['type']}') ''';
  //   //   // print(std);
  //   //   // print(std['std_id']);
  //   //   // print("\n");
  //   //   db.insertData(sql);
  //   // });
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(SnackBar(content: Text("تم ادراج البيانات بنجاح")));
  // }
  PopupMenuItem<MyMenuItem> buildItem(MyMenuItem item) {
    return PopupMenuItem<MyMenuItem>(
      value: item,
      child: Row(
        children: [
          Icon(
            item.icon,
            color: Colors.black,
          ),
          SizedBox(
            width: 10,
          ),
          Text(item.text),
        ],
      ),
    );
  }
  // updateLocalDatabase(Map data) async {
  //   String school = data['school'].toString();
  //   await db.updateData(
  //       "UPDATE 'Students' SET school='$school', score= ${data['score']} , attendance=${data['attendance']} ,commitment= ${data['commitment']} , points=${data['points']}, lastTest=${data['lastTest']},lastTestDegree=${data['lastTestDegree']}, phone=${data['phone']} WHERE IDn=${data['IDn']}"); //last_update='${data['last_update']}',
  // }

  DateTime _reformateDate(String date) {
    DateTime newDate = intl.DateFormat('yyyy-MM-dd HH:mm:ss').parse(date);
    return newDate;
  }
  // _getUpdatableData() async {
  //   Map<dynamic, Map> firestoreData = await fb.getDataWithID('users');
  //   Map<dynamic, Map> myData = {};
  //   var keys = firestoreData.keys;
  //   var values = firestoreData.values;
  //   firestoreData.forEach((key, value) async {
  //     Map _tempValue = value;
  //     _tempValue.forEach((_key, _value) {
  //       var temp = {
  //         key: {_key: _value}
  //       }.entries;
  //       if (_key == "points")
  //         myData.addEntries(temp);
  //       else if (_key == "score")
  //         myData.addEntries(temp);
  //       else if (_key == "attendance")
  //         myData.addEntries(temp);
  //       else if (_key == "commitment") myData.addEntries(temp);
  //       });});}
  //     myData.addEntries({key: value}.entries);
  //   });
  //   return myData;
  // }
//   syncStudentData(DateTime cloudDate, DateTime localDate, cloudStudent,
//       Map<Object, Object> localStudent) {
//     print("sync student data method");
//     print("$cloudDate    $localDate     ${cloudDate.compareTo(localDate)}");
//     if (cloudDate.compareTo(localDate) >= 1) {
//       print("local data is old");
//       // local data is old
//       updateLocalDatabase(cloudStudent);
//       // syncRecords();
//     } else if (cloudDate.compareTo(localDate) <= -1) {
//       print("firestore data is old");
//       // firestore data is old
//       // syncRecords();
//       myFierstor.setStudentData(
//           mEmail: memorizerEmail,
//           data: localStudent,
//           idn: cloudStudent['IDn'].toString());
//     }
//   }
//   syncRecords(QuerySnapshot cloudStudents) async {
//     try {
//       print(" sync records method  ****************************** ");
//       var _cloudStudents = cloudStudents.docs;
//       for (int i = 0; i < _cloudStudents.length; i++) {
//         var stdDoc = _cloudStudents[i];
//         print("foreach cloud students  ****************************** ");
//         Map cloudStudent = await stdDoc.data() as Map;
//         MapStyle().printMap(cloudStudent);
//         DateTime cloudeLastUpdate =
//             _reformateDate(stdDoc['last_update'].toString());
//         List<Map> tempLastUpdate = await db.readData(
//             "select * from Students where IDn=${cloudStudent['IDn']}");
//         MapStyle().printMap(tempLastUpdate.single);
//         DateTime localLastUpdate =
//             _reformateDate(tempLastUpdate[0]['last_update'].toString());
//         print(
//             '$cloudeLastUpdate     $localLastUpdate   ****************************** ');
//         if (cloudeLastUpdate.compareTo(localLastUpdate) >= 1) {
//           print("local data is old  ****************************** ");
//           if (myFierstor.doseStdHasRecords(
//               memorizerEmail, cloudStudent['IDn'])) {
//             print(
//                 "if student ${cloudStudent['IDn']} has records  ****************************** ");
//             var cloudeRecords = List<QueryDocumentSnapshot>.from(
//                 await myFierstor.getStudentRecords(
//                     mEmail: memorizerEmail,
//                     idn: cloudStudent['IDn'].toString()));
//             // cloudeRecords.forEach((rd) async
//             for (int j = 0; j < cloudeRecords.length; j++) {
//               var rd = cloudeRecords[j];
//               Map record = rd.data() as Map;
//               if (record['isSynced'] == "false") {
//                 MapStyle().printMap(record);
//                 print(
//                     "if record is synced false  ${rd.id}  ****************************** ");
//                 await db.insertData(
//                     "INSERT INTO 'Records' (id,std_id, surah, date, frm, t, quality, pgs_count, commitment, type,isSynced) VALUES ('${rd.id}' , '${cloudStudent['IDn'].toString()}','${record['surah']}','${record['date']}',${record['from']},${record['to']},${record['quality']},${record['pgsCount']},${record['commitment']},'${{
//                   record['type']
//                 }}','true')");
//                 List<Map> oldStudentData = await db.readData(
//                     " Select score,commitment, points, attendance, last_update From 'Students' WHERE IDn=${cloudStudent['IDn']}");
//                 var _score = record['pgsCount'] * record['quality'];
//                 double _factor = (record['type'] == "مراجعة") ? 0.5 : 1;
//                 var _points = (_score * _factor);
//                 DateTime now = DateTime.now();
//                 DateTime date = _reformateDate(now.toString());
//                 // intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//                 await db.updateData(
//                     "UPDATE 'Students'  SET commitment= ${record['commitment'] + oldStudentData[0]['commitment']}, points=${_points + oldStudentData[0]['points']} , attendance='${oldStudentData[0]['attendance'] + 1}' , last_update='${date.toString()}' WHERE IDn=${cloudStudent['IDn']}");
//                 MapStyle().printMap(cloudStudent);
//                 print(rd.id.toString() + " ****************************** ");
//                 await myFierstor.setRecordSynced(
//                     idn: cloudStudent['IDn'].toString(),
//                     mEmail: memorizerEmail,
//                     recordID: rd.id);
//               }
//             }
//           }
//         } else if (cloudeLastUpdate.compareTo(localLastUpdate) <= -1) {
//           print("cloud data is old  ****************************** ");
//           var localRecords = await db.readData(
//               "select * from Records where std_id=${cloudStudent['IDn']}");
//           // localRecords.forEach((record) async {
//           for (int j = 0; j < localRecords.length; j++) {
//             var record = localRecords[j];
//             MapStyle().printMap(record);
//             if (record['isSynced'] == "false") {
//               print(
//                   "if record is synced false  ${record['id']}  ****************************** ");
//               // await db.updateData(
//               //     "UPDATE Records Set isSynced='true' where id=${record['id']}");
//               MapStyle().printMap(record);
//               await myFierstor.addRecord(
//                   idn: record['std_id'],
//                   data: record as Map<String, dynamic>,
//                   mEmail: memorizerEmail);
//             }
//           }
//         }
//         // var cloudeRecords;
//         // try {} catch (e) {
//         //   print(" =============== Exception 3232323233 =============== ");
//         //   print(e);
//         // }
//         // else if (cloudeRecords.length > localRecords.length) {
//         //   _cloudStudents.forEach((student) async {
//         //     // print( student['IDn'].toString());
//         //     cloudeRecords.forEach((rd) async {
//         //       Map record = rd.data() as Map;
//         //       print(record.keys);
//         //       if (record['isSynced'] == "false") {
//         //         await db.insertData(
//         //             "INSERT INTO 'Records' (std_id, surah, date, frm, t, quality, pgs_count, commitment, type,isSynced) VALUES ('${student['IDn'].toString()}','${record['surah']}','${record['date']}',${record['from']},${record['to']},${record['quality']},${record['pgsCount']},${record['commitment']},'${{
//         //           record['type']
//         //         }}','true')");
//         //         print('${record['std_id']}     ${student['IDn']}');
//         //         DateTime now = DateTime.now();
//         //         String date = intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//         //         List<Map> oldStudentData = await db.readData(
//         //             " Select score,commitment, points, attendance, last_update From 'Students' WHERE IDn=${student['IDn']}");
//         //         print(
//         //             'type: ${record['type'].runtimeType}   quality: ${record['quality'].runtimeType}   pgsCount: ${record['pgsCount'].runtimeType}');
//         //         var _score = record['pgsCount'] * record['quality'];
//         //         double _factor = (record['type'] == "مراجعة") ? 0.5 : 1;
//         //         var _points = (_score * _factor);
//         //         await db.updateData(
//         //             "UPDATE 'Students'  SET commitment= ${record['commitment'] + oldStudentData[0]['commitment']}, points=${_points + oldStudentData[0]['points']} , attendance='${oldStudentData[0]['attendance'] + 1}' , last_update='$date' WHERE IDn=${student['IDn']}");
//         //       }
//         //       var cloudRecord = await myFierstor.setRecordSynced(
//         //           idn: student['IDn'].toString(), mEmail: memorizerEmail);
//         //       cloudeRecords;
//         //     });
//         //   });
//         // }
//       }
//       return true;
//     } catch (e) {
//       print('======================= Excaption5 ========================');
//       // QuickAlert.show(
//       //     context: context,
//       //     type: QuickAlertType.error,
//       //     text: e.toString(),
//       //     title: "حدث خلل غير متوقع, قم بإرسال لقطة شاشة للدعم الفني");
//       return false;
//     }
//   }
//   syncData(mEmail) async {
//     try {
//       print("sync data method");
//       CollectionReference _firestoreData =
//           await myFierstor.getStudentsCollection(mEmail: mEmail);
//       QuerySnapshot students = await _firestoreData.get();
//       List<Map> _db = await db.readData("select * from Students") as List<Map>;
//       var cloudDate, localDate;
//       Map<Object, Object> localStudent = {};
//       var cloudStudent;
//       if (students.docs.length == _db.length) {
//         print("if have same number of std");
//         for (int i = 0; i < students.docs.length; i++) {
//           print("for all students in cloud");
//           cloudStudent = students.docs[i].data() as Map;
//           // Map temp = await _db
//           //     .where((element) =>
//           //         element['IDn'].toString() == cloudStudent['IDn'].toString())
//           //     .single;
//           List<Map> _temp = await db.readData(
//               'select * from Students where IDn=${cloudStudent['IDn']}');
//           Map temp = _temp.single;
//           temp.forEach((key, value) {
//             Object _key = key as Object;
//             Object _value = value as Object;
//             localStudent.addEntries({_key: _value}.entries);
//           });
//           DateTime cloudDate =
//               _reformateDate(cloudStudent['last_update'].toString());
//           DateTime localDate =
//               _reformateDate(localStudent['last_update'].toString());
//           if ((localStudent != null && cloudStudent != null) &&
//               (!localStudent.isEmpty && !cloudStudent.isEmpty)) {
//             print("if local and cloud not empty");
//             syncStudentData(cloudDate, localDate, cloudStudent, localStudent);
//             // if (cloudDate.compareTo(localDate) >= 1) {
//             //   // local data is old
//             //   print("Firestore is newest");
//             //   updateLocalDatabase(cloudStudent);
//             // } else if (cloudDate.compareTo(localDate) <= -1) {
//             //   // firestore data is old
//             //   print("Local Data is newest");
//             //   myFierstor.setStudentData(
//             //       email: memorizerEmail,
//             //       data: localStudent,
//             //       id: localStudent['IDn'].toString());
//             // } else if (cloudDate.compareTo(localDate) == 0) {
//             //   print("same data");
//             // }
//           } else if ((!cloudStudent.isEmpty && localStudent.isEmpty) ||
//               (cloudStudent != null && localStudent == null)) {
//             print("if local empty : do no thing in this case");
//             // updateLocalDatabase(cloudStudent);
//           } else if ((cloudStudent.isEmpty && !localStudent.isEmpty) ||
//               (cloudStudent == null && localStudent != null)) {
//             print("if cloud empty : do no thing in this case");
//             // myFierstor.setStudentData(
//             //     email: memorizerEmail,
//             //     data: localStudent as Map<Object, Object>,
//             //     id: localStudent['IDn'].toString());
//           }
//           // } catch (e) {
//           //   print(
//           //       '======================= Excaption2 ========================');
//           //   // QuickAlert.show(
//           //   //     context: context,
//           //   //     type: QuickAlertType.error,
//           //   //     text: e.toString(),
//           //   //     title: "حدث خلل غير متوقع, قم بإرسال لقطة شاشة للدعم الفني");
//           // }
//         }
//       } else if (students.docs.length < _db.length) {
//         print(
//             "if local have more students than cloud,\n set all local student into new student lest");
//         List<Map> newstudents = List.from(_db);
//         if (students.docs.length != 0) {
//           print("and cloud not 0 length (has students collection)");
//           for (int i = 0; i < _db.length; i++) {
//             print("for all local students");
//             for (int j = 0; j < students.docs.length; j++) {
//               print("for all cloud students");
//               if (_db[i]['IDn'].toString() ==
//                   students.docs[j]['IDn'].toString()) {
//                 print(
//                     "if local student id is in cloud (student id), remove student from new list");
//                 newstudents
//                     .removeWhere((element) => element['IDn'] == _db[i]['IDn']);
//                 break;
//               }
//               // if (!temp.isEmpty) {
//               //   print( " ================================== ");
//               //   // await myFierstor.addStudent(
//               //   //     data: temp as Map<String, dynamic>, email: memorizerEmail);
//               //   print(temp['school']);
//               //   temp.clear();
//               // }
//               // temp.clear();
//             }
//           }
//         }
//         newstudents.forEach((std) async {
//           print(
//               "foreach student in new list(student dose not saved in cloud) add student to cloud...");
//           await myFierstor.addStudent(
//               data: std as Map<String, dynamic>, mEmail: memorizerEmail);
//         });
//       } else if (students.docs.length > _db.length) {
//         print(
//             "if cloud have more students than local,\n set all cloud student into new student lest");
//         ;
//         List newstudents = List.from(students.docs.toList());
//         if (students.docs.length != 0) {
//           print("if cloud not Empty (hase student collection)");
//           for (int i = 0; i < students.docs.length; i++) {
//             print("for all std in cloud");
//             for (int j = 0; j < _db.length; j++) {
//               print("for all std in local");
//               if (_db[j]['IDn'].toString() ==
//                   students.docs[i]['IDn'].toString()) {
//                 print("if std exict in both, remove from new list");
//                 newstudents.removeWhere(
//                     (element) => element['IDn'] == students.docs[i]['IDn']);
//                 break;
//               }
//             }
//           }
//         }
//         for (int s = 0; s < newstudents.length; s++) {
//           print("for all new std list\n insert to local");
//           var std = newstudents[s];
//           int response = await db.insertData(
//               "INSERT INTO 'Students' (f_name, m_name ,l_name, IDn, DOB ,phone, school, level, score, attendance, commitment, points, lastTest ,lastTestDegree ,last_update) VALUES ('${std['f_name']}', '${std['m_name']}', '${std['l_name']}' , '${std['IDn']}' ,'${std['DOB']}','${std['phone']}', '${std['school']}', '${std['level']}', '${std['score']}','${std['attendance']}','${std['commitment']}','${std['points']}','${std['lastTest']}' , '${std['lastTestDegree']}' , '${std['last_update']}')");
//           if (response == 0) break;
//         }
//       }
//       // List<Map<String, dynamic>> localData = await db.readData(
//       //     "SELECT score ,attendance ,commitment ,points FROM Students");
//       /*
// score attendance commitment points previous_points last_update
//           */
//       // print(firestoreData);
//       // print("\n");
//       // print(localData);
//       // if ((_db != null && students.docs != null) &&
//       //     (!_db.isEmpty && !students.docs.isEmpty)) {
//       //   print(" ============= not null ===========");
//       //   for (int i = 0; i < students.docs.length; i++) {
//       //     var fd = _reformateDate(students.docs[i].data()
//       //         .elementAt(i)['last_update']
//       //         .toString()
//       //         .split("T")[0]); //"2012-02-27 13:27:00"
//       //     var ld = _reformateDate(
//       //         _db[i]['last_update'].toString().split("T")[0]);
//       //     print(fd.compareTo(ld));
//       //     if (fd.compareTo(ld) == 1) {
//       //       // local data is old
//       //       print("Firestore is newest");
//       //       updateLocalDatabase(
//       //           students.docs.values.elementAt(i)['id'].toString(),
//       //           students.docs.values.elementAt(i));
//       //     } else if (ld.compareTo(fd) == 1) {
//       //       // firestore data is old
//       //       print("Local Data is newest");
//       //       fb.updateDocument(_db[i]['id'].toString(), _db[i]);
//       //     } else if (ld.compareTo(fd) == 0) {
//       //       print("same data");
//       //     }
//       //   }
//       //   print('done');
//       // }
//       //  else if (localData == null || localData.isEmpty) {
//       //   Map<dynamic, Map> firestoreRecordData =
//       //       await getFirestoreDataAsListWithID('record');
//       //   Map<dynamic, Map> firestoreAtteData =
//       //       await getFirestoreDataAsListWithID('attendance');
//       //   // _updateLocalDataBasedOnFirebase(
//       //   //     firestoreData.values.toList(),
//       //   //     firestoreRecordData.values.toList(),
//       //   //     firestoreAtteData.values.toList());
//       // }
//       // else if (localData.length > firestoreData.length) {
//       //   print("Local Data is Bigger");
//       //   _uploadeDataToFirestore(localData); // update local data
//       // }
//       return true;
//     } on Exception catch (e) {
//       print('======================= Excaption4 ========================');
//       print(e);
//       // Navigator.pop(context);
//       // QuickAlert.show(
//       //     context: context,
//       //     type: QuickAlertType.error,
//       //     text: e.toString(),
//       //     title: "حدث خلل غير متوقع, قم بإرسال لقطة شاشة للدعم الفني");
//       return false;
//     }
//   }

  Future _uploadeStdDataToFirestore(List<Map<String, dynamic>> data) async {
    print('data in uploud');
    for (int i = 0; i < data.length; i++) {
      data[i].addEntries({'m-email': memorizerEmail}.entries);
      await myFierstor.addStudent(data: data[i], mEmail: memorizerEmail);
    }
  }

  _uploadeRecordaDataToFirestore(List<Map<String, dynamic>> data) async {
    print('Record');
    print(data);
    for (int i = 0; i < data.length; i++) {
      data[i].addEntries({'m-email': memorizerEmail}.entries);
      await myFierstor.addOldRecord(
          data: data[i], mEmail: memorizerEmail, idn: data[i]['IDn']);
    }
  }

  onSelected(BuildContext context, MyMenuItem item) async {
    // if (item == MenuItems.itemSync) {
    //   // try {
    //   // QuickAlert.show(
    //   //     context: context,
    //   // type: QuickAlertType.loading,
    //   //     text: "...جاري المزامنة",
    //   //     title: "الرجاء الانتظار قليلا");
    //   // FilePicker.platform.clearTemporaryFiles();
    //   // // bool sync1 = await syncData(memorizerEmail);
    //   // ////////////////////////////////////
    //   // var stdCollection =
    //   //     await myFierstor.getStudentsCollection(mEmail: memorizerEmail);
    //   // QuerySnapshot cloudStudents = await stdCollection.get();
    //   // // bool sync2 = await syncRecords(cloudStudents);
    //   // //////////////////////////////////////
    //   // cloudStudents.docs.forEach((studet) {
    //   //   var std = studet.data() as Map;
    //   //   myFierstor.setStudentLastUpdate(
    //   //       mEmail: memorizerEmail, idn: std['IDn'].toString());
    //   // });
    //   // String now = _reformateDate(DateTime.now().toString()).toString();
    //   // db.setAllStdUpdated(now);
    //   // if (sync1 == true && sync2 == true) {
    //   //   Navigator.pop(context);
    //   //   await QuickAlert.show(
    //   //       context: context,
    //   //       type: QuickAlertType.success,
    //   //       title: "تمت عملية المزامنة بنجاح");
    //   // } else {
    //   //   Navigator.pop(context);
    //   //   await QuickAlert.show(
    //   //       context: context,
    //   //       type: QuickAlertType.error,
    //   //       title: "عذراً، حدثت مشكلة غير متوقعة");
    //   // }

    //   // } catch (e) {
    //   //   print('======================= Excaption1 ========================');

    //   //   Navigator.pop(context);
    //   //   QuickAlert.show(
    //   //       context: context,
    //   //       type: QuickAlertType.error,
    //   //       text: e.toString(),
    //   //       title: "حدث خلل غير متوقع, قم بإرسال لقطة شاشة للدعم الفني");
    //   // }
    // } else

    if (item == MenuItems.itemImport) {
      FilePicker.platform.clearTemporaryFiles();
      final result = await FilePicker.platform.pickFiles();
      if (result == null) return;
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        title: "جاري الاستيراد...",
      );
      final file = result.files.first;
      List<List<Map<String, dynamic>>> data =
          await _exportFromExcelAsListOfMaps(file.path);
      print(data);
      await _uploadeStdDataToFirestore(await data[0]).then((value) {
        _uploadeRecordaDataToFirestore(data[1]);
      });
      Navigator.pop(context);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: "تم استيراد بنجاح",
      );
      // await ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text("تم ادراج البيانات بنجاح")));

      // _importDateToLocalDB(await data);
      // _get1(data);
    } else if (item == MenuItems.itemExport) {
      var stemp =
          await myFierstor.getStudentsCollection(mEmail: memorizerEmail);
      var std = await stemp.get();
      print(std.docs.first.data());
      exportToExcel(std.docs);
    }
    // else if (item == MenuItems.itemDeletAll)
    //   db.deleteDatabaseFromDvice();
    // else if (item == MenuItems.itemDeletData) {
    //   db.deleteData("DELETE FROM Students");
    //   db.deleteData("DELETE FROM Records");
    //   db.deleteData("DELETE FROM Attendance");
    // } else if (item == MenuItems.itemUplode) {
    //   // List<Map<String, dynamic>> l =
    //   //     await _getStudentDate() as List<Map<String, dynamic>>;
    //   // fb.upload(l);
    // }
    // else if (item == MenuItems.itemWhatsapp) {
    //   QuickAlert.show(
    //       context: context,
    //       type: QuickAlertType.loading,
    //       title: "جاري تجهيز الرسالة");
    //   WhatsappMassage()
    //       .getRecordsToMessage(memorizerEmail)
    //       .then((value) => Navigator.pop(context));
    //   // var url = "whatsapp://send?&text=hello";
    //   // await launch(url);
    // }
    else if (item == MenuItems.itemLogout) {
      logout();
    }
    // else if (item == MenuItems.itemContactUs) {
    //   // BugReportOverlay(mEmail: memorizerEmail);
    //   Navigator.of(context).push(MaterialPageRoute(
    //       builder: (context) => ContactUs(userEmail: memorizerEmail)));
    // }
  }

  logout() async {
    FirebaseAuth.instance.signOut();
    // await db.insertData(
    //     "UPDATE 'Login' SET username= null ,password=null,remember= false ");
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Login();
    }), (route) => false);
  }

  Future<Void> _refresh() async {
    return await Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (a, b, c) => Home(),
            transitionDuration: Duration(seconds: 0)));
  }

  // bool value = false;

  Future<List<Map<String, dynamic>>> _getStudentsFDate() async {
    List<Map<String, dynamic>>? result;
    try {
      var n = await InternetAddress.lookup('google.com');
      if (!n.isEmpty || n != null) {
        print("enable network");
        myFierstor.ref.enableNetwork();
      }
    } catch (exception) {
      myFierstor.ref.disableNetwork();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("لا يوجد إتصال بالانترنت")));
      // QuickAlert.show(
      //     context: context,
      //     type: QuickAlertType.error,
      //     title: "لا يوجد انتصال بالانترنت",
      //     text:"سيتم عرض البيانات المحفوظة على الجهاز إن وجدت\n  حاول الاتصال بالانترنت للحصول على احدث البيانات",
      //     );
    } finally {
      var std = await myFierstor.getNotDeletedStudentsCollection(
          mEmail: memorizerEmail);
      result = std.map((e) => e.data() as Map<String, dynamic>).toList();
    }
    return result as List<Map<String, dynamic>>;
  }

  var memorizerEmail;
  Widget build(BuildContext context) {
    memorizerEmail = FirebaseAuth.instance.currentUser!.email.toString();
    return Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(
                onSelected: (item) => onSelected(context, item),
                itemBuilder: (context) =>
                    [...MenuItems.items.map(buildItem).toList()]),
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("الرئيسية"),
              IconButton(
                icon: Icon(Icons.message),
                onPressed: () {
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.loading,
                      title: "جاري تجهيز الرسالة");
                  WhatsappMassage()
                      .getRecordsToMessage(memorizerEmail)
                      .then((value) => Navigator.pop(context));
                },
              )
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    pageBuilder: (a, b, c) => Home(),
                    transitionDuration: Duration(seconds: 0)));
          },
          child: FutureBuilder(
              future: _getStudentsFDate(),
              builder: ((context, AsyncSnapshot snapshot) {
                if (snapshot.hasData && snapshot.data!.length > 0) {
                  List<Map> data = snapshot.data;
                  data.sort((a, b) => double.parse(a['points'])
                      .compareTo(double.parse(b['points'])));
                  data = data.reversed.toList();
                  // var data = sortList(snapshot.data!);
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        var stdData = data.elementAt(index);
                        // getFirestoreDataAsListWithID(
                        //     stdData, snapshot.data!.elementAt(index).id);
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => StudentProfile(
                                      studentIDn: stdData['IDn'],
                                      memorizerEmail: memorizerEmail,
                                    )));
                          },
                          child: Card(
                            margin: EdgeInsets.all(6),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    Container(
                                      width: 35,
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        children: [
                                          Text(stdData['f_name'].toString() +
                                              " " +
                                              stdData['l_name'].toString()),
                                          // Text((stdData['points'] +
                                          //         stdData['attendance'])
                                          //     .toString())
                                          Text((stdData['points']).toString())
                                        ],
                                      ),
                                    )
                                  ]),
                                  CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        print("object");
                                        print(await stdData['IDn']);
                                        Navigator.push(
                                            context,
                                            await MaterialPageRoute(
                                                builder: (context) => NewRecord(
                                                      stdID: stdData['IDn'],
                                                      memorizerEmail:
                                                          memorizerEmail,
                                                      stdName:
                                                          """${stdData['f_name']} ${stdData['l_name']}""",
                                                    )));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  // try {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(content: Text("لا يوجد بيانات لعرضها ")));
                  // } catch (e) {
                  //   print(e);
                  // }
                  return Center(child: CircularProgressIndicator());
                }
              })),
        ),
        bottomNavigationBar: BottomBar(
          dailyReplace: false,
          dailyPush: true,
          home: false,
          addStudent: true,
          memorizerEmail: memorizerEmail,
        ));
  }
}
