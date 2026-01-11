import 'package:flutter/material.dart';

class MyFillWidthButton extends StatelessWidget {
  String label;
  Function()? onPressed;
  Color? backgroundColor;
  Color? textColor;
  MyFillWidthButton(
      {required this.label, this.onPressed, this.backgroundColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(backgroundColor ?? Colors.white)),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
