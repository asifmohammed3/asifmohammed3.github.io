import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/api_models/portfolio_models.dart';
import '../../../models/models.dart';
import '../../../widgets/loader.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final scrollController = ScrollController();
  final currentSection = 'home'.obs;
  var selectedPortfolioTab = PortfolioTab.all.obs;

  late AnimationController bubbleController;
  late Animation<double> bubbleAnimation1;
  late Animation<double> bubbleAnimation2;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  final sectionKeys = <String, GlobalKey>{
    'home': GlobalKey(),
    'about': GlobalKey(),
    'skills': GlobalKey(),
    'resume': GlobalKey(),
    'portfolio': GlobalKey(),
    'contact': GlobalKey(),
  };

  final supabase = Supabase.instance.client;

  // Observables for dynamic data
  final heroSection = Rxn<HeroSectionModel>();
  final profileData = Rxn<ProfileModel>();
  final skills = <Skill>[].obs;
  final resumeSectionData = Rxn<ResumeSectionModel>();
  final contactItems = <ContactItemModel>[].obs;
  final projects = <Project>[].obs;

  // Loading and error handling
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  Future<void> onInit() async {
    super.onInit();
    scrollController.addListener(_handleScroll);

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

    await loadAllData();
  }

  @override
  void onClose() {
    bubbleController.dispose();
    scrollController.dispose();
    nameController.dispose();
    emailController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.onClose();
  }

  void _handleScroll() {
    double minOffset = double.infinity;
    String? closestSection;

    for (final entry in sectionKeys.entries) {
      final ctx = entry.value.currentContext;
      if (ctx == null) continue;

      final box = ctx.findRenderObject() as RenderBox;
      final offset = box.localToGlobal(Offset.zero).dy;

      if (offset <= 150 && offset.abs() < minOffset) {
        minOffset = offset.abs();
        closestSection = entry.key;
      }
    }

    if (closestSection != null && currentSection.value != closestSection) {
      currentSection.value = closestSection;
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

  List<Project> get filteredProjects {
    final tab = selectedPortfolioTab.value;
    return tab == PortfolioTab.all
        ? projects
        : projects.where((p) => p.type == tab).toList();
  }

  /// Load all data concurrently and handle errors/loading UI
  Future<void> loadAllData() async {
    errorMessage.value = null;
    isLoading.value = true;

    try {
      Loader.instance.show();
      await Future.wait([
        fetchHeroSection(),
        fetchProfile(),
        fetchSkills(),
        fetchResumeSection(),
        fetchContactItems(),
        fetchProjects(),
      ]);
    } catch (e, st) {
      log("Error loading data", error: e, stackTrace: st);
      errorMessage.value = e.toString();
      Loader.instance.hide();
    } finally {
      isLoading.value = false;
      Loader.instance.hide();
    }
  }

  Future<void> fetchHeroSection() async {
    final res = await supabase.from('profiles').select().maybeSingle();
    if (res == null) return;

    heroSection.value = HeroSectionModel(
      name: res['name'] ?? '',
      animatedRoles: List<String>.from(res['animated_roles'] ?? []),
      description: res['description'] ?? '',
      profileImageUrl: res['image_url'] ?? '',
    );
  }

  Future<void> fetchProfile() async {
    final res = await supabase.from('profiles').select().maybeSingle();
    if (res == null) return;

    // Fetch stats related to this profile (assume 'id' exists on profiles)
    final profileId = res['id'];
    List<StatItem> stats = [];

    if (profileId != null) {
      final statsRes = await supabase
          .from('stats')
          .select()
          .eq('profile_id', profileId);

      stats =
          (statsRes as List<dynamic>?)
              ?.map(
                (s) =>
                    StatItem(label: s['label'] ?? '', value: s['value'] ?? ''),
              )
              .toList() ??
          [];
    }

    profileData.value = ProfileModel(
      name: res['name'] ?? '',
      title: res['title'] ?? '',
      imageUrl: res['image_url'] ?? '',
      email: res['email'] ?? '',
      phone: res['phone'] ?? '',
      location: res['location'] ?? '',
      tagLine: res['tag_line'] ?? '',
      heading: res['heading'] ?? '',
      description: res['description'] ?? '',
      stats: stats,
      resumeInfo: ResumeInfo(
        specialization: res['specialization'] ?? '',
        education: res['education'] ?? '',
        experienceLevel: res['experience_level'] ?? '',
        languages: res['languages'] ?? '',
      ),
    );
  }

  Future<void> fetchSkills() async {
    final res = await supabase.from('skills').select();
    skills.value = (res as List<dynamic>)
        .map((e) => Skill(label: e['label'], level: e['level'] ?? 0))
        .toList();
  }

  Future<void> fetchResumeSection() async {
    if (profileData.value == null) {
      await fetchProfile();
    }

    final res = await supabase.from('resumes').select().maybeSingle();
    if (res == null) return;

    final resumeId = res['id'];

    final expsFuture = supabase
        .from('experiences')
        .select()
        .eq('resume_id', resumeId)
        .order('duration', ascending: false);

    final edusFuture = supabase
        .from('educations')
        .select()
        .eq('resume_id', resumeId)
        .order('year', ascending: false);

    final certsFuture = supabase
        .from('certifications')
        .select()
        .eq('resume_id', resumeId)
        .order('year', ascending: false);

    final results = await Future.wait([expsFuture, edusFuture, certsFuture]);

    final experiencesList =
        (results[0] as List<dynamic>?)
            ?.map(
              (e) => Experience(
                company: e['company'] ?? '',
                role: e['role'] ?? '',
                duration: e['duration'] ?? '',
                description: e['description'] ?? '',
              ),
            )
            .toList() ??
        [];

    final educationsList =
        (results[1] as List<dynamic>?)
            ?.map(
              (e) => Education(
                degree: e['degree'] ?? '',
                institution: e['institution'] ?? '',
                year: e['year'] ?? '',
                description: e['description'] ?? '',
              ),
            )
            .toList() ??
        [];

    final certificationsList =
        (results[2] as List<dynamic>?)
            ?.map(
              (e) =>
                  Certification(title: e['title'] ?? '', year: e['year'] ?? ''),
            )
            .toList() ??
        [];

    resumeSectionData.value = ResumeSectionModel(
      subtitle: res['subtitle'] ?? '',
      profile: profileData.value!,
      experiences: experiencesList,
      educations: educationsList,
      certifications: certificationsList,
    );
  }

  Future<void> fetchContactItems() async {
    final res = await supabase.from('contact_infos').select();
    contactItems.value = (res as List<dynamic>)
        .map(
          (e) => ContactItemModel(
            icon: _mapIconFromString(e['icon']),
            title: e['title'] ?? '',
            text: e['text'] ?? '',
          ),
        )
        .toList();
  }

  IconData _mapIconFromString(String? iconStr) {
    switch (iconStr?.toLowerCase()) {
      case 'email':
        return Icons.email_outlined;
      case 'phone':
        return Icons.phone_outlined;
      case 'location':
        return Icons.location_on_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Future<void> fetchProjects() async {
    final res = await supabase
        .from('projects')
        .select()
        .order('date', ascending: false);

    projects.value = (res as List<dynamic>).map((e) {
      return Project(
        id: e['id'].toString(),
        title: e['title'] ?? '',
        description: e['description'] ?? '',
        type: _mapStringToPortfolioTab(e['type'] ?? 'all'),
        imgUrl: e['img_url'] ?? '',
      );
    }).toList();
  }

  PortfolioTab _mapStringToPortfolioTab(String type) {
    switch (type.toLowerCase()) {
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

  void setPortfolioTab(PortfolioTab tab) {
    selectedPortfolioTab.value = tab;
  }
}
