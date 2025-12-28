import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tahfeez_app/Widgets/BottomBar.dart';
import 'package:tahfeez_app/model/Firestore.dart';
import 'package:tahfeez_app/model/Student.dart';
// import 'sqfDB.dart';
import 'package:intl/intl.dart' as intl;

class AddStudent extends StatefulWidget {
  final memorizerEmail;
  const AddStudent({
    super.key,
    required this.memorizerEmail,
  });
  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    ScreenUtil.ensureScreenSize();
    super.initState();
  }

  Firestore myFierstor = Firestore();
  late Student std;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fnameController = TextEditingController(),
      _mnameController = TextEditingController(),
      _lnameController = TextEditingController(),
      _phoneController = TextEditingController(),
      _dobController = TextEditingController(),
      _idController = TextEditingController(),
      _schoolController = TextEditingController(),
      _levelController = TextEditingController(),
      _lastTestController = TextEditingController(),
      _lastTestDegreeController = TextEditingController();
  // SqlDb db = SqlDb();
  late TextStyle cardTextStyle =
      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, height: 2.5);
  late TextStyle cardMainTextStyle = TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      height: 2.5,
      color: Colors.green);

  // Future<List<Map>> _getStudentDate() async {
  //   List<Map> result = await db.readData("SELECT * FROM students WHERE id=");
  //   return result;
  // }

  _addStudent(mEmail, fname, mname, lname, phone, dob, idn, school, level,
      lastTest, lastTestDegree) async {
    try {
      DateTime now = DateTime.now();
      String date = intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      std =  Student(
          memorizerEmail: widget.memorizerEmail,
          fname: fname,
          mname: mname,
          lname: lname,
          idn: idn,
          dob: dob,
          phone: phone,
          school: school,
          level: level,
          // score: "0",
          attendance: "0",
          // commitment: "0",
          points: "0",
          lastTest: lastTest,
          lastTestDegree: lastTestDegree,
          last_update: date,
          isDeleted:"false");
      std.addStudent();
      // String date =
      //     '${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}';
      // await db.insertData(
      //     "INSERT INTO 'Students' (f_name, m_name ,l_name, IDn, DOB ,phone, school, level, score, attendance, commitment, points, lastTest ,lastTestDegree ,last_update) VALUES ('$fname', '$mname', '$lname' , '$idn' ,'$dob','$phone', '$school', '$level', '0','0','0','0','$lastTest' , '$lastTestDegree' , '$date')");
      // myFierstor.addStudent(data: {
      //   "phone": phone.toString(),
      //   "f-name": fname.toString(),
      //   "m-name": mname.toString(),
      //   "l-name": lname.toString(),
      //   "DOB": dob.toString(),
      //   "IDn": idn.toString(),
      //   "school": school.toString(),
      //   "level": level.toString(),
      //   "Last-test": lastTest.toString(),
      //   "Last-test-degree": lastTestDegree.toString(),
      //   "last-update": date.toString()
      // }, mEmail: widget.memorizerEmail.toString());
    } catch (e) {
      print(e);
    }
  }

  // Future<List<Map>> _getStudentHistory(id) async {
  //   List<Map> result =
  //       await db.readData("SELECT * FROM Records WHERE std_id='id' ");
  //   // print(result[0]["date"].split(" ")[0]);
  //   // print(" ******************** ");
  //   // print(DateTime.now().toString().split(" ")[0]);
  //   return result;
  // }

  // Future<List<Map>> _getStudentTests() async {
  //   List<Map> result = await db
  //       .readData("SELECT * FROM tests WHERE id=${widget.studentSysID}");
  //   return result;
  // }
  _dateValidator(date) {
    bool result =true;
    List<String> dateValid = date.toString().split("-");
    if (dateValid.length==3) {
      if (dateValid[0].length == 2)  result=false;
      if (dateValid[1].length == 2)  result=false;
      if (dateValid[2].length == 4)  result=false;
    }else{
       result=false;
    }
    return result;
    // print(dateValid);
    // print("*********************");
  }

  @override
  Widget build(BuildContext context) {
    var vw = MediaQuery.of(context).size.width;
    var vh = MediaQuery.of(context).size.height;
    var _space = vh * 0.02;
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("ملف الطالب", textAlign: TextAlign.center),
      ),
      body: Stack(children: [
        Image.asset(
          "assets/images/background.jpg",
          fit: BoxFit.cover,
          width: vw,
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Image.asset("assets/icon/logo.png",width: 100),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.length == 0)
                              return "يجب ملئ هذا الحقل ";
                            else
                              return null;
                          },
                          autofocus: true,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              label: Text(" الاسم الأول"),
                              labelStyle: TextStyle(fontSize: 14)),
                          controller: _fnameController,
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      SizedBox(
                        height: _space,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.length == 0)
                              return "يجب ملئ هذا الحقل ";
                            else
                              return null;
                          },
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              label: Text(" الاسم الثاني"),
                              labelStyle: TextStyle(fontSize: 14)),
                          controller: _mnameController,
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      SizedBox(
                        height: _space,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.length == 0)
                              return "يجب ملئ هذا الحقل ";
                            else
                              return null;
                          },
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              label: Text(" الاسم الأخير"),
                              labelStyle: TextStyle(fontSize: 14)),
                          controller: _lnameController,
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      SizedBox(
                        height: _space,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.length == 0)
                              return "يجب ملئ هذا الحقل ";
                            else if (value.length != 13)
                              return "رقم الجوال غير صحيح";
                            else
                              return null;
                          },
                          decoration: InputDecoration(
                              hintText: "يجب كتابته مع مقدمة الدولة(+970)",
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              label: Text("رقم الجوال"),
                              labelStyle: TextStyle(fontSize: 14)),
                          controller: _phoneController,
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      SizedBox(
                        height: _space,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: vw * 0.4,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (_dateValidator(value)) {
                                    return "يجب ملئ هذا الحقل او تعديل صيغة التاريخ";
                                  } else
                                    return null;
                                },
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                    errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    label: Text("تاريخ الميلاد"),
                                    labelStyle: TextStyle(fontSize: 14),
                                    hintText: "15-06-2020"),
                                controller: _dobController,
                                style: TextStyle(
                                  fontSize: 16,
                                )),
                          ),
                          SizedBox(
                            height: _space,
                          ),
                          SizedBox(
                            width: vw * 0.4,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                                validator: (value) {
                                  // print(value!.length);
                                  if (value == null || value.length == 0)
                                    return "يجب ملئ هذا الحقل ";
                                  else if (value.length != 9)
                                    return "رقم الهوية غير صحيح";
                                  else
                                    return null;
                                },
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                    errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    label: Text("رقم الهوية"),
                                    labelStyle: TextStyle(fontSize: 14)),
                                controller: _idController,
                                style: TextStyle(
                                  fontSize: 16,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _space,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: vw * 0.4,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.length == 0)
                                    return "يجب ملئ هذا الحقل ";
                                  else
                                    return null;
                                },
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                    errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    label: Text("المدرسة"),
                                    labelStyle: TextStyle(fontSize: 14)),
                                controller: _schoolController,
                                style: TextStyle(
                                  fontSize: 16,
                                )),
                          ),
                          SizedBox(
                            height: _space,
                          ),
                          SizedBox(
                            width: vw * 0.4,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.length == 0)
                                    return "يجب ملئ هذا الحقل ";
                                  else
                                    return null;
                                },
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                    errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    label: Text("الصف"),
                                    labelStyle: TextStyle(fontSize: 14)),
                                controller: _levelController,
                                style: TextStyle(
                                  fontSize: 16,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _space,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: vw * 0.4,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.length == 0)
                                    return "يجب ملئ هذا الحقل ";
                                  else
                                    return null;
                                },
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                    errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                    label: Text("آخر اختبار معتمد"),
                                    labelStyle: TextStyle(fontSize: 14)),
                                controller: _lastTestController,
                                style: TextStyle(
                                  fontSize: 16,
                                )),
                          ),
                          SizedBox(
                            height: _space,
                          ),
                          SizedBox(
                            width: vw * 0.4,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.length == 0)
                                    return "يجب ملئ هذا الحقل ";
                                  else
                                    return null;
                                },
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                    errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                    label: Text("الدرجة"),
                                    labelStyle: TextStyle(fontSize: 14)),
                                controller: _lastTestDegreeController,
                                style: TextStyle(
                                  fontSize: 16,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _space,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // print(widget.memorizerEmail);
                          // print(" 0000000000000000000 ");
                          if (_formKey.currentState!.validate()) {
                            _addStudent(
                                widget.memorizerEmail,
                                _fnameController.text.toString(),
                                _mnameController.text.toString(),
                                _lnameController.text.toString(),
                                _phoneController.text.toString(),
                                _dobController.text.toString(),
                                _idController.text.toString(),
                                _schoolController.text.toString(),
                                _levelController.text.toString(),
                                _lastTestController.text.toString(),
                                _lastTestDegreeController.text.toString());

                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          }
                        },
                        child: Container(
                            child: Text("حفظ",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                            width: 200,
                            alignment: Alignment.center),
                      ),
                      SizedBox(
                        height: _space,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
      bottomNavigationBar: BottomBar(
        dailyReplace: true,
        dailyPush: true,
        home: true,
        addStudent: false,
        memorizerEmail: widget.memorizerEmail,
      ),
    );
  }
}