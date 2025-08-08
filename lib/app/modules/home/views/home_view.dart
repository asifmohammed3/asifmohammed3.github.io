import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_website/app/widgets/about_section.dart';
import 'package:portfolio_website/app/widgets/contact_section.dart';
import 'package:portfolio_website/app/widgets/hero_section.dart';
import 'package:portfolio_website/app/widgets/resume_section.dart';
import 'package:portfolio_website/app/widgets/sidebar_menu.dart';
import 'package:portfolio_website/app/modules/home/controllers/home_controller.dart';
import 'package:portfolio_website/app/widgets/skills_section.dart';

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
                    child: ProfileCard()
                  ), 
                  KeyedSubtree(
                    key: controller.sectionKeys['skills'],
                    child: SkillsSection(),
                  ),
                  KeyedSubtree(
                    key: controller.sectionKeys['resume'],
                    child:Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const SizedBox(width: 12),
    
    // ✅ Wrap with fixed width
    const SizedBox(
      width: 360,
      child: ResumeProfileCard(),
    ),
    
    const SizedBox(width: 12),
    
    const Expanded(child: ResumeRightPanel()),
  ],
)

                  ),
                  KeyedSubtree(
                    key: controller.sectionKeys['portfolio'],
                    child: const SizedBox(height: 600, child: Center(child: Text('Portfolio', style: TextStyle(color: Colors.white)))),
                  ), 
                  KeyedSubtree(
                    key: controller.sectionKeys['contact'],
                    child: ContactSection(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
