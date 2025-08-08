import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}
