import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_website/app/routes/app_pages.dart';

import '../../../data/api_models/portfolio_models.dart';
import '../../../widgets/LinedTitle.dart';
import '../controllers/home_controller.dart';

class PortfolioSection extends GetView<HomeController> {
  const PortfolioSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50),

        LinedTitle(text: "Portfolio"),
        const SizedBox(height: 8),
        Text(
          "jadhfhsdfghsdvgf safhbsdhjf sdifhgbdshfg difhsdbf",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            // Sidebar
            Container(
              width: 190,
              color: Colors.black87,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _tabItem("All Projects", PortfolioTab.all),
                  _tabItem("Professional", PortfolioTab.professional),
                  _tabItem("Personal", PortfolioTab.personal),
                  _tabItem("Academic", PortfolioTab.academic),
                ],
              ),
            ),
            // Content panel
            Obx(() {
              final projects = controller.filteredProjects;
              if (projects.isEmpty) {
                return Center(
                  child: Text(
                    'No projects found.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                );
              }
              return Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  itemCount: projects.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Responsive columns
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2, // Card shape
                  ),
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    return _projectCard(project);
                  },
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _tabItem(String title, PortfolioTab tab) {
    return Obx(() {
      final isSelected = controller.selectedPortfolioTab.value == tab;
      return InkWell(
        onTap: () => controller.setPortfolioTab(tab),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white12 : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      );
    });
  }

  Widget _projectCard(Project project) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.network(project.imgUrl, fit: BoxFit.cover),
            ),
            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
            ),
            // Content
            Positioned(
              left: 24,
              bottom: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category tag
                  Text(
                    project.type.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Title
                  Text(
                    project.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Action buttons
                  Row(
                    children: [
                      // Arrow button
                      InkWell(
                        onTap: () {
                          Get.toNamed(
                            Routes.PROJECT_DETAIL,
                            arguments: project,
                          );
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
