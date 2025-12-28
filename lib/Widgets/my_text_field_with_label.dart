import 'package:flutter/material.dart';

class MyTextFieldWithLabel extends StatelessWidget {
  String label;
  String hint;
  IconData icon;
  TextEditingController? controller;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;

  MyTextFieldWithLabel(
      {this.keyboardType,
      this.textInputAction,
      this.controller,
      required this.label,
      required this.icon,
      required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 109,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              // fontWeight: FontWeight.bold,
              fontSize: 16,
              // color: Colors.black,
            ),
          ),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              // labelText: label,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: Icon(icon),
            ),
          ),
        ],
      ),
    );
  }
}
