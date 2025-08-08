import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:portfolio_website/app/modules/home/controllers/home_controller.dart';

class SidebarMenu extends StatelessWidget {
  SidebarMenu({super.key});
  final controller = Get.find<HomeController>();

  // Main navigation items
  final navItems = [
    _NavItemData("Home", FontAwesomeIcons.house),
    _NavItemData("About", FontAwesomeIcons.user),
    _NavItemData("Skills", FontAwesomeIcons.noteSticky),
    _NavItemData("Resume", FontAwesomeIcons.file),
    _NavItemData("Portfolio", FontAwesomeIcons.image),
    _NavItemData("Contact", FontAwesomeIcons.envelope),
  ];

  // Socials
  final socials = [
    FontAwesomeIcons.facebookF,
    FontAwesomeIcons.instagram,
    FontAwesomeIcons.linkedinIn,
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
            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...navItems.map((item) {
                  final isSelected = controller.currentSection.value.toLowerCase() == item.label.toLowerCase();
                  return _SidebarMenuItem(
                    label: item.label,
                    icon: item.icon,
                    isSelected: isSelected,
                    onTap: () {
                      controller.scrollToSection(item.label.toLowerCase());
                    },
                    // Add dropdown children if needed
                  );
                }),
              ],
            )),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: socials.map(
                  (icon) => _CircleIcon(icon: icon),
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final inactiveColor = const Color(0xFFB3B3B3);
    final activeColor = Colors.white;
    final textColor = isSelected ? activeColor : inactiveColor;
    final fontWeight =
        (isSelected || label == "Home") ? FontWeight.bold : FontWeight.normal;

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
                color: label == "Home"
                    ? Colors.white
                    : textColor,
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
  const _CircleIcon({required this.icon, Key? key}): super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44, height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF232323),
      ),
      child: Center(
        child: FaIcon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
