import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_website/app/widgets/hero_section.dart';
import 'package:portfolio_website/app/widgets/sidebar_menu.dart';
import 'package:portfolio_website/app/modules/home/controllers/home_controller.dart';

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
        backgroundColor: Colors.black,
      )
          : null,
      body: Row(
        children: [
          if (!isMobile) SidebarMenu(),
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
                    child: const SizedBox(height: 600, child: Center(child: Text('About', style: TextStyle(color: Colors.white)))),
                  ), KeyedSubtree(
                    key: controller.sectionKeys['resume'],
                    child: const SizedBox(height: 600, child: Center(child: Text('Resume', style: TextStyle(color: Colors.white)))),
                  ),
                  KeyedSubtree(
                    key: controller.sectionKeys['portfolio'],
                    child: const SizedBox(height: 600, child: Center(child: Text('portfolio', style: TextStyle(color: Colors.white)))),
                  ), KeyedSubtree(
                    key: controller.sectionKeys['services'],
                    child: const SizedBox(height: 600, child: Center(child: Text('services', style: TextStyle(color: Colors.white)))),
                  ),
                  KeyedSubtree(
                    key: controller.sectionKeys['contact'],
                    child: const SizedBox(height: 600, child: Center(child: Text('contact', style: TextStyle(color: Colors.white)))),
                  ),
                  // Add more sections here...
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
