import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'custom_loader.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.height = 40,
    this.width = double.infinity,
    this.isLoading = false,
    this.fontColor = Colors.white,
    this.fontSize = 17,
    this.color = Colors.deepPurple,
    this.top = 10,
    this.bottom = 10,
    this.left = 10,
    this.right = 10,
    this.icon,
  }) : super(key: key);

  final Function() onTap;
  final String text;
  final double height;
  final double width;
  final bool isLoading;
  final Color fontColor;
  final double fontSize;
  final Color color;
  final double top;
  final double bottom;
  final double left;
  final double right;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
      ),
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: isLoading
                ? const CustomLoader()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: fontColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
