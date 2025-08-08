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

import '../../../widgets/LinedTitle.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1000;

    return Scaffold(
      backgroundColor: Colors.black,
      drawer: isMobile ? SidebarMenu() : null,

      appBar: isMobile
          ? AppBar(
              title: const Text('Portfolio'),
              backgroundColor: const Color.fromARGB(255, 40, 39, 39),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
