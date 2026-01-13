import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tahfeez_app/Widgets/my_fill_width_button.dart';
import 'package:tahfeez_app/Widgets/my_text_field_with_label.dart';
import 'package:tahfeez_app/module/student_profile/edit_student_data/edit_student_data_controller.dart';

class EditStudentData extends StatelessWidget {
  EditStudentData({super.key});
  EditStudentDataController controller = Get.put(EditStudentDataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل بيانات الطالب'),
      ),
      body: GetBuilder<EditStudentDataController>(
          init: controller,
          builder: (controller) {
            return FutureBuilder(
                future: controller.getStudentData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: SingleChildScrollView(
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              Center(
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      width: 135,
                                      height: 135,
                                      padding: const EdgeInsets.all(5.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(100),
                                        child: controller.imagePath == null
                                            ? Image.asset(
                                                "assets/images/person.jpg",
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                fit: BoxFit.cover,
                                                controller.imagePath!,
                                              ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: IconButton(
                                          onPressed: () async {
                                            await controller.editStudentImage();
                                          },
                                          padding: EdgeInsets.all(5),
                                          constraints: BoxConstraints(
                                              minWidth: 10,
                                              maxHeight: 30,
                                              maxWidth: 30,
                                              minHeight: 10),
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                      Colors.teal[200])),
                                          icon: Icon(
                                            Icons.edit,
                                            size: 20,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 150.w,
                                      child: MyTextFieldWithLabel(
                                        controller:
                                            controller.firstNameEditController,
                                        hint: 'الأسم الأول',
                                        label: 'الأسم الأول',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 150.w,
                                      child: MyTextFieldWithLabel(
                                        controller:
                                            controller.midNameEditController,
                                        hint: 'الأسم الأوسط',
                                        label: 'الأسم الأوسط',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              MyTextFieldWithLabel(
                                controller: controller.lastNameEditController,
                                hint: 'الأسم الأخير',
                                label: 'الأسم الأخير',
                              ),
                              MyTextFieldWithLabel(
                                controller: controller.DOBEditController,
                                hint: 'تاريخ الميلاد',
                                label: 'تاريخ الميلاد',
                              ),
                              MyTextFieldWithLabel(
                                controller: controller.phoneEditController,
                                hint: 'الجوال',
                                label: 'الجوال',
                              ),
                              MyTextFieldWithLabel(
                                controller: controller.IdnEditController,
                                hint: 'رقم الهوية',
                                label: 'رقم الهوية',
                              ),
                              MyFillWidthButton(
                                label: 'حفظ التعديلات',
                                backgroundColor: Colors.teal,
                                textColor: Colors.white,
                                onPressed: () {
                                  if (controller.formKey.currentState!
                                      .validate()) {
                                    controller.editStudentData().then((e) {
                                      final snackBar = SnackBar(
                                        content: Text('تم تعديل البيانات'),
                                        duration: Duration(
                                            seconds:
                                                1), // How long the message is visible
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    });
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                });
          }),
    );
  }
}
