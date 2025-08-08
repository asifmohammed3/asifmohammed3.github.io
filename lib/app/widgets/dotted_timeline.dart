import 'package:flutter/material.dart';

class DottedTimeline extends StatelessWidget {
  const DottedTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white12, width: 2),
          ),
        ),
        Expanded(
          // Fills the rest of the vertical space under the dot
          child: Container(width: 3, color: Colors.white12),
        ),
      ],
    );
  }
}
