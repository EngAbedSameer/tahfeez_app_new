import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';
import 'package:tahfeez_app/Widgets/my_fill_width_button.dart';
import 'package:tahfeez_app/Widgets/my_text_field_with_label.dart';
import 'package:tahfeez_app/module/add_record/add_record_controller.dart';
// import 'sqfDB.dart';

class AddRecordScreen extends StatelessWidget {
  final String stdID;
  final String stdName;
  final String memorizerEmail;
  final studentPhone;

  AddRecordScreen(
      {super.key,
      required this.stdID,
      required this.memorizerEmail,
      this.studentPhone,
      required this.stdName});

//   @override
//   State<AddRecordScreen> createState() => _AddRecordScreenState();
// }

// class _AddRecordScreenState extends State<AddRecordScreen>
//     with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    // var _screenWidth = MediaQuery.of(context).size.width;
    // var _screenHeight = MediaQuery.of(context).size.height;
    // checkConnection();
    return Scaffold(
        appBar: AppBar(
          title: Text("حفظ جديد "),
        ),
        body: _newbuild()
        // bottomNavigationBar: BottomBar(
        //   dailyReplace: true,
        //   dailyPush: false,
        //   home: true,
        //   addStudent: true,
        //   memorizerEmail: widget.memorizerEmail,
        // )
        );
  }

//   _build() {
//     return Directionality(
//         textDirection: TextDirection.rtl,
//         child: ListView(padding: EdgeInsets.all(20.0), children: [
//           CircleAvatar(
//             radius: 50,
//             backgroundColor: Colors.white,
//             child: Image.asset("assets/icon/logo.png"),
//           ),
//           SizedBox(
//             //white space
//             height: 50,
//           ),
//           Text(
//             //std name
//             widget.stdName,
//             textAlign: TextAlign.center,
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//           ),
//           SizedBox(
//             //white space
//             height: 20,
//           ),
//           Container(
//               // height: 70,
//               child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(child: dropdownButton()),
//                           Container(
//                               width: _screenWidth * 0.5,
//                               child: SearchField(
//                                 textInputAction: TextInputAction.next,
//                                 autoCorrect: true,
//                                 hint: 'اختر اسم السورة',
//                                 searchInputDecoration: SearchInputDecoration(
//                                     enabledBorder: OutlineInputBorder(
//                                         borderSide:
//                                             BorderSide(color: Colors.green))),
//                                 itemHeight: 50,
//                                 maxSuggestionsInViewPort: 6,
//                                 suggestionsDecoration: SuggestionDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(10)),
//                                 onSuggestionTap: (value) {
//                                   setState(() {
//                                     this.selectedSurahValue =
//                                         value.item.toString();
//                                   });
//                                 },
//                                 suggestions: souras,
//                                 validator: (value) {
//                                   print(value);
//                                   if (this.selectedSurahValue == null ||
//                                       this.selectedSurahValue!.isEmpty) {
//                                     return 'يجب الاختيار من القائمة';
//                                   }
//                                   return null;
//                                 },
//                               )),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Container(
//                             child: TextFormField(
//                               //from
//                               textInputAction: TextInputAction.next,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'يجب تعبئة هذه الخانة';
//                                 }
//                                 return null;
//                               },
//                               controller: _frmController,
//                               keyboardType: TextInputType.number,
//                               decoration: const InputDecoration(
//                                   labelText: 'من', hintText: 'أدخل رقم الآية'),
//                             ),
//                             width: _screenWidth * 0.4,
//                           ),
//                           Container(
//                             child: TextFormField(
//                                 //to
//                                 textInputAction: TextInputAction.next,
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'يجب تعبئة هذه الخانة';
//                                   }
//                                   return null;
//                                 },
//                                 controller: _tController,
//                                 keyboardType: TextInputType.number,
//                                 decoration: const InputDecoration(
//                                     labelText: 'إلى',
//                                     hintText: 'أدخل رقم الآية')),
//                             width: _screenWidth * 0.4,
//                           )
//                         ],
//                       ),
//                       Container(
//                         child: TextFormField(
//                           //page cout
//                           textInputAction: TextInputAction.next,
//                           decoration: const InputDecoration(
//                             labelText: 'عدد الصفحات',
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'يجب تعبئة هذه الخانة';
//                             } else if (double.parse(value) < 0.5) {
//                               return 'لا يمكن ادخال قيمة اقل من 0.5';
//                             }
//                             return null;
//                           },
//                           controller: _pgsCountController,
//                           keyboardType: TextInputType.numberWithOptions(
//                               decimal: false, signed: false),
//                         ),
//                         width: _screenWidth * 0.4,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Container(
//                             // qoulity text
//                             child: Text(
//                               "جودة الحفظ (من 10)",
//                               textAlign: TextAlign.center,
//                             ),
//                             width: _screenWidth * 0.4,
//                           ),
//                           Container(
//                             child: TextFormField(
//                               //quality
//                               textInputAction: TextInputAction.next,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'يجب تعبئة هذه الخانة';
//                                 } else if (double.parse(value) > 10) {
//                                   return 'لا يمكنك ادخال رقم اكبر من 10';
//                                 } else if (double.parse(value) <= 0) {
//                                   return "يجب ان تكون الجودة اكبر من 0";
//                                 }
//                                 return null;
//                               },
//                               controller: _qualityController,
//                               keyboardType: TextInputType.number,
//                             ),
//                             width: _screenWidth * 0.4,
//                           ),
//                         ],
//                       ),
//                       Container(
//                         child: TextFormField(
//                           //commitment
//                           decoration: const InputDecoration(
//                               labelText: 'الإلتزام', hintText: "من 10"),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'يجب تعبئة هذه الخانة';
//                             }
//                             if (double.parse(value) > 10) {
//                               return 'لا يمكنك ادخال رقم اكبر من 10';
//                             }
//                             return null;
//                           },
//                           controller: _commitmentController,
//                           keyboardType: TextInputType.number,
//                         ),
//                         width: _screenWidth * 0.4,
//                       )
//                     ],
//                   ))),
//           SizedBox(
//             //white space
//             height: 50,
//           ),
//           Container(
//               //save btn
//               width: _screenWidth * 0.8,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     // print("${_surahController.text}     ${this.selectedSurahValue}");
//                     try {
//                       save(
//                               widget.stdID.toString(),
//                               widget.memorizerEmail,
//                               this.selectedSurahValue.toString(),
//                               _frmController.text,
//                               _tController.text,
//                               double.parse(_qualityController.text),
//                               double.parse(_pgsCountController.text),
//                               double.parse(_commitmentController.text),
//                               factor)
//                           .then((value) => Navigator.of(context)
//                               .popUntil((route) => route.isFirst));
//                     } catch (e) {
//                       QuickAlert.show(
//                           context: context,
//                           type: QuickAlertType.error,
//                           text: e.toString(),
//                           title:
//                               "حدث خلل غير متوقع, قم بإرسال لقطة شاشة للدعم الفني");
//                     }
// // myFierstor.addStudent(
// //                                 widget.studentPhone.toString(),
// //                                 widget.memorizerEmail, {
// //                               "type": dropDownTypeValue.toString(),
// //                               "surah":  this.selectedSurahValue.toString(),
// //                               "from": _frmController.text.toString(),
// //                               "to": _tController.text.toString(),
// //                               "quality": _qualityController.text.toString(),
// //                               "pages-count": _pgsCountController.text.toString(),
// //                               "commetment": _commitmentController.text.toString(),
// //                             });
//                   }
//                 },
//                 child: Text(
//                   "SAVE",
//                 ),
//               ))
//         ]));
//   }

  _newbuild() {
    return SingleChildScrollView(
      child: GetBuilder<AddRecordController>(builder: (controller) {
        //600$ 300
        return Padding(
          padding: const EdgeInsets.all(18),
          child: Form(
            // key: controller.formKey,
            child: Column(
              children: [
                Text(
                  '${stdName}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                SearchField(
                  // controller: controller.selectedSurahValue,
                  textInputAction: TextInputAction.next,
                  autoCorrect: true,
                  hint: 'اختر اسم السورة',
                  searchInputDecoration: SearchInputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // labelText: label,
                    fillColor: Colors.white,
                    filled: false,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    prefixIcon: null,
                  ),
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 6,
                  suggestionsDecoration: SuggestionDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  onSuggestionTap: (value) {
                    // controller.selectedSurahValue.text = value.item.toString();
                    // controller.update();
                  },
                  suggestions: [],
                  validator: (value) {
                    print(value);
                    // if (controller.selectedSurahValue == null ||
                    //     controller.selectedSurahValue.text.isEmpty) {
                    //   return 'يجب الاختيار من القائمة';
                    // }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                SegmentedButton<double>(
                  segments: [
                    ButtonSegment<double>(value: 1, label: Text('حفظ جديد')),
                    ButtonSegment<double>(
                        value: 0.5, label: Text('مراجعة حفظ')),
                  ],
                  selected: {1.0},
                  onSelectionChanged: (Set<double> newSelection) {
                    // controller.RecordTypeValue = newSelection.first;
                    // controller.update();
                  },
                  multiSelectionEnabled: false,
                  selectedIcon: SizedBox(),
                ),
                SizedBox(
                  height: 10,
                ),
                MyTextFieldWithLabel(
                  // controller: controller.startAyaController,
                  hint: 'آية البداية',
                  label: 'آية البداية',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                ),
                MyTextFieldWithLabel(
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'هذه الخانة مطلوبة';
                    }
                    return null;
                    // if (int.parse(controller.endAyahController.text) <=
                    //     int.parse(controller.startAyaController.text)) {
                    //   return 'يجب ان تكون آية النهاية أكبر من آية البداية';
                    // }
                  },
                  // controller: controller.endAyahController,
                  hint: '',
                  label: 'آية النهاية',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                ),
                MyTextFieldWithLabel(
                  // controller: controller.pgsCountController,
                  hint: 'يمكن عدد صحيح مثل 3 صفحات او بالكسور مثل 3.5',
                  label: 'عدد الصفحات',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                ),
                MyTextFieldWithLabel(
                  // controller: controller.qualityController,
                  hint: '',
                  label: 'جودة الحفظ',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                ),
                MyTextFieldWithLabel(
                  // controller: controller.commitmentController,
                  hint: '',
                  label: 'إلتزام الطالب في الحلقة',
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                ),
                MyFillWidthButton(
                  backgroundColor: Colors.teal,
                  label: 'حفظ',
                  onPressed: () {
                    // if (controller.formKey.currentState!.validate()) {
                    //   controller.save(
                    //       stdID,
                    //       memorizerEmail,
                    //       controller.selectedSurahValue.text,
                    //       controller.startAyaController.text,
                    //       controller.endAyahController.text,
                    //       double.parse(controller.qualityController.text),
                    //       double.parse(controller.pgsCountController.text),
                    //       double.parse(controller.commitmentController.text),
                    //       controller.RecordTypeValue);
                    // }
                  },
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
