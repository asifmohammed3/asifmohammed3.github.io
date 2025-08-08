import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/api_models/portfolio_models.dart';
import '../../../models/models.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final scrollController = ScrollController();
  final currentSection = 'home'.obs;

  var selectedPortfolioTab = PortfolioTab.all.obs;

  void setPortfolioTab(PortfolioTab tab) {
    selectedPortfolioTab.value = tab;
  }

  late AnimationController bubbleController;
  late Animation<double> bubbleAnimation1;
  late Animation<double> bubbleAnimation2;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  final sectionKeys = {
    'home': GlobalKey(),
    'about': GlobalKey(),
    'skills': GlobalKey(),
    'resume': GlobalKey(),
    'portfolio': GlobalKey(),
    'services': GlobalKey(),
    'contact': GlobalKey(),
  };

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);

    bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    bubbleAnimation1 = Tween<double>(begin: 0, end: 30).animate(
      CurvedAnimation(parent: bubbleController, curve: Curves.easeInOut),
    );

    bubbleAnimation2 = Tween<double>(begin: 0, end: 60).animate(
      CurvedAnimation(parent: bubbleController, curve: Curves.easeInOut),
    );
  }

  @override
  void onClose() {
    bubbleController.dispose();
    scrollController.dispose();
    super.onClose();
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

  //Home Section
  final heroSection = HeroSectionModel(
    name: "Mohammed Asif",
    animatedRoles: ["Flutter Dev", "UI/UX Designer", "Full Stack Dev"],
    description:
        "Passionate about creating exceptional digital experiences that\n"
        "blend innovative design with functional development. Let's bring your vision to life.",
    profileImageUrl:
        "https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg",
  );

  //About section
  final profileData = ProfileModel(
    name: "Marcus Thompson",
    title: "Creative Director & Developer",
    imageUrl:
        "https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg",
    email: "marcus@example.com",
    phone: "+1 (555) 123-4567",
    location: "San Francisco, CA",
    tagLine: "Get to Know Me",
    heading: "Passionate About Creating Digital Experiences",
    description:
        "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium... (your text here)",
    stats: [
      StatItem(label: "Projects Completed", value: "150+"),
      StatItem(label: "Years Experience", value: "5+"),
      StatItem(label: "Client Satisfaction", value: "98%"),
    ],
    resumeInfo: ResumeInfo(
      specialization: "UI/UX Design & Development",
      education: "Computer Science, MIT",
      experienceLevel: "Senior Professional",
      languages: "English, Spanish, French",
    ),
  );

  //Skill Section
  final skills = [
    Skill(label: "HTML/CSS", level: 95),
    Skill(label: "JavaScript", level: 85),
    Skill(label: "React", level: 80),
    Skill(label: "Node.js", level: 75),
    Skill(label: "Python", level: 70),
    Skill(label: "SQL", level: 65),
  ];

  final List<ContactItemModel> contactItems = [
    ContactItemModel(
      icon: Icons.location_on_outlined,
      title: "Our Location",
      text: "A108 Adam Street\nNew York, NY 535022",
    ),
    ContactItemModel(
      icon: Icons.phone_outlined,
      title: "Phone Number",
      text: "+1 5589 55488 55\n+1 6678 254445 41",
    ),
    ContactItemModel(
      icon: Icons.email_outlined,
      title: "Email Address",
      text: "info@example.com\ncontact@example.com",
    ),
  ];

  final resumeSectionData = ResumeSectionModel(
    subtitle:
        "Magnam dolores commodi suscipit. Necessitatibus eius consequatur ex aliquid fuga eum quidem...",
    profile: ProfileModel(
      name: "Marcus Thompson",
      title: "Creative Director & Developer",
      imageUrl:
          "https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg",
      email: "marcus@example.com",
      phone: "+1 (555) 123-4567",
      location: "San Francisco, CA",
      tagLine: "Get to Know Me",
      heading: "Passionate About Creating Digital Experiences",
      description:
          "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium... (your text here)",
      stats: [
        StatItem(label: "Projects Completed", value: "150+"),
        StatItem(label: "Years Experience", value: "5+"),
        StatItem(label: "Client Satisfaction", value: "98%"),
      ],
      resumeInfo: ResumeInfo(
        specialization: "UI/UX Design & Development",
        education: "Computer Science, MIT",
        experienceLevel: "Senior Professional",
        languages: "English, Spanish, French",
      ),
    ),
    experiences: [
      Experience(
        company: "Tech Innovations Inc.",
        role: "Senior Software Architect",
        duration: "2022 - Present",
        description:
            "Lead the architectural design and implementation of enterprise-scale applications. Mentor team of 12 developers and establish technical best practices. Drive adoption of microservices architecture and cloud-native solutions. Reduce system downtime by 75% through improved architecture and monitoring.",
      ),
      Experience(
        company: "Digital Solutions Corp.",
        role: "Lead Developer",
        duration: "2019 - 2022",
        description:
            "Spearheaded development of company’s flagship product reaching 1M+ users. Implemented CI/CD pipeline reducing deployment time by 60%. Managed team of 8 developers across multiple projects. Increased code test coverage from 45% to 90%.",
      ),
    ],
    educations: [
      Education(
        degree: "Master of Science in Computer Science",
        institution: "Stanford University",
        year: "2017 - 2019",
        description:
            "Specialized in Artificial Intelligence and Machine Learning. Graduated with honors.",
      ),
      Education(
        degree: "Bachelor of Science in Software Engineering",
        institution: "MIT",
        year: "2013 - 2017",
        description: "Dean’s List all semesters. Led university’s coding club.",
      ),
    ],
    certifications: [
      Certification(
        title: "AWS Certified Solutions Architect – Professional",
        year: "2023",
      ),
      Certification(title: "Google Cloud Professional Architect", year: "2022"),
    ],
  );

  // Sample static data for demonstration, replace this with data fetched from API
  final RxList<Project> projects = <Project>[
    Project(
      id: '1',
      title: 'Enterprise App',
      description: 'An enterprise scale solution for clients.',
      type: PortfolioTab.professional,
      imgUrl: 'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc',
    ),

    Project(
      id: '2',
      title: 'Personal Blog',
      description: 'My personal blog created with Flutter.',
      type: PortfolioTab.personal,
      imgUrl: 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b',
    ),
    Project(
      id: '3',
      title: 'University Project',
      description: 'Academic project on AI research.',
      type: PortfolioTab.academic,
      imgUrl: 'https://images.unsplash.com/photo-1485955900006-10f4d324d411',
    ),
    Project(
      id: '4',
      title: 'Open Source Library',
      description: 'Library for cross platform usage.',
      type: PortfolioTab.professional,
      imgUrl: 'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc',
    ),
  ].obs;

  /// Filter projects based on selected tab
  List<Project> get filteredProjects {
    if (selectedPortfolioTab.value == PortfolioTab.all) {
      return projects;
    }
    return projects
        .where((project) => project.type == selectedPortfolioTab.value)
        .toList();
  }

  /// TODO: add an API fetch method to populate `projects` dynamically
  Future<void> fetchProjectsFromAPI() async {
    // Call API, parse data, then update `projects` RxList
  }
}
