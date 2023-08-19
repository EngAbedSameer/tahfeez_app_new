import 'package:tahfeez_app/AddStudent.dart';
import 'package:tahfeez_app/moodle/Firestore.dart';
// import 'package:tahfeez_app/sqfDB.dart';

class Student {
  String?
      _fname,
      _mname,
      _lname,
      _idn,
      _dob,
      _phone,
      _school,
      _level,
      _attendance,
      _points,
      _lastTest,
      _lastTestDegree,
      _last_update,
      _memorizerEmail,
      _isDeleted;
  // SqlDb db = SqlDb();
  Firestore myFierstor = Firestore();

  Student(
      {required memorizerEmail,
      required fname,
      required mname,
      required lname,
      required idn,
      required dob,
      required phone,
      required school,
      required level,
      // required score,
      // required commitment,
      required attendance,
      required points,
      required lastTest,
      required lastTestDegree,
      required last_update,
      required isDeleted}) {
    _fname = fname;
    _mname = mname;
    _lname = lname;
    _idn = idn;
    _dob = dob;
    _phone = phone;
    _school = school;
    _level = level;
    // _score = score;
    _attendance = attendance;
    // _commitment = commitment;
    _points = points;
    _lastTest = lastTest;
    _lastTestDegree = lastTestDegree;
    _last_update = last_update;
    _memorizerEmail = memorizerEmail;
    _isDeleted=isDeleted;
  }

  // Future<List<Map>> _getStudentsDate() async {
  //   List<Map> result = await db.readData("SELECT * FROM Students");
  //   return result;
  // }

  addStudent() async {
    _isDeleted="false";
    // addStudentToLocalDB();
    addStudentToFierstore();
  }
  // addStudentToLocalDB() async {
  //   await db.insertData(
  //       "INSERT INTO 'Students' (f_name,  m_name ,l_name, IDn, DOB ,phone, school, level, score, attendance, commitment, points, lastTest ,lastTestDegree ,last_update) VALUES ('$_fname', '$_mname', '$_lname' , '$_idn' ,'$_dob','$_phone', '$_school','$_level', '$_score','$_attendance','$_commitment','$_points ','$_lastTest' , '$_lastTestDegree' , '$_last_update')");
  // }

  addStudentToFierstore() async {
    myFierstor.addStudent(data: stdData, mEmail: _memorizerEmail);
  }

  updateStudent() async {
    // updateStudentInLocalDB();
    updateStudentInFierstore();
  }
  // updateStudentInLocalDB() async {
  //   await db.updateData(
  //       "UPDATE 'Students'  SET f_name='$_fname', m_name='$_mname' , l_name='$_lname', DOB='$_dob', phone='$_phone', school='$_school', level='$_level',score= '$_score' ,attendance='$_attendance',commitment= '$_commitment', points='$_points', last_update='$_last_update',lastTestDegree='$_lastTestDegree' , lastTest='$_lastTest' WHERE IDn=${_idn}");
  // }

  updateStudentInFierstore() async {
    myFierstor.setStudentData(
        idn: _idn, mEmail: _memorizerEmail, data: stdData);
  }
  Map<String, String> get stdData => {
        "f_name": _fname!,
        "m_name": _mname!,
        "l_name": _lname!,
        "IDn": _idn!,
        "DOB": _dob!,
        "phone": _phone!,
        "school": _school!,
        "level": _level!,
        "m-email":_memorizerEmail!,
        "attendance": _attendance!,
        "points": _points!,
        "lastTest": _lastTest!,
        "lastTestDegree": _lastTestDegree!,
        "last_update": _last_update!,
        'isDeleted':_isDeleted!
      };

  // get id => _id;
  // set id(value) {
  //   _id = value;
  // }
  get f_name => f_name;
  // get last_update => _last_update;
  // set last_update(value) {
  //   _last_update = value;
  // }
  // get lastTestDate => _lastTestDate;
  // set lastTestDate(value) {
  //   _lastTestDate = value;
  // }
  // get lastTest => _lastTest;
  // set lastTest(value) {
  //   _lastTest = value;
  // }
  // get points => _points;
  // set points(value) {
  //   _points = value;
  // }
  // get commitment => _commitment;
  // set commitment(value) {
  //   _commitment = value;
  // }
  // get attendance => _attendance;
  // set attendance(value) {
  //   _attendance = value;
  // }
  // get score => _score;
  // set score(value) {
  //   _score = value;
  // }
  // get level => _level;
  // set level(value) {
  //   _level = value;
  // }
  // get school => _school;
  // set school(value) {
  //   _school = value;
  // }
  // get phone => _phone;
  // set phone(value) {
  //   _phone = value;
  // }
  // get dob => _dob;
  // set dob(value) {
  //   _dob = value;
  // }
  // get idn => _idn;
  // set idn(value) {
  //   _idn = value;
  // }
  // get l_name => _l_name;
  // set l_name(value) {
  //   _l_name = value;
  // }
  // get m_name => _m_name;
  // set m_name(value) {
  //   _m_name = value;
  // }
  // set f_name(value) {
  //   _f_name = value;
  // }
}
