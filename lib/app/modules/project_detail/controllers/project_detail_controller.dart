import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/api_models/portfolio_models.dart';
import '../../home/controllers/home_controller.dart';

class ProjectDetailController extends GetxController {
  // Observables for project detail
  final projectDetail = Rxn<ProjectDetail>();
  final isLoading = false.obs;
  final error = RxnString();

  final supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    fetchProjectDetail();
  }

  Future<void> fetchProjectDetail() async {
    final Project? project = Get.arguments as Project?;

    // If not project is passed, exit with error.
    if (project == null) {
      error.value = "No project data was provided.";
      return;
    }

    // If you only need what's in the Project, assign a minimal detail:
    projectDetail.value = ProjectDetail(
      id: project.id,
      title: project.title,
      description: project.description,
      imgUrl: project.imgUrl,
      type: project.type,
      client: '',
      // if not in Project, load below from Supabase
      date: '',
      projectUrl: '',
      keyFeatures: [],
    );

    isLoading.value = true;

    try {
      // Example: fetch more details from 'project_details' table by project id
      final res = await supabase
          .from('project_details')
          .select()
          .eq('project_id', project.id)
          .maybeSingle();

      if (res != null) {
        // Map fields as per your DB columns
        List<Feature> features = [];
        if (res['features'] != null && res['features'] is List<dynamic>) {
          features = (res['features'] as List<dynamic>).map((f) {
            return Feature(
              icon: _stringToIcon(f['icon']),
              title: f['title'] ?? '',
              description: f['description'] ?? '',
            );
          }).toList();
        }

        projectDetail.value = ProjectDetail(
          id: project.id,
          title: res['title'] ?? project.title,
          description: res['description'] ?? project.description,
          imgUrl: res['img_url'] ?? project.imgUrl,
          type: project.type,
          client: res['client'] ?? '',
          date: res['date'] ?? '',
          projectUrl: res['project_url'] ?? '',
          keyFeatures: features,
        );
      }

      error.value = null;
    } catch (e) {
      error.value = "Failed to load project details: $e";
    } finally {
      isLoading.value = false;
    }
  }

  // Example: Map a string from DB to an IconData
  IconData _stringToIcon(String? iconName) {
    switch (iconName) {
      case 'design_services_outlined':
        return Icons.design_services_outlined;
      case 'security_outlined':
        return Icons.security_outlined;
      case 'cloud':
        return Icons.cloud;
      case 'analytics_outlined':
        return Icons.analytics_outlined;
      // add more mappings as needed
      default:
        return Icons.star_outline;
    }
  }
}
