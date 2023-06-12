// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  intialDb() async {
    String databasepath = await getDatabasesPath();
    String path = p.join(databasepath, 'tahfeezApp.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 3, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) {
    print("================== Updated ===================");
  }

  _onCreate(Database db, int version) async {
    // await db.execute('''create table "Login" ("username" Text ,"password" Text , "remember" Bool Not Null Default 'false')''');

    await db.execute('''
  CREATE TABLE "Students" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "f_name" TEXT NOT NULL ,
    "m_name" TEXT NOT NULL ,
    "l_name" TEXT NOT NULL ,
    "IDn" INTEGER NOT NULL,
    "DOB" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "school" TEXT NOT NULL,
    "level" INTEGER NOT NULL,
    "score" INTEGER NOT NULL,
    "attendance" INTEGER NOT NULL,
    "commitment" INTEGER NOT NULL,
    "points" INTEGER NOT NULL,
    "lastTest" TEXT NOT NULL ,
    "lastTestDegree" DOUBLE NOT NULL,
    "last_update" Text Not Null
  )
 ''');
    await db.execute('''
  CREATE TABLE "Records" (
    "id" TEXT NOT NULL , 
    "std_id" INTEGER NOT NULL ,
    "surah" TEXT NOT NULL,
    "date" TEXT NOT NULL,
    "frm" INTEGER NOT NULL,
    "t" INTEGER NOT NULL,
    "quality" INTEGER NOT NULL,
    "pgs_count" INTEGER NOT NULL,
    "commitment" INTEGER NOT NULL,
    "type" TEXT NOT NULL,
    "isSynced" TEXT NOT NULL
  )
 ''');
    await db.execute('''
  CREATE TABLE "Attendance" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT, 
    "std_id" INTEGER NOT NULL ,
    "name" TEXT NOT NULL ,
    "date" TEXT NOT NULL
  )
 ''');
    print("================== Created ==================");
  }
  // "isAttended" BOOLEAN NOT NULL

  Future<List<Map>> readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    print("================== Readed ==================");
    return response;
  }

  Future<int> insertData(String sql) async {
    //  try{
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    print("================== Insert ==================");
    return response;

    // }catch(e){
    // print("================== Exception ==================");

    //   // print(e);
    //   throw Exception(e);

    // }
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    print("================== Update ==================");

    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    print("================== Deleted ==================");

    return response;
  }

  deleteDatabaseFromDvice() async {
    String databasePath = await getDatabasesPath();
    String path = p.join(databasePath, "tahfeezApp.db");
    await deleteDatabase(path);
    print("================== Deleted ==================");
  }

  printDatabaseTable(String sql) async {
    List<Map> data = await readData(sql);
    data.forEach((recordMap) {
      print("{");
      recordMap.entries.forEach((entrity) {
        print(" " + entrity.key.toString() + " : " + entrity.value.toString());
      });
      print("} \n\n");
    });
  }

  setAllStdUpdated(String now) async {
    //  var students= await readData('select * from Students');
    //  students.forEach((student) {
    updateData("UPDATE Students Set last_update='$now'");

    //  });
  }
}
