import 'dart:convert';
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

  // Portfolio tab selection for filtering
  final selectedPortfolioTab = PortfolioTab.all.obs;

  // Animation controllers for hero section bubble effect
  late final AnimationController bubbleController;
  late final Animation<double> bubbleAnimation1;
  late final Animation<double> bubbleAnimation2;

  // Contact form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  // Section keys for scrolling
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

  // Loading and error states
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  Future<void> onInit() async {
    super.onInit();
    scrollController.addListener(_handleScroll);

    // Bubble animations for hero section
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

  /// Get resumeId of the currently active resume (single-admin, no user_id)
  Future<String?> _getActiveResumeId() async {
    final res = await supabase
        .from('resumes')
        .select('id')
        .eq('is_active', true)
        .maybeSingle();

    if (res == null) {
      log('⚠️ No active resume found');
      return null;
    }
    log('✅ Active resume id: ${res['id']}');
    return res['id'] as String;
  }

  /// Handle nav highlight based on scroll
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

  /// Scroll to given section
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

  /// Returns projects filtered by the selected tab
  List<Project> get filteredProjects {
    final tab = selectedPortfolioTab.value;
    return tab == PortfolioTab.all
        ? projects
        : projects.where((p) => p.type == tab).toList();
  }

  /// Loads all sections
  Future<void> loadAllData() async {
    errorMessage.value = null;
    isLoading.value = true;
    Loader.instance.show();

    try {
      await Future.wait([
        fetchHeroSection(),
        fetchProfile(),
        fetchSkills(),
        fetchResumeSection(),
        fetchContactItems(),
        fetchProjects(),
      ]);
    } catch (e, st) {
      log("❌ Error loading data", error: e, stackTrace: st);
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      Loader.instance.hide();
    }
  }

  /// Hero section comes from active resume's profile
  Future<void> fetchHeroSection() async {
    final resumeId = await _getActiveResumeId();
    if (resumeId == null) return;

    final res = await supabase
        .from('profiles')
        .select()
        .eq('resume_id', resumeId)
        .maybeSingle();

    if (res == null) {
      log('⚠️ No profile for hero section of resume $resumeId');
      return;
    }

    heroSection.value = HeroSectionModel(
      name: res['name'] ?? '',
      animatedRoles: List<String>.from(res['animated_roles'] ?? []),
      description: res['description'] ?? '',
      profileImageUrl: res['image_url'] ?? '',
    );
  }

  /// Profile data + stats
  Future<void> fetchProfile() async {
    final resumeId = await _getActiveResumeId();
    if (resumeId == null) return;

    final res = await supabase
        .from('profiles')
        .select()
        .eq('resume_id', resumeId)
        .maybeSingle();

    if (res == null) {
      log('⚠️ No profile found for resume $resumeId');
      return;
    }

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

  /// Skills for active resume
  Future<void> fetchSkills() async {
    final resumeId = await _getActiveResumeId();
    if (resumeId == null) return;

    final res = await supabase
        .from('skills')
        .select()
        .eq('resume_id', resumeId);

    skills.value = (res as List<dynamic>)
        .map((e) => Skill(label: e['label'], level: e['level'] ?? 0))
        .toList();
  }

  /// Resume section: experiences, educations, certifications
  Future<void> fetchResumeSection() async {
    final resumeId = await _getActiveResumeId();
    if (resumeId == null) return;

    if (profileData.value == null) {
      await fetchProfile();
    }

    final res = await supabase
        .from('resumes')
        .select()
        .eq('id', resumeId)
        .maybeSingle();
    if (res == null) {
      log('⚠️ No resume row found for id $resumeId');
      return;
    }

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

  /// Contact info (global)
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

  /// Utility to map contact icons
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

  /// Projects for active resume
  Future<void> fetchProjects() async {
    final resumeId = await _getActiveResumeId();
    if (resumeId == null) return;

    final res = await supabase
        .from('projects')
        .select()
        .eq('resume_id', resumeId)
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

  /// Map project type to enum
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

  /// Set filter tab for projects
  void setPortfolioTab(PortfolioTab tab) {
    selectedPortfolioTab.value = tab;
  }




  bool validateForm() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Name cannot be empty");
      return false;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar("Error", "Enter a valid email address");
      return false;
    }
    if (subjectController.text.trim().isEmpty) {
      Get.snackbar("Error", "Subject cannot be empty");
      return false;
    }
    if (messageController.text.trim().isEmpty) {
      Get.snackbar("Error", "Message cannot be empty");
      return false;
    }
    return true;
  }



  Future<void> sendContactEmail() async {
    if (!validateForm()) return;

    isLoading.value = true;
    Loader.instance.show();

    try {
      final body = {
        'from': 'no-reply@mohammedasif.in',
        'to': 'mohammedasifparambil@gmail.com',
        'subject': subjectController.text.trim(),
        'html': """
<div style="font-family: Arial, sans-serif; color: #333; line-height: 1.5; max-width: 600px; margin: auto; padding: 20px; background-color: #f9f9f9; border-radius: 8px;">
  <h2 style="color: #2C0000; border-bottom: 2px solid #2C0000; padding-bottom: 8px; margin-bottom: 20px; font-weight: 600;">New Contact Message</h2>
  <p><strong>Name:</strong> <span style="color: #555;">${nameController.text.trim()}</span></p>
  <p><strong>Email:</strong> <a href="mailto:${emailController.text.trim()}" style="color: #2C0000; text-decoration: none;">${emailController.text.trim()}</a></p>
  <p><strong>Subject:</strong> <span style="color: #555;">${subjectController.text.trim()}</span></p>
  <hr style="border: none; border-top: 1px solid #ddd; margin: 20px 0;" />
  <p style="white-space: pre-line; font-size: 15px;">${messageController.text.trim()}</p>
</div>
      """
      };


      print("Request body: ${jsonEncode(body)}");

      final response = await supabase.functions.invoke(
        'resend-email',
        body: body, // Let Supabase handle JSON encoding
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print("Response status: ${response.status}");
      print("Response data: ${response.data}");

      Loader.instance.hide();

      if (response.status >= 200 && response.status < 300) {
        Get.snackbar("Success", "Message sent successfully!");
        nameController.clear();
        emailController.clear();
        subjectController.clear();
        messageController.clear();
      } else {
        String errorMsg = "Failed to send message";

        if (response.data != null) {
          if (response.data is Map<String, dynamic>) {
            errorMsg = response.data['error']?.toString() ??
                response.data['message']?.toString() ??
                errorMsg;
          } else {
            errorMsg = response.data.toString();
          }
        }

        print("Error response: $errorMsg");
        Get.snackbar("Error", errorMsg);
      }
    } catch (e, stackTrace) {
      Loader.instance.hide();
      print("Exception caught: $e");
      print("Stack trace: $stackTrace");

      String userMessage = "Failed to send message. Please try again.";

      // More specific error messages based on the exception
      if (e.toString().contains('NetworkException') ||
          e.toString().contains('SocketException')) {
        userMessage = "Network error. Please check your connection.";
      } else if (e.toString().contains('TimeoutException')) {
        userMessage = "Request timed out. Please try again.";
      } else if (e.toString().contains('FormatException')) {
        userMessage = "Invalid server response. Please try again.";
      }

      Get.snackbar("Error", userMessage);
    } finally {
      isLoading.value = false;
    }
  }



}
