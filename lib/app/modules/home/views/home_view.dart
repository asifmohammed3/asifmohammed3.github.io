import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_website/app/modules/home/views/about_section.dart';
import 'package:portfolio_website/app/modules/home/views/contact_section.dart';
import 'package:portfolio_website/app/modules/home/views/hero_section.dart';
import 'package:portfolio_website/app/modules/home/views/portfolio_section.dart';
import 'package:portfolio_website/app/modules/home/views/resume_section.dart';
import 'package:portfolio_website/app/widgets/sidebar_menu.dart';
import 'package:portfolio_website/app/modules/home/controllers/home_controller.dart';
import 'package:portfolio_website/app/modules/home/views/skills_section.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/custom_hamburger.dart';
import '../../../widgets/footer.dart';
import '../../../widgets/slide_in_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1000;

    return Obx(() {
      // Access observable variables here explicitly:
      final isLoading = controller.isLoading.value;
      final hasData =
          controller.resumeSectionData.value != null &&
          controller.profileData.value != null;

      if (!hasData && !isLoading) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "No Resume has been assigned or data is incomplete",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.ADMIN_AUTH);
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
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
              ],
            ),
          ),
        );
      }

      // When data is loaded, show the main content
      return Scaffold(
        backgroundColor: Colors.black,
        drawer: isMobile ? SidebarMenu() : null,
        appBar: isMobile
            ? AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                actions: const [CustomHamburger()],
                elevation: 0,
              )
            : null,
        body: Row(
          children: [
            if (!isMobile) SidebarMenu().paddingAll(24),
            Expanded(
              child: SingleChildScrollView(
                controller: controller.scrollController,
                child: Column(
                  children: [
                    KeyedSubtree(
                      key: controller.sectionKeys['home'],
                      child: const HeroSection(),
                    ),
                    KeyedSubtree(
                      key: controller.sectionKeys['about'],
                      child: ProfileCard(),
                    ),
                    KeyedSubtree(
                      key: controller.sectionKeys['skills'],
                      child: SkillsSection(),
                    ),
                    KeyedSubtree(
                      key: controller.sectionKeys['resume'],
                      child: ResumeSection(),
                    ),
                    KeyedSubtree(
                      key: controller.sectionKeys['portfolio'],
                      child: const PortfolioSection(),
                    ),
                    KeyedSubtree(
                      key: controller.sectionKeys['contact'],
                      child: ContactSection(),
                    ),
                    const SizedBox(height: 40),
                    Footer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
