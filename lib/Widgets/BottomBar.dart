// import 'dart:io';


import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:tahfeez_app/module/main/main_controller.dart';
// import 'package:tahfeez_app/Home.dart';

class BottomBar extends StatelessWidget {
  BottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
        builder: (controller) => _newBuild(controller));
  }

  // _build() {
  _newBuild(MainController controller) {
    return BottomNavigationBar(
        currentIndex: controller.pageIndex,
        iconSize: 28,
        // backgroundColor: Colors.white,
        // elevation: 10,
        // type: BottomNavigationBarType.shifting,
        onTap: (value) {
          controller.pageIndex = value;
          controller.pageViewController.animateToPage(value,
              duration: Duration(milliseconds: 100), curve: Easing.standard);
        },
        // fixedColor: Colors.black87,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'الرئيسية'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined),
              activeIcon: Icon(Icons.people),
              label: 'الطلاب'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'الإعدادات'),
        ]);
  }
}
