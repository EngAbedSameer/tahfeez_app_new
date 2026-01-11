import 'package:flutter/material.dart';

class MyTextFieldWithLabel extends StatelessWidget {
  String? label;
  String hint;
  Icon? icon;
  TextEditingController? controller;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  bool? filled;
  Color? borderColor;
  Color? fillColor;
  double? padding;
  FormFieldValidator<String>? validator;
  double? borderRadius;

  MyTextFieldWithLabel(
      {this.keyboardType,
      this.textInputAction,
      this.controller,
      this.label,
      this.icon,
      required this.hint,
      this.fillColor,
      this.validator,
      this.padding,
      this.filled,
      this.borderRadius,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical:  padding ?? 10),
      // height: 112,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label != null
              ? Text(
                  label ?? '',
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 16,
                    // color: Colors.black,
                  ),
                )
              : SizedBox(),
          TextFormField(
            validator: validator??(v){
              if(v==null || v==''){
                return 'هذه الخانة مطلوبة';
              }
              return null;
            },
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor ?? Colors.grey),
                borderRadius: BorderRadius.circular(borderRadius ?? 10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor ?? Colors.grey),
                borderRadius: BorderRadius.circular(borderRadius??10),
              ),
              // labelText: label,
              fillColor: fillColor ?? Colors.white,
              filled: filled ?? false,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: icon ?? null,
            ),
          ),
        ],
      ),
    );
  }
}
