import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_website/app/modules/project_detail/controllers/project_detail_controller.dart';

import '../../../data/api_models/portfolio_models.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/custom_hamburger.dart';
import '../../../widgets/sidebar_menu.dart';

class ProjectDetailView extends GetView<ProjectDetailController> {
  const ProjectDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1000;

    if (controller.projectDetail == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        appBar: isMobile
            ? AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false, // Remove default hamburger
                actions: [CustomHamburger()],
                elevation: 0,
              )
            : null,
        body: Center(
          child: Text(
            'No project data available.',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      drawer: Responsive.isMobile(context) ? SidebarMenu() : null,
      appBar: isMobile
          ? AppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false, // Remove default hamburger
              actions: [CustomHamburger()],
              elevation: 0,
            )
          : null,
      // Drawer only on mobile
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Responsive(
          mobile: _buildMobileContent(context),
          tablet: _buildTabletContent(context),
          desktop: _buildDesktopContent(context),
        ),
      ),
    );
  }

  // Mobile Layout: vertical stacking, sidebar as drawer
  Widget _buildMobileContent(BuildContext context) {
    final project = controller.projectDetail!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isMobile: true),
          const SizedBox(height: 20),
          _buildProjectImage(project, mobileMode: true),
          const SizedBox(height: 20),
          _buildProjectInfo(project),
          const SizedBox(height: 20),
          _buildProjectOverview(project),
          const SizedBox(height: 20),
          _buildKeyFeatures(project, isMobile: true),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  // Tablet Layout: sidebar visible + flexible content side-by-side
  Widget _buildTabletContent(BuildContext context) {
    final project = controller.projectDetail!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 200, child: SidebarMenu().paddingAll(24)),
        const SizedBox(width: 24),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Flexible(child: _buildProjectImage(project)),
                    const SizedBox(width: 30),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: _buildProjectInfo(project),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                _buildProjectOverview(project),
                const SizedBox(height: 30),
                _buildKeyFeatures(project),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Desktop Layout: wider sidebar + more spacious layout
  Widget _buildDesktopContent(BuildContext context) {
    final project = controller.projectDetail!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 280, child: SidebarMenu().paddingAll(24)),
        const SizedBox(width: 40),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Flexible(child: _buildProjectImage(project)),
                    const SizedBox(width: 40),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: _buildProjectInfo(project),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                _buildProjectOverview(project),
                const SizedBox(height: 40),
                _buildKeyFeatures(project),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // You can keep your existing implementations for these helper widgets,
  // adding optional parameters if you want to adjust image height or widths for different screens.

  Widget _buildHeader({bool isMobile = false}) {
    return isMobile
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Portfolio Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Text(
                      'Home',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                  const Text(
                    ' / ',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const Text(
                    'Portfolio Details',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Portfolio Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Text(
                      'Home',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                  const Text(
                    ' / ',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const Text(
                    'Portfolio Details',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ],
          );
  }

  Widget _buildProjectImage(ProjectDetail project, {bool mobileMode = false}) {
    return Container(
      height: mobileMode ? 240 : 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(project.imgUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProjectInfo(ProjectDetail project) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Project Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          _infoItem('Category', project.type.name.capitalize ?? ''),
          const SizedBox(height: 20),
          _infoItem('Client', project.client ?? 'Unknown'),
          const SizedBox(height: 20),
          _infoItem('Project Date', project.date ?? 'Unknown'),
          const SizedBox(height: 20),
          _infoItem('Project URL', project.projectUrl ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            ':',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildProjectOverview(ProjectDetail project) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Project Overview',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 20),
      Text(
        project.description,
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 16,
          height: 1.6,
        ),
      ),
    ],
  );
}

Widget _buildKeyFeatures(ProjectDetail project, {bool isMobile = false}) {
  if (project.keyFeatures.isEmpty) return const SizedBox.shrink();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Key Features',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 30),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: project.keyFeatures.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile ? 1 : 2,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 2.5, // increase to make card wider than tall
        ),
        itemBuilder: (context, index) {
          final feature = project.keyFeatures[index];
          return _buildFeatureCard(
            feature.icon,
            feature.title,
            feature.description,
          );
        },
      ),
    ],
  );
}

Widget _buildFeatureCard(IconData icon, String title, String description) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF2A2A2A),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Minimizes vertical expansion
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ],
    ),
  );
}
