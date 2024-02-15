import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    this.icon,
    required this.lable,
    this.lines = 1,
    this.lenth,
    required this.controller,
    this.readonly = false,
    this.obscureText = false,
    this.inputType,
    this.prefixIcon,
    this.hintText,
  }) : super(key: key);

  final IconData? icon;
  final String lable;
  final int lines;
  final int? lenth;
  final TextEditingController controller;
  final bool readonly;
  final bool obscureText;
  final TextInputType? inputType;
  final IconData? prefixIcon;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomText(
              text: lable,
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          maxLines: lines,
          maxLength: lenth,
          readOnly: readonly,
          keyboardType: inputType,
          obscureText: obscureText,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            isDense: true, // important line
            // contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            // prefixIcon: prefixIcon != null
            //     ? Icon(
            //         size: 25,
            //         prefixIcon,
            //         color: Colors.grey,
            //       )
            //     : const SizedBox(width: 0),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
