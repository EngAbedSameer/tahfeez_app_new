import 'package:get/get.dart';
import 'package:tahfeez_app/module/auth/login/login_controller.dart';
import 'package:tahfeez_app/module/home/home_controller.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<HomeController>(() => HomeController());
   
  }
}
