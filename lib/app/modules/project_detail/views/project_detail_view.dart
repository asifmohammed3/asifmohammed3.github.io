import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_website/app/modules/project_detail/controllers/project_detail_controller.dart';

import '../../../data/api_models/portfolio_models.dart';
import '../../../widgets/sidebar_menu.dart';

class ProjectDetailView extends GetView<ProjectDetailController> {
  const ProjectDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.projectDetail == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Persistent sidebar (your existing SidebarMenu)
            SidebarMenu().paddingAll(24),

            const SizedBox(width: 40),

            // Scrollable main content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Flexible(
                          child: _buildProjectImage(controller.projectDetail),
                        ),
                        const SizedBox(width: 40),
                        _buildProjectInfo(controller.projectDetail),
                      ],
                    ),
                    const SizedBox(height: 40),
                    _buildProjectOverview(controller.projectDetail),
                    const SizedBox(height: 40),
                    _buildKeyFeatures(controller.projectDetail),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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

  Widget _buildProjectImage(ProjectDetail project) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(project.imgUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
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

  Widget _buildKeyFeatures(ProjectDetail project) {
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
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
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

  Widget _buildProjectInfo(ProjectDetail project) {
    return Container(
      width: 300,
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
            width: 110, // Fixed width for all labels for consistent align
            child: Text(
              '$label',
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            ":",
            style: const TextStyle(
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
