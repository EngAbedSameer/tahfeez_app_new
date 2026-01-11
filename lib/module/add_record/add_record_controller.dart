
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:searchfield/searchfield.dart';
import 'package:tahfeez_app/model/Firestore.dart';

class AddRecordController extends GetxController {
  final GlobalKey formKey = GlobalKey<FormState>();
  Firestore myFierstor = Firestore();

  TextEditingController startAyaController = TextEditingController();
  TextEditingController endAyahController = TextEditingController();
  TextEditingController qualityController = TextEditingController();
  TextEditingController pgsCountController = TextEditingController();
  TextEditingController commitmentController = TextEditingController();
  TextEditingController selectedSurahValue = TextEditingController();
  double RecordTypeValue = 1;

  // String getRandomID(int length) {
  //   final random = Random();
  //   const availableChars =
  //       'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  //   final randomString = List.generate(length,
  //           (index) => availableChars[random.nextInt(availableChars.length)])
  //       .join();

  //   return randomString;
  // }

  Future save(String stdID, String email, String surah, String from, String to,
      double quality, double pgsCount, double commitment, double type) async {
    try {
      QuickAlert.show(
          context: Get.context!,
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
      await myFierstor.addRecord(idn: stdID.toString(), mEmail: email, data: {
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
          .then((value) => Navigator.pop(Get.context!));
    } catch (e) {
      print(e);
      QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          text: e.toString(),
          title: "حدث خلل غير متوقع, قم بإرسال لقطة شاشة للدعم الفني");
    }
  }

  // Future<String> _getStdName(stdID, memorizerEmail) async {
  //   var std = await myFierstor.getStudentData(
  //       idn: stdID.toString(), mEmail: memorizerEmail);
  //   var name = await ("""${std['f_name']} ${std['l_name']}""");
  //   return name;
  // }

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
}
