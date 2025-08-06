import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final scrollController = ScrollController();
  final currentSection = 'home'.obs;

  final sectionKeys = {
    'home': GlobalKey(),
    'about': GlobalKey(),
    'resume': GlobalKey(),
    'portfolio': GlobalKey(),
    'services': GlobalKey(),
    'contact': GlobalKey(),
  };

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    for (var entry in sectionKeys.entries) {
      final ctx = entry.value.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox;
        final offset = box.localToGlobal(Offset.zero).dy;
        if (offset <= 100) {
          currentSection.value = entry.key;
        }
      }
    }
  }

  void scrollToSection(String section) {
    final key = sectionKeys[section];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}
