import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tahfeez_app/module/main/home/home_screen.dart';
import 'package:tahfeez_app/module/main/main_controller.dart';
import 'package:tahfeez_app/module/settings/settings_screen.dart';
import 'package:tahfeez_app/module/students/students_screen.dart';
import 'package:tahfeez_app/widgets/BottomBar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      builder: (controller) {
        return Scaffold(
            body: PageView(
              onPageChanged: (value) {
                controller.pageIndex = value;
                controller.update();
              },
              controller: controller.pageViewController,
              children: [HomeScreen(), StudentsScreen(), SettingsScreen()],
            ),
            bottomNavigationBar: BottomBar());
      },
    );
  }
}
