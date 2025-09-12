

import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final double elevation;
  final double fontsize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = const Color.fromARGB(255, 0, 104, 55),
    this.textColor = Colors.white,
    this.borderRadius = 3,
    this.elevation = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
    this.fontsize = 16,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(color),
        elevation: WidgetStateProperty.all<double>(elevation),
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      child: Padding(
        padding: padding,
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: fontsize, fontWeight: fontWeight),
        ),
      ),
    );
  }
}