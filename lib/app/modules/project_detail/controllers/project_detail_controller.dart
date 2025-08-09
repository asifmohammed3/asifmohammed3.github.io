import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/api_models/portfolio_models.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/loader.dart';

class ProjectDetailController extends GetxController {
  final projectDetail = Rxn<ProjectDetail>();
  final isLoading = false.obs;
  final error = RxnString();

  final supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments == null) {
        Get.offAllNamed(Routes.HOME);
      }
    });
    fetchProjectDetail();
  }

  Future<void> fetchProjectDetail() async {
    final Project? project = Get.arguments as Project?;
    if (project == null) {
      error.value = "No project data was provided.";
      return;
    }

    projectDetail.value = ProjectDetail(
      id: project.id.toString(),
      title: project.title,
      description: project.description,
      imgUrl: project.imgUrl,
      type: project.type,
      client: '',
      date: '',
      projectUrl: '',
      keyFeatures: [],
    );

    isLoading.value = true;

    // ✅ Defer loader start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Loader.instance.show();
    });

    try {
      final res = await supabase
          .from('project_details')
          .select()
          .eq('project_id', project.id)
          .maybeSingle();

      if (res != null) {
        List<Feature> features = [];
        final featuresData = res['features'];

        if (featuresData is List) {
          features = featuresData
              .map<Feature>((f) => Feature.fromJson(f as Map<String, dynamic>))
              .toList();
        } else if (featuresData is String) {
          final decoded = jsonDecode(featuresData);
          if (decoded is List) {
            features = decoded
                .map<Feature>(
                  (f) => Feature.fromJson(f as Map<String, dynamic>),
                )
                .toList();
          }
        }

        projectDetail.value = ProjectDetail(
          id: (res['id'] ?? project.id).toString(),
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
      // ✅ Defer loader hide
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Loader.instance.hide();
      });
      isLoading.value = false;
    }
  }
}
