import 'package:get/get.dart';
import 'package:tahfeez_app/module/add_record/add_record_controller.dart';
import 'package:tahfeez_app/module/auth/login/login_controller.dart';
import 'package:tahfeez_app/module/main/home/home_controller.dart';
import 'package:tahfeez_app/module/main/main_controller.dart';
import 'package:tahfeez_app/module/student_profile/edit_student_data/edit_student_data_controller.dart';
import 'package:tahfeez_app/module/student_profile/student_profile_controller.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<AddRecordController>(() => AddRecordController());
    Get.lazyPut<EditStudentDataController>(() => EditStudentDataController());
    Get.lazyPut<StudentProfileController>(() => StudentProfileController());
  }
}
