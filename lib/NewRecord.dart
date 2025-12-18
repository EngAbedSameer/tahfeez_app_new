// import 'package:intl/intl.dart' as intl;
// ignore_for_file: avoid_print, implementation_imports, prefer_typing_uninitialized_variables, sort_child_properties_last, file_names

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:searchfield/searchfield.dart';
import 'package:tahfeez_app/moodle/BottomBar.dart';
import 'package:tahfeez_app/moodle/Firestore.dart';
// import 'sqfDB.dart';

class NewRecord extends StatefulWidget {
  final String stdID;
  final String stdName;
  final String memorizerEmail;
  final studentPhone;

  const NewRecord(
      {super.key,
      required this.stdID,
      required this.memorizerEmail,
      this.studentPhone,
      required this.stdName});

  @override
  State<NewRecord> createState() => _NewRecordState();
}

class _NewRecordState extends State<NewRecord>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  // SqlDb db = SqlDb();
  Firestore myFierstor = Firestore();

  // late AnimationController _controller;
  late TextEditingController _frmController = TextEditingController(),
      _tController = TextEditingController(),
      _qualityController = TextEditingController(),
      _pgsCountController = TextEditingController(),
      _commitmentController = TextEditingController();
  // _dateController = TextEditingController(),

  var commitment, points;

  double factor = 1;
  String getRandomID(int length) {
    final random = Random();
    const availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(length,
            (index) => availableChars[random.nextInt(availableChars.length)])
        .join();

    return randomString;
  }

  Future save(String stdID, String email, String surah, String from, String to,
      double quality, double pgsCount, double commitment, double type) async {
    try {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
          title: "جاري حفظ البيانات");
      //     var n = await InternetAddress.lookup('google.com');
      // if (!n.isEmpty || n != null) {
      //   print("enable network");
      //   Firestore.ref.enableNetwork();
      // }
      // add record to local database
      // String localRecordID = await db.addRecord(
      //     stdID, surah, from, to, quality, pgsCount, commitment, type);
      // add record to cloud database
       await myFierstor
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

      Map stdOldData =
          await myFierstor.getStudentData(mEmail: email, idn: stdID.toString());
      var newPoints =
          double.parse(stdOldData['points']) + (pgsCount * quality) * type;
      var newAttendance = double.parse(stdOldData['attendance']) + 1;
      await myFierstor.setStudentData(
          mEmail: email,
          idn: stdID.toString(),
          data: {
            'points': newPoints.toString(),
            'attendance': newAttendance.toString()
          });
      // update record id field in local database
      // await db.updateRecordID(localRecordID, cloudRecordID);
      // update lastUpdate field in student cloud doc.
      await myFierstor
          .setStudentLastUpdate(mEmail: email, idn: stdID.toString())
          .then((value) => Navigator.pop(context));
    } catch (e) {
      print(e);
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: e.toString(),
          title: "حدث خلل غير متوقع, قم بإرسال لقطة شاشة للدعم الفني");
    }
  }

  Future<String> _getStdName() async {
    var std = await myFierstor.getStudentData(
        idn: widget.stdID.toString(), mEmail: widget.memorizerEmail);
    var name = await ("""${std['f_name']} ${std['l_name']}""");
    return name;
  }

  // Future<String> _getStdName() async {
  //   List<Map> stdData = await db.readData(
  //       "SELECT f_name , l_name  FROM students WHERE IDn='${widget.stdID}'");
  //   // commitment = stdData[0].values.toList()[3];
  //   // points = stdData[0].values.toList()[4];

  //   String name;
  //   name = stdData[0].values.toList()[0].toString() +
  //       " " +
  //       stdData[0].values.toList()[1].toString();

  //   return name;
  // }

  String dropDownTypeValue = "حفظ";
  List<DropdownMenuItem<String>> typeOfRecord = [
    DropdownMenuItem(
      child: Text(""),
      value: "new",
    ),
    DropdownMenuItem(
      child: Text(""),
      value: "old",
    )
  ];

  dropdownButton() {
    return DropdownButton<String>(
      value: dropDownTypeValue,
      items: <String>['حفظ', 'مراجعة']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 20),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          dropDownTypeValue = value!;
          if (value == "مراجعة") {
            factor = 0.5;
          } else {
            factor = 1;
          }
        });
      },
    );
  }

  String? selectedSurahValue;

  List<SearchFieldListItem<Object?>> souras = [
    SearchFieldListItem("الفاتحة", item: "الفاتحة"),
    SearchFieldListItem("البقرة", item: "البقرة"),
    SearchFieldListItem("آل عمران", item: "آل عمران"),
    SearchFieldListItem("النساء", item: "النساء"),
    SearchFieldListItem("المائدة", item: "المائدة"),
    SearchFieldListItem("الأنعام", item: "الأنعام"),
    SearchFieldListItem("الأعراف", item: "الأعراف"),
    SearchFieldListItem("الأنفال", item: "الأنفال"),
    SearchFieldListItem("التوبة", item: "التوبة"),
    SearchFieldListItem("يونس", item: "يونس"),
    SearchFieldListItem("هود", item: "هود"),
    SearchFieldListItem("يوسف", item: "يوسف"),
    SearchFieldListItem("الرعد", item: "الرعد"),
    SearchFieldListItem("ابراهيم", item: "ابراهيم"),
    SearchFieldListItem("الحجر", item: "الحجر"),
    SearchFieldListItem("النحل", item: "النحل"),
    SearchFieldListItem("الإسراء", item: "الإسراء"),
    SearchFieldListItem("الكهف", item: "الكهف"),
    SearchFieldListItem("مريم", item: "مريم"),
    SearchFieldListItem("طه", item: "طه"),
    SearchFieldListItem("الأنبياء", item: "الأنبياء"),
    SearchFieldListItem("الحج", item: "الحج"),
    SearchFieldListItem("المؤمنون", item: "المؤمنون"),
    SearchFieldListItem("النور", item: "النور"),
    SearchFieldListItem("الفرقان", item: "الفرقان"),
    SearchFieldListItem("الشعراء", item: "الشعراء"),
    SearchFieldListItem("النمل", item: "النمل"),
    SearchFieldListItem("القصص", item: "القصص"),
    SearchFieldListItem("العنكبوت", item: "العنكبوت"),
    SearchFieldListItem("الروم", item: "الروم"),
    SearchFieldListItem("لقمان", item: "لقمان"),
    SearchFieldListItem("السجدة", item: "السجدة"),
    SearchFieldListItem("الأحزاب", item: "الأحزاب"),
    SearchFieldListItem("سبإ", item: "سبإ"),
    SearchFieldListItem("فاطر", item: "فاطر"),
    SearchFieldListItem("يس", item: "يس"),
    SearchFieldListItem("الصافات", item: "الصافات"),
    SearchFieldListItem("ص", item: "ص"),
    SearchFieldListItem("الزمر", item: "الزمر"),
    SearchFieldListItem("غافر", item: "غافر"),
    SearchFieldListItem("فصلت", item: "فصلت"),
    SearchFieldListItem("الشورى", item: "الشورى"),
    SearchFieldListItem("الزخرف", item: "الزخرف"),
    SearchFieldListItem("الدخان", item: "الدخان"),
    SearchFieldListItem("الجاثية", item: "الجاثية"),
    SearchFieldListItem("الأحقاف", item: "الأحقاف"),
    SearchFieldListItem("محمد", item: "محمد"),
    SearchFieldListItem("الفتح", item: "الفتح"),
    SearchFieldListItem("الحجرات", item: "الحجرات"),
    SearchFieldListItem("ق", item: "ق"),
    SearchFieldListItem("الذاريات", item: "الذاريات"),
    SearchFieldListItem("الطور", item: "الطور"),
    SearchFieldListItem("النجم", item: "النجم"),
    SearchFieldListItem("القمر", item: "القمر"),
    SearchFieldListItem("الرحمن", item: "الرحمن"),
    SearchFieldListItem("الواقعة", item: "الواقعة"),
    SearchFieldListItem("الحديد", item: "الحديد"),
    SearchFieldListItem("المجادلة", item: "المجادلة"),
    SearchFieldListItem("الحشر", item: "الحشر"),
    SearchFieldListItem("الممتحنة", item: "الممتحنة"),
    SearchFieldListItem("الصف", item: "الصف"),
    SearchFieldListItem("الجمعة", item: "الجمعة"),
    SearchFieldListItem("المنافقون", item: "المنافقون"),
    SearchFieldListItem("التغابن", item: "التغابن"),
    SearchFieldListItem("الطلاق", item: "الطلاق"),
    SearchFieldListItem("التحريم", item: "التحريم"),
    SearchFieldListItem("الملك", item: "الملك"),
    SearchFieldListItem("القلم", item: "القلم"),
    SearchFieldListItem("الحاقة", item: "الحاقة"),
    SearchFieldListItem("المعارج", item: "المعارج"),
    SearchFieldListItem("نوح", item: "نوح"),
    SearchFieldListItem("الجن", item: "الجن"),
    SearchFieldListItem("المزمل", item: "المزمل"),
    SearchFieldListItem("المدثر", item: "المدثر"),
    SearchFieldListItem("القيامة", item: "القيامة"),
    SearchFieldListItem("الانسان", item: "الانسان"),
    SearchFieldListItem("المرسلات", item: "المرسلات"),
    SearchFieldListItem("النبإ", item: "النبإ"),
    SearchFieldListItem("النازعات", item: "النازعات"),
    SearchFieldListItem("عبس", item: "عبس"),
    SearchFieldListItem("التكوير", item: "التكوير"),
    SearchFieldListItem("الإنفطار", item: "الإنفطار"),
    SearchFieldListItem("المطففين", item: "المطففين"),
    SearchFieldListItem("الإنشقاق", item: "الإنشقاق"),
    SearchFieldListItem("البروج", item: "البروج"),
    SearchFieldListItem("الطارق", item: "الطارق"),
    SearchFieldListItem("الأعلى", item: "الأعلى"),
    SearchFieldListItem("الغاشية", item: "الغاشية"),
    SearchFieldListItem("الفجر", item: "الفجر"),
    SearchFieldListItem("البلد", item: "البلد"),
    SearchFieldListItem("المسد", item: "المسد"),
    SearchFieldListItem("النصر", item: "النصر"),
    SearchFieldListItem("الكافرون", item: "الكافرون"),
    SearchFieldListItem("الكوثر", item: "الكوثر"),
    SearchFieldListItem("الماعون", item: "الماعون"),
    SearchFieldListItem("قريش", item: "قريش"),
    SearchFieldListItem("الفيل", item: "الفيل"),
    SearchFieldListItem("الهمزة", item: "الهمزة"),
    SearchFieldListItem("العصر", item: "العصر"),
    SearchFieldListItem("التكاثر", item: "التكاثر"),
    SearchFieldListItem("القارعة", item: "القارعة"),
    SearchFieldListItem("العاديات", item: "العاديات"),
    SearchFieldListItem("الزلزلة", item: "الزلزلة"),
    SearchFieldListItem("البينة", item: "البينة"),
    SearchFieldListItem("القدر", item: "القدر"),
    SearchFieldListItem("العلق", item: "العلق"),
    SearchFieldListItem("التين", item: "التين"),
    SearchFieldListItem("الشرح", item: "الشرح"),
    SearchFieldListItem("الضحى", item: "الضحى"),
    SearchFieldListItem("الليل", item: "الليل"),
    SearchFieldListItem("الشمس", item: "الشمس"),
    SearchFieldListItem("الإخلاص", item: "الإخلاص"),
    SearchFieldListItem("الفلق", item: "الفلق"),
    SearchFieldListItem("الناس", item: "الناس"),
  ];

  
// checkConnection()async{
//  try{ var n = await InternetAddress.lookup('google.com');
//       if (!n.isEmpty || n != null) {
//         print("enable network");
//         Firestore.ref.enableNetwork();
//       }}catch(e){}
// }

  @override
  Widget build(BuildContext context) {
    var _screenWidth = MediaQuery.of(context).size.width;
    // var _screenHeight = MediaQuery.of(context).size.height;
    // checkConnection();
    return Scaffold(
        appBar: AppBar(
          title: Text("حفظ جديد "),
        ),
        body: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView(padding: EdgeInsets.all(20.0), children: [
              CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                              child: Image.asset("assets/icon/logo.png"),
                        ),
              SizedBox(
                //white space
                height: 50,
              ),
              Text(
                //std name
                widget.stdName,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              SizedBox(
                //white space
                height: 20,
              ),
              Container(
                  // height: 70,
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(child: dropdownButton()),
                              Container(
                                  width: _screenWidth * 0.5,
                                  child: SearchField(
                                    textInputAction: TextInputAction.next,
                                    autoCorrect: true,
                                    hint: 'اختر اسم السورة',
                                    searchInputDecoration: SearchInputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.green))),
                                    itemHeight: 50,
                                    maxSuggestionsInViewPort: 6,
                                    suggestionsDecoration: SuggestionDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    onSuggestionTap: (value) {
                                      setState(() {
                                        this.selectedSurahValue =
                                            value.item.toString();
                                      });
                                    },
                                    suggestions: souras,
                                    validator: (value) {
                                      print(value);
                                      if (this.selectedSurahValue == null ||
                                          this.selectedSurahValue!.isEmpty) {
                                        return 'يجب الاختيار من القائمة';
                                      }
                                      return null;
                                    },
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                child: TextFormField(
                                  //from
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'يجب تعبئة هذه الخانة';
                                    }
                                    return null;
                                  },
                                  controller: _frmController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      labelText: 'من',
                                      hintText: 'أدخل رقم الآية'),
                                ),
                                width: _screenWidth * 0.4,
                              ),
                              Container(
                                child: TextFormField(
                                    //to
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'يجب تعبئة هذه الخانة';
                                      }
                                      return null;
                                    },
                                    controller: _tController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'إلى',
                                        hintText: 'أدخل رقم الآية')),
                                width: _screenWidth * 0.4,
                              )
                            ],
                          ),
                          Container(
                            child: TextFormField(
                              //page cout
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'عدد الصفحات',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'يجب تعبئة هذه الخانة';
                                } else if (double.parse(value) < 0.5) {
                                  return 'لا يمكن ادخال قيمة اقل من 0.5';
                                }
                                return null;
                              },
                              controller: _pgsCountController,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: false, signed: false),
                            ),
                            width: _screenWidth * 0.4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                // qoulity text
                                child: Text(
                                  "جودة الحفظ (من 10)",
                                  textAlign: TextAlign.center,
                                ),
                                width: _screenWidth * 0.4,
                              ),
                              Container(
                                child: TextFormField(
                                  //quality
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'يجب تعبئة هذه الخانة';
                                    } else if (double.parse(value) > 10) {
                                      return 'لا يمكنك ادخال رقم اكبر من 10';
                                    } else if (double.parse(value) <= 0) {
                                      return "يجب ان تكون الجودة اكبر من 0";
                                    }
                                    return null;
                                  },
                                  controller: _qualityController,
                                  keyboardType: TextInputType.number,
                                ),
                                width: _screenWidth * 0.4,
                              ),
                            ],
                          ),
                          
                          Container(
                            child: TextFormField(
                              //commitment
                              decoration: const InputDecoration(
                                  labelText: 'الإلتزام', hintText: "من 10"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'يجب تعبئة هذه الخانة';
                                }
                                if (double.parse(value) > 10) {
                                  return 'لا يمكنك ادخال رقم اكبر من 10';
                                }
                                return null;
                              },
                              controller: _commitmentController,
                              keyboardType: TextInputType.number,
                            ),
                            width: _screenWidth * 0.4,
                          )
                        ],
                      ))),
              SizedBox(
                //white space
                height: 50,
              ),
              Container(
                  //save btn
                  width: _screenWidth * 0.8,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // print("${_surahController.text}     ${this.selectedSurahValue}");
                        try {
                          save(
                                  widget.stdID.toString(),
                                  widget.memorizerEmail,
                                  this.selectedSurahValue.toString(),
                                  _frmController.text,
                                  _tController.text,
                                  double.parse(_qualityController.text),
                                  double.parse(_pgsCountController.text),
                                  double.parse(_commitmentController.text),
                                  factor)
                              .then((value) => Navigator.of(context)
                                  .popUntil((route) => route.isFirst));
                        } catch (e) {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              text: e.toString(),
                              title:
                                  "حدث خلل غير متوقع, قم بإرسال لقطة شاشة للدعم الفني");
                        }
// myFierstor.addStudent(
//                                 widget.studentPhone.toString(),
//                                 widget.memorizerEmail, {
//                               "type": dropDownTypeValue.toString(),
//                               "surah":  this.selectedSurahValue.toString(),
//                               "from": _frmController.text.toString(),
//                               "to": _tController.text.toString(),
//                               "quality": _qualityController.text.toString(),
//                               "pages-count": _pgsCountController.text.toString(),
//                               "commetment": _commitmentController.text.toString(),

//                             });
                      }
                    },
                    child: Text(
                      "SAVE",
                    ),
                  ))
            ])),
        bottomNavigationBar: BottomBar(
          dailyReplace: true,
          dailyPush: false,
          home: true,
          addStudent: true,
          memorizerEmail: widget.memorizerEmail,
        ));
  
  }
}
