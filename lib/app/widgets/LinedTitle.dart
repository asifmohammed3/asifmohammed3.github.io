import 'package:flutter/material.dart';

class LinedTitle extends StatelessWidget {
  final String text;
  final Color lineColor;
  final TextStyle? textStyle;

  const LinedTitle({
    super.key,
    required this.text,
    this.lineColor = Colors.white,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // shrink wrap
      children: [
        Container(width: 80, height: 2, color: lineColor),
        const SizedBox(width: 8),
        Text(
          text,
          style:
              textStyle ??
              TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.white,
              ),
        ),
        const SizedBox(width: 8),
        Container(width: 80, height: 2, color: lineColor),
      ],
    );
  }
}
