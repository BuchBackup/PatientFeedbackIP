import 'package:flutter/material.dart';
import 'package:new_bih_feedback/services/constent.dart';

class MyInputTextField extends StatelessWidget {
  const MyInputTextField(
      {Key? key,
      this.hintText,
      this.focusNode,
      this.controller,
      this.inputFormatters,
      this.prefixIcon,
      this.validator,
      this.initialValue,
      this.keyboardType,
      this.labelText})
      : super(key: key);
  final hintText;
  final controller;
  final inputFormatters;
  final prefixIcon;
  final validator;
  final initialValue;
  final keyboardType;
  final labelText;
  final focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      style: kBodyWhite12,
      maxLines: 4,
      decoration: InputDecoration(
          counterStyle: const TextStyle(fontSize: 12),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 171, 202, 83), width: 2.0),
            borderRadius: BorderRadius.circular(7.0),
          ),
          filled: false,
          hintStyle: const TextStyle(color: Colors.white, fontSize: 12),
          hintText: hintText,
          labelText: labelText,
          helperStyle: const TextStyle(fontSize: 12),
          errorStyle: const TextStyle(fontSize: 12),
          labelStyle: kBodyWhite12,
          fillColor: Colors.white70,
          prefixIcon: prefixIcon),
      controller: controller,
      inputFormatters: inputFormatters,
      validator: validator,
      initialValue: initialValue,
      keyboardType: keyboardType,
    );
  }
}
