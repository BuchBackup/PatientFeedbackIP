import 'package:flutter/material.dart';

import '../services/constent.dart';

// ignore_for_file: prefer_typing_uninitialized_variables
class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    this.fillColor,
    this.hintText,
    this.inputType,
    this.suffixIcon,
    this.validator,
    this.controller,
    this.inputFormater,
    this.lableText,
    this.initialValue,
    this.hintStyle,
    this.prefixIcon,
    this.onChanged,
    this.isObsecure = false,
    this.style,
    Null Function(String value)? onSaved,
  }) : super(key: key);
  final hintText;
  final inputType;
  final validator;
  final controller;
  final inputFormater;
  final lableText;
  final initialValue;
  final suffixIcon;
  final prefixIcon;
  final isObsecure;
  final hintStyle;
  final fillColor;
  final onChanged;
  final style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLines: 1,
        style: style,
        keyboardType: inputType,
        textInputAction: TextInputAction.next,
        initialValue: initialValue,
        obscureText: isObsecure,
        onChanged: onChanged,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15),
            // filled: true,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                30.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 171, 202, 83), width: 2.0),
              borderRadius: BorderRadius.circular(30.0),
            ),
            labelStyle: kBodyBlack16,
            hintText: hintText,
            labelText: lableText,
            hintStyle: hintStyle,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            errorStyle: const TextStyle(fontSize: 12)),
        validator: validator,
        inputFormatters: inputFormater,
        controller: controller,
      ),
    );
  }
}
