// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tahfeez_app/AddStudent.dart';
// import 'package:tahfeez_app/Home.dart';

class BottomBar extends StatefulWidget {
  final bool home;
  final bool dailyPush;
  final bool dailyReplace;
  final bool addStudent;
  final String memorizerEmail;
  const BottomBar(
      {super.key,
      required this.home,
      required this.addStudent,
      required this.dailyPush,
      required this.dailyReplace,
      required this.memorizerEmail});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(Colors.green[100]!.value ),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35), topRight: Radius.circular(35)),
            color: Colors.green),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.person_add,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                if (widget.addStudent) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddStudent(
                            memorizerEmail: widget.memorizerEmail,
                          )));
                }
              },
            ),
            IconButton(
              icon: Icon(
                Icons.checklist_rounded,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                if (widget.dailyReplace) {
                  // Navigator.of(context).popUntil((route) => route.isFirst);
                  // Navigator.of(context).pushReplacement(
                  //     MaterialPageRoute(builder: (context) => DaPage(memorizerEmail: widget.memorizerEmail,)));
                }
                if (widget.dailyPush) {
                  // Navigator.of(context).popUntil((route) => route.isFirst);
                  // Navigator.of(context)
                  //     .push(MaterialPageRoute(builder: (context) => DaPage(memorizerEmail: widget.memorizerEmail,)));
                }
              },
            ),
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () => {
                if (widget.home)
                  {Navigator.of(context).popUntil((route) => route.isFirst)}
              },
            ),
          ],
        ),
      ),
    );
  }
}
