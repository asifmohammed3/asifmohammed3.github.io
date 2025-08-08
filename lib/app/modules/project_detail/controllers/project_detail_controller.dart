import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/api_models/portfolio_models.dart';
import '../../home/controllers/home_controller.dart';

class ProjectDetailController extends GetxController {
  //TODO: Implement ProjectDetailController

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    Get.lazyPut(() => HomeController());
    final Project? project = Get.arguments as Project?;
  }

  final ProjectDetail projectDetail = ProjectDetail(
    id: 'proj1',
    title: 'Enterprise Web Application',
    description:
        'A scalable enterprise-grade web application built with modern technologies that supports thousands of concurrent users and integrates complex business logic.',
    imgUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
    type: PortfolioTab.professional,
    client: 'Victoria Technologies',
    date: '01 March, 2024',
    projectUrl: 'https://www.victoriatech.com',
    keyFeatures: [
      Feature(
        icon: Icons.design_services_outlined,
        title: 'Modern UI/UX',
        description: 'Clean, intuitive, and responsive design for all devices.',
      ),
      Feature(
        icon: Icons.security_outlined,
        title: 'Advanced Security',
        description: 'Robust authentication and authorization mechanisms.',
      ),
      Feature(
        icon: Icons.cloud,
        title: 'Cloud Native',
        description: 'Deployed on AWS with full CI/CD pipelines.',
      ),
      Feature(
        icon: Icons.analytics_outlined,
        title: 'Real-time Analytics',
        description: 'User behavior tracked and analyzed in real-time.',
      ),
    ],
  );

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
