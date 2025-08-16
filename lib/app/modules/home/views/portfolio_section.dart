import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_website/app/routes/app_pages.dart';

import '../../../data/api_models/portfolio_models.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/LinedTitle.dart';
import '../../../widgets/slide_in_widget.dart';
import '../controllers/home_controller.dart';

class PortfolioSection extends GetView<HomeController> {
  const PortfolioSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        LinedTitle(text: "Portfolio"),
        const SizedBox(height: 8),
        Text(
          "Welcome to my portfolio, where I proudly present a curated collection of projects spanning my professional career, academic achievements, and personal passion projects. Each project demonstrates my diverse skills in Flutter development and GetX state management, reflecting a commitment to quality, innovation, and practical solutions.",
          // Replace with your description
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 16),

        // Responsive layout selector
        Obx(
          () => Responsive(
            mobile: _buildMobileLayout(),
            tablet: _buildTabletLayout(),
            desktop: _buildDesktopLayout(),
          ),
        ),
      ],
    );
  }

  // Mobile layout: sidebar as horizontal scroll tabs + project grid below
  Widget _buildMobileLayout() {
    final projects = controller.filteredProjects;

    return Column(
      children: [
        SizedBox(height: 60, child: _buildMobileTabs()),

        const SizedBox(height: 16),
        if (projects.isEmpty)
          Center(
            child: Text(
              'No projects found.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: projects.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final project = projects[index];
                return SlideOnVisibility(
                  fromOffset: const Offset(0.0, 0.13),
                  duration: const Duration(milliseconds: 640),
                  child: _projectCard(project),
                );
              },
            ),
          ),

      ],
    );
  }

  // Tablet layout: sidebar vertical + project grid next to it
  Widget _buildTabletLayout() {
    final projects = controller.filteredProjects;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 190,
          color: Colors.black87,
          child: SlideOnVisibility(
            fromOffset: Offset(-0.2, 0),
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
        ),
        Expanded(
          child: projects.isEmpty
              ? Center(
                  child: Text(
                    'No projects found.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: projects.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.2,
                        ),
                    itemBuilder: (context, index) =>
                        SlideOnVisibility(
                            fromOffset: Offset(0.2, 0),child: _projectCard(projects[index])),
                  ),
                ),
        ),
      ],
    );
  }

  // Desktop layout: same as tablet but with more columns in grid
  Widget _buildDesktopLayout() {
    final projects = controller.filteredProjects;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Expanded(
          child: projects.isEmpty
              ? Center(
                  child: Text(
                    'No projects found.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: projects.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) =>
                        _projectCard(projects[index]),
                  ),
                ),
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
          margin: const EdgeInsets.all(8),
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

  Widget _buildMobileTabs() {
    final tabs = [
      {"title": "All Projects", "tab": PortfolioTab.all},
      {"title": "Professional", "tab": PortfolioTab.professional},
      {"title": "Personal", "tab": PortfolioTab.personal},
      {"title": "Academic", "tab": PortfolioTab.academic},
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: tabs.map((tabData) {
          return _tabItemMobile(
            tabData["title"]! as String,
            tabData["tab"]! as PortfolioTab,
          );
        }).toList(),
      ),
    );
  }

  Widget _tabItemMobile(String title, PortfolioTab tab) {
    return Obx(() {
      final isSelected = controller.selectedPortfolioTab.value == tab;
      return GestureDetector(
        onTap: () => controller.setPortfolioTab(tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.black87,
            border: Border.all(
              color: isSelected ? Colors.white : Colors.white30,
              width: isSelected ? 2.5 : 1.2,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.white24,
                      blurRadius: 12,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white70,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
              fontSize: 16,
            ),
            child: Text(title),
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
            Positioned.fill(
              child: Image.network(project.imgUrl, fit: BoxFit.cover),
            ),
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
            Positioned(
              left: 24,
              bottom: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  Text(
                    project.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
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
