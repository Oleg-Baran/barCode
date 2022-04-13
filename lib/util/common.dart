import 'package:flutter/material.dart';

class Common {
  // ignore: avoid_init_to_null
  static InputDecoration getInputDecoration(String hintText,
      {suffixIcon = null}) {
    const borderRadius = BorderRadius.all(Radius.circular(8.0));
    const borderWidthValue = 1.0;

    const errorBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: Colors.red, width: borderWidthValue),
    );
    const defaultBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: Color(0xFFE8E8E8), width: borderWidthValue),
    );

    return InputDecoration(
      enabledBorder: defaultBorder,
      focusedBorder: defaultBorder,
      border: defaultBorder,
      errorMaxLines: 3,
      focusedErrorBorder: errorBorder,
      errorBorder: errorBorder,
      filled: true,
      hintStyle: const TextStyle(
          color: Color(0xFFBDBDBD), fontSize: 16, fontWeight: FontWeight.w400),
      hintText: hintText,
      fillColor: Color(0xFFF6F6F6),
      contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
      suffixIcon: suffixIcon,
    );
  }

  static void hideKeyboard(context) {
    return FocusScope.of(context).unfocus();
  }
}
