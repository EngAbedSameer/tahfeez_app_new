import 'package:flutter/material.dart';

class MyFillWidthButton extends StatelessWidget {
  String label;
  Function()? onPressed;
  MyFillWidthButton({required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}