import 'package:flutter/material.dart';

enum PortfolioTab { all, professional, personal, academic }

class Project {
  final String id;
  final String title;
  final String description;
  final PortfolioTab type;
  final String imgUrl;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.imgUrl,
  });

  // Optional: factory constructor to parse from JSON from your API
  factory Project.fromJson(Map<String, dynamic> json) {
    // Map string type to PortfolioTab enum:
    PortfolioTab parseType(String typeStr) {
      switch (typeStr.toLowerCase()) {
        case 'professional':
          return PortfolioTab.professional;
        case 'personal':
          return PortfolioTab.personal;
        case 'academic':
          return PortfolioTab.academic;
        default:
          return PortfolioTab.all;
      }
    }

    return Project(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: parseType(json['type'] ?? ''),
      imgUrl: json['imgUrl'] ?? '',
    );
  }
}

class ProjectDetail {
  final String id;
  final String title;
  final String description;
  final String imgUrl;
  final PortfolioTab type;
  final String? client;
  final String? date;
  final String? projectUrl;
  final List<Feature> keyFeatures;

  ProjectDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.imgUrl,
    required this.type,
    this.client,
    this.date,
    this.projectUrl,
    this.keyFeatures = const [],
  });
}

class Feature {
  final IconData icon;
  final String title;
  final String description;

  Feature({required this.icon, required this.title, required this.description});

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      icon: stringToIcon(json['icon']),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  static IconData stringToIcon(String? iconName) {
    switch (iconName) {
    // Portfolio app icons
      case 'devices':
        return Icons.devices;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'dns':
        return Icons.dns;
      case 'sync':
        return Icons.sync;
      case 'admin_panel_settings':
        return Icons.admin_panel_settings_outlined;
      case 'bolt':
        return Icons.bolt;
      case 'security':
        return Icons.security; // General
      case 'architecture':
        return Icons.architecture;

    // COVIPLUS (health project) icons
      case 'cloud_upload':
        return Icons.cloud_upload;
      case 'insights':
        return Icons.insights;
      case 'dashboard':
        return Icons.dashboard;
      case 'notifications_active':
        return Icons.notifications_active;
      case 'chat_bubble_outline':
        return Icons.chat_bubble_outline;
      case 'privacy_tip':
        return Icons.privacy_tip;
      case 'devices_other':
        return Icons.devices_other;
      case 'autorenew':
        return Icons.autorenew;

    // Gesture Flow icons
      case 'pan_tool':
        return Icons.pan_tool;
      case 'volume_up':
        return Icons.volume_up;
      case 'volume_down':
        return Icons.volume_down;
      case 'brightness_6':
        return Icons.brightness_6;
      case 'volume_off':
        return Icons.volume_off;
      case 'fast_forward':
        return Icons.fast_forward;
      case 'fast_rewind':
        return Icons.fast_rewind;
      case 'play_arrow':
        return Icons.play_arrow;
      case 'arrow_downward':
        return Icons.arrow_downward;
      case 'arrow_upward':
        return Icons.arrow_upward;
      case 'keyboard_arrow_down':
        return Icons.keyboard_arrow_down;
      case 'keyboard_arrow_up':
        return Icons.keyboard_arrow_up;
      case 'science':
        return Icons.science;
      case 'visibility':
        return Icons.visibility;

    // Demo & legacy icons
      case 'design_services_outlined':
        return Icons.design_services_outlined;
      case 'security_outlined':
        return Icons.security_outlined;
      case 'analytics_outlined':
        return Icons.analytics_outlined;
      case 'cloud':
        return Icons.cloud;

    // Key Features (banking app project)
      case 'mobile_friendly':
        return Icons.mobile_friendly;
      case 'credit_card':
        return Icons.credit_card;
      case 'fingerprint':
        return Icons.fingerprint;
      case 'integration_instructions':
        return Icons.integration_instructions;
      case 'rocket_launch':
        return Icons.rocket_launch;
      case 'bug_report':
        return Icons.bug_report;
      case 'speed':
        return Icons.speed;
      case 'palette':
        return Icons.palette;

      default:
        return Icons.star_outline;
    }
  }

}
