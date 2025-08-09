import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Footer content centered horizontally
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              Divider(
                color: Colors.white12,
                thickness: 1,
                indent: 40,
                endIndent: 40,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.favorite, color: Colors.redAccent, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "Crafted with Flutter 💫",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),

        /// Fixed-position settings button at bottom-right
        Positioned(
          bottom: 16,
          right: 16,
          child: InkWell(
            onTap: () => Get.toNamed(Routes.ADMIN_AUTH),
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.settings,
                color: Colors.black87,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
