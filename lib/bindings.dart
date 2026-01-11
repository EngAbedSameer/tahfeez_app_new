import 'package:get/get.dart';
import 'package:tahfeez_app/module/add_record/add_record_controller.dart';
import 'package:tahfeez_app/module/auth/login/login_controller.dart';
import 'package:tahfeez_app/module/main/home/home_controller.dart';
import 'package:tahfeez_app/module/main/main_controller.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<AddRecordController>(() => AddRecordController());
  }
}
