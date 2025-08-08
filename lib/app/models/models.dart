// skill_model.dart
import 'package:flutter/material.dart';

class Skill {
  final String label;
  final int level; // out of 100

  Skill({required this.label, required this.level});
}

// experience_model.dart
class Experience {
  final String company;
  final String role;
  final String duration;
  final String description;

  Experience({
    required this.company,
    required this.role,
    required this.duration,
    required this.description,
  });
}

// education_model.dart
class Education {
  final String degree;
  final String institution;
  final String year;
  final String description;

  Education({
    required this.degree,
    required this.institution,
    required this.year,
    required this.description,
  });
}

class HeroSectionModel {
  final String name;
  final List<String> animatedRoles;
  final String description;
  final String profileImageUrl;

  HeroSectionModel({
    required this.name,
    required this.animatedRoles,
    required this.description,
    required this.profileImageUrl,
  });
}

class ProfileModel {
  final String name;
  final String title;
  final String imageUrl;
  final String email;
  final String phone;
  final String location;
  final String tagLine;
  final String heading;
  final String description;
  final List<StatItem> stats;
  final ResumeInfo resumeInfo;

  ProfileModel({
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.email,
    required this.phone,
    required this.location,
    required this.tagLine,
    required this.heading,
    required this.description,
    required this.stats,
    required this.resumeInfo,
  });
}

class StatItem {
  final String label;
  final String value;

  StatItem({required this.label, required this.value});
}

class ResumeInfo {
  final String specialization;
  final String education;
  final String experienceLevel;
  final String languages;

  ResumeInfo({
    required this.specialization,
    required this.education,
    required this.experienceLevel,
    required this.languages,
  });
}

class Certification {
  final String title;
  final String year;

  Certification({required this.title, required this.year});
}

class ResumeSectionModel {
  final String subtitle; // Description under "Resume"
  final ProfileModel profile;
  final List<Experience> experiences;
  final List<Education> educations;
  final List<Certification> certifications;

  ResumeSectionModel({
    required this.subtitle,
    required this.profile,
    required this.experiences,
    required this.educations,
    required this.certifications,
  });
}

class ContactItemModel {
  final IconData icon;
  final String title;
  final String text;

  ContactItemModel({
    required this.icon,
    required this.title,
    required this.text,
  });
}
