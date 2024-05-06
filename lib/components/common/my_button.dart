import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color buttonColor;
  final Color textColor;
  final String title;

  const MyButton({
    super.key,
    required this.onTap,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.buttonColor = Colors.blue,
    this.textColor = Colors.white,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
