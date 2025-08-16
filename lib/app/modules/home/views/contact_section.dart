import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_website/app/modules/home/controllers/home_controller.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/LinedTitle.dart';

class ContactSection extends GetView<HomeController> {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        const LinedTitle(text: "Contact"),
        const SizedBox(height: 8),
        const Text(
          "Necessitatibus eius consequatur ex aliquid fuga eum quidem sint consectetur velit",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Responsive(
              mobile: _buildMobileLayout(),
              tablet: _buildTabletDesktopLayout(),
              desktop: _buildTabletDesktopLayout(),
            ),
          ),
        ),
        const SizedBox(height: 40),
        const Divider(color: Colors.white10),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _contactInfoCard(),
        const SizedBox(height: 32),
        _getInTouchForm(),
      ],
    ).paddingAll(24);
  }

  Widget _buildTabletDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(flex: 2, child: _contactInfoCard()),
        const SizedBox(width: 24),
        Flexible(flex: 3, child: _getInTouchForm()),
      ],
    ).paddingAll(24);
  }

  Widget _contactInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Contact Info",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C0000),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Praesent sapien massa, convallis a pellentesque nec, egestas non nisi. Vestibulum ante ipsum primis.",
            style: const TextStyle(color: Colors.black87),
          ),
          const SizedBox(height: 24),
          ...controller.contactItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: contactItem(item.icon, item.title, item.text),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getInTouchForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Get In Touch",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Praesent sapien massa, convallis a pellentesque nec, egestas non nisi. Vestibulum ante ipsum primis.",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: darkInputField("Your Name", controller.nameController),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: darkInputField("Your Email", controller.emailController),
              ),
            ],
          ),
          const SizedBox(height: 12),
          darkInputField("Subject", controller.subjectController),
          const SizedBox(height: 12),
          darkInputField("Message", controller.messageController, maxLines: 5),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                    controller.sendContactEmail();


              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF2C0000),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Send Message",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget contactItem(IconData icon, String title, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(icon, size: 28, color: const Color(0xFF2C0000)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget darkInputField(
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: const Color(0xFF333333),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
