import 'package:flutter/material.dart';

class CustomHamburger extends StatelessWidget {
  const CustomHamburger({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: InkWell(
          onTap: () => Scaffold.of(context).openDrawer(),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.menu, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
