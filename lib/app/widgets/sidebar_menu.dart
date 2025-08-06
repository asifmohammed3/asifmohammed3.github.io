import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:portfolio_website/app/modules/home/controllers/home_controller.dart';

class SidebarMenu extends StatelessWidget {
  SidebarMenu({super.key});

  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final items = {
      'home': FontAwesomeIcons.house,
      'about': FontAwesomeIcons.user,
      'resume': FontAwesomeIcons.file,
      'portfolio': FontAwesomeIcons.image,
      'services': FontAwesomeIcons.server,
      'contact': FontAwesomeIcons.envelope,
    };

    return IntrinsicHeight(
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Menu Items
            Obx(() => Column(
              children: items.entries
                  .map((e) => _buildNavItem(e.key, e.value))
                  .toList(),
            )),
            const Spacer(),
            // Socials
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Wrap(
                spacing: 12,
                children: const [
                  FaIcon(FontAwesomeIcons.xTwitter, color: Colors.white, size: 18),
                  FaIcon(FontAwesomeIcons.facebookF, color: Colors.white, size: 18),
                  FaIcon(FontAwesomeIcons.instagram, color: Colors.white, size: 18),
                  FaIcon(FontAwesomeIcons.linkedinIn, color: Colors.white, size: 18),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon) {
    final isSelected = controller.currentSection.value == label;

    return TextButton.icon(
      onPressed: () => controller.scrollToSection(label),
      icon: FaIcon(icon, color: isSelected ? Colors.blue : Colors.white, size: 18),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          label.capitalizeFirst!,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
