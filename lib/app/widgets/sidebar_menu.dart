import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio_website/app/modules/home/controllers/home_controller.dart';
import '../routes/app_pages.dart';

class SidebarMenu extends GetView<HomeController> {
  SidebarMenu({super.key});

  // Main navigation items
  final navItems = [
    _NavItemData("Home", FontAwesomeIcons.house),
    _NavItemData("About", FontAwesomeIcons.user),
    _NavItemData("Skills", FontAwesomeIcons.noteSticky),
    _NavItemData("Resume", FontAwesomeIcons.file),
    _NavItemData("Portfolio", FontAwesomeIcons.image),
    _NavItemData("Contact", FontAwesomeIcons.envelope),
  ];

  // Social links (icon + url)
  final socials = [
    {
      'icon': FontAwesomeIcons.facebookF,
      'url': 'https://www.facebook.com/mohammedasif.parambil/',
    },
    {
      'icon': FontAwesomeIcons.instagram,
      'url': 'https://www.instagram.com/_asif_mohammed_/',
    },
    {
      'icon': FontAwesomeIcons.linkedinIn,
      'url': 'https://www.linkedin.com/in/mohammedasifp/',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: 270,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Navigation Items
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...navItems.map((item) {
                    final isSelected =
                        controller.currentSection.value.toLowerCase() ==
                        item.label.toLowerCase();
                    return _SidebarMenuItem(
                      label: item.label,
                      icon: item.icon,
                      isSelected: isSelected,
                      onTap: () {
                        controller.scrollToSection(item.label.toLowerCase());
                      },
                    );
                  }),
                ],
              ),
            ),
            const Spacer(),

            // Social Icons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: socials.map((data) {
                  return _CircleIcon(
                    icon: data['icon'] as IconData,
                    onTap: () => _launchUrl(data['url'] as String),
                  );
                }).toList(),
              ),
            ),

            // Small Edit Icon Button
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Center(
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.ADMIN_AUTH);
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: Colors.black87,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Utility to launch URLs
  static Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar(
        'Error',
        'Could not launch $url',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

// Data class for nav items
class _NavItemData {
  final String label;
  final IconData icon;

  _NavItemData(this.label, this.icon);
}

class _SidebarMenuItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarMenuItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final inactiveColor = const Color(0xFFB3B3B3);
    final activeColor = Colors.white;
    final textColor = isSelected ? activeColor : inactiveColor;
    final fontWeight = (isSelected || label == "Home")
        ? FontWeight.bold
        : FontWeight.normal;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            FaIcon(
              icon,
              color: isSelected ? Colors.white : inactiveColor,
              size: 21,
            ),
            const SizedBox(width: 18),
            Text(
              label,
              style: TextStyle(
                color: label == "Home" ? Colors.white : textColor,
                fontWeight: fontWeight,
                fontSize: label == "Home" ? 22 : 18,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF232323),
        ),
        child: Center(child: FaIcon(icon, color: Colors.white, size: 20)),
      ),
    );
  }
}
