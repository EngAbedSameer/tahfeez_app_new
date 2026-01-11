import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class MainController extends GetxController {
  TabController? tabsController;
  PageController pageViewController= PageController();
  int pageIndex=0;
}
