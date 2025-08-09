import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../widgets/loader.dart';

class AdminMainController extends GetxController {
  final supabase = Supabase.instance.client;

  // Observable list of all resumes (for a single admin)
  final resumes = <Map<String, dynamic>>[].obs;
  final activeResumeId = RxnString();

  // Projects state
  final projects = <Map<String, dynamic>>[].obs;
  final selectedProjectId = RxnString();

  // === Profile Controllers ===
  final profile = Rxn<Map<String, dynamic>>();
  final nameCtrl = TextEditingController();
  final titleCtrl = TextEditingController();
  final imageUrlCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final tagLineCtrl = TextEditingController();
  final headingCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final specializationCtrl = TextEditingController();
  final educationCtrl = TextEditingController();
  final experienceLevelCtrl = TextEditingController();
  final languagesCtrl = TextEditingController();

  // Lists of section controllers
  final skillsCtrls = <Map<String, TextEditingController>>[].obs;
  final expCtrls = <Map<String, TextEditingController>>[].obs;
  final eduCtrls = <Map<String, TextEditingController>>[].obs;
  final certCtrls = <Map<String, TextEditingController>>[].obs;
  final projectCtrls = <Map<String, TextEditingController>>[].obs;
  final contactCtrls = <Map<String, TextEditingController>>[].obs;
  final projectDetailsCtrls = <Map<String, TextEditingController>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchResumes();
  }

  // Snackbar helper for green/red feedback
  void _showSnack(String message, {bool success = true}) {
    Get.snackbar(
      success ? 'Success' : 'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: success ? Colors.green : Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  // ===================== Resumes =====================
  Future<void> fetchResumes() async {
    try {
      Loader.instance.show();

      // Fetch all resumes for our single admin site
      final res = await supabase.from('resumes').select().order('created_at');

      resumes.assignAll(List<Map<String, dynamic>>.from(res));

      // Set active resume from DB (the one with is_active == true)
      final active = resumes.firstWhereOrNull((r) => r['is_active'] == true);
      if (active != null) {
        activeResumeId.value = active['id'];
        await fetchAllSections(active['id']);
      }
    } catch (e) {
      _showSnack('Failed to load resumes: $e', success: false);
    } finally {
      Loader.instance.hide();
    }
  }

  Future<void> addResume(String title, String subtitle) async {
    try {
      Loader.instance.show();

      // Insert a new resume, mark as active
      final inserted = await supabase
          .from('resumes')
          .insert({'title': title, 'subtitle': subtitle, 'is_active': true})
          .select()
          .maybeSingle();

      if (inserted != null) {
        // Set all OTHER resumes inactive (only one active at a time)
        await supabase
            .from('resumes')
            .update({'is_active': false})
            .neq('id', inserted['id']);

        activeResumeId.value = inserted['id'];
        await fetchAllSections(inserted['id']);
        await fetchResumes();

        _showSnack('Resume added & activated');
      }
    } catch (e) {
      _showSnack('Failed to add resume: $e', success: false);
    } finally {
      Loader.instance.hide();
    }
  }

  /// When admin selects a resume, set it active in DB, others inactive, and reload
  Future<void> setActiveResume(String resumeId) async {
    try {
      Loader.instance.show();

      await supabase
          .from('resumes')
          .update({'is_active': true})
          .eq('id', resumeId);

      await supabase
          .from('resumes')
          .update({'is_active': false})
          .neq('id', resumeId);

      activeResumeId.value = resumeId;
      await fetchAllSections(resumeId);
      await fetchResumes(); // Refresh list with updated active marker

      _showSnack('Active resume changed');
    } catch (e) {
      _showSnack('Failed to set active resume: $e', success: false);
    } finally {
      Loader.instance.hide();
    }
  }

  // ===================== Fetch All Related Sections =====================
  Future<void> fetchAllSections(String resumeId) async {
    try {
      Loader.instance.show();

      await fetchProfile(resumeId);

      await _fetchSection(resumeId, 'skills', ['label', 'level'], skillsCtrls);
      await _fetchSection(resumeId, 'experiences', [
        'company',
        'role',
        'duration',
        'description',
      ], expCtrls);
      await _fetchSection(resumeId, 'educations', [
        'degree',
        'institution',
        'year',
        'description',
      ], eduCtrls);
      await _fetchSection(resumeId, 'certifications', [
        'title',
        'year',
      ], certCtrls);
      await _fetchSection(resumeId, 'projects', [
        'title',
        'description',
        'type',
        'img_url',
        'project_url',
      ], projectCtrls);
      // Contact info is global (not resume specific)
      await _fetchSection(null, 'contact_infos', [
        'icon',
        'title',
        'text',
      ], contactCtrls);
    } catch (e) {
      _showSnack('Failed to fetch sections: $e', success: false);
    } finally {
      Loader.instance.hide();
    }
  }

  Future<void> fetchProfile(String resumeId) async {
    try {
      final res = await supabase
          .from('profiles')
          .select()
          .eq('resume_id', resumeId)
          .maybeSingle();

      if (res == null) {
        // Auto-create empty profile for new resume
        final inserted = await supabase
            .from('profiles')
            .insert({'resume_id': resumeId})
            .select()
            .maybeSingle();

        if (inserted != null) {
          profile.value = inserted;
        }
        return;
      }

      profile.value = res;
      nameCtrl.text = res['name'] ?? '';
      titleCtrl.text = res['title'] ?? '';
      imageUrlCtrl.text = res['image_url'] ?? '';
      emailCtrl.text = res['email'] ?? '';
      phoneCtrl.text = res['phone'] ?? '';
      locationCtrl.text = res['location'] ?? '';
      tagLineCtrl.text = res['tag_line'] ?? '';
      headingCtrl.text = res['heading'] ?? '';
      descriptionCtrl.text = res['description'] ?? '';
      specializationCtrl.text = res['specialization'] ?? '';
      educationCtrl.text = res['education'] ?? '';
      experienceLevelCtrl.text = res['experience_level'] ?? '';
      languagesCtrl.text = res['languages'] ?? '';
    } catch (e) {
      _showSnack('Failed to fetch profile: $e', success: false);
    }
  }

  Future<void> fetchProjectExtras(String projectId) async {
    try {
      Loader.instance.show();
      selectedProjectId.value = projectId;
      await _fetchSectionForProject(projectId, 'project_details', [
        'project_id',
        'title',
        'description',
        'img_url',
        'client',
        'date',
        'project_url',
        'features',
      ], projectDetailsCtrls);
    } catch (e) {
      _showSnack('Failed to load project extras: $e', success: false);
    } finally {
      Loader.instance.hide();
    }
  }

  // ===================== Save / Edit =====================
  Future<void> saveProfile() async {
    try {
      Loader.instance.show();

      // If no active resume, nothing to save
      if (activeResumeId.value == null) {
        _showSnack('No active resume to link profile', success: false);
        return;
      }

      if (profile.value == null) {
        // INSERT new profile for the active resume
        final inserted = await supabase
            .from('profiles')
            .insert({
              'resume_id': activeResumeId.value,
              'name': nameCtrl.text,
              'title': titleCtrl.text,
              'image_url': imageUrlCtrl.text,
              'email': emailCtrl.text,
              'phone': phoneCtrl.text,
              'location': locationCtrl.text,
              'tag_line': tagLineCtrl.text,
              'heading': headingCtrl.text,
              'description': descriptionCtrl.text,
              'specialization': specializationCtrl.text,
              'education': educationCtrl.text,
              'experience_level': experienceLevelCtrl.text,
              'languages': languagesCtrl.text,
            })
            .select()
            .maybeSingle();

        if (inserted != null) {
          profile.value = inserted;
          _showSnack('Profile created successfully');
        } else {
          _showSnack('Failed to create profile', success: false);
        }
      } else {
        // UPDATE existing profile
        await supabase
            .from('profiles')
            .update({
              'name': nameCtrl.text,
              'title': titleCtrl.text,
              'image_url': imageUrlCtrl.text,
              'email': emailCtrl.text,
              'phone': phoneCtrl.text,
              'location': locationCtrl.text,
              'tag_line': tagLineCtrl.text,
              'heading': headingCtrl.text,
              'description': descriptionCtrl.text,
              'specialization': specializationCtrl.text,
              'education': educationCtrl.text,
              'experience_level': experienceLevelCtrl.text,
              'languages': languagesCtrl.text,
            })
            .eq('id', profile.value!['id']);

        _showSnack('Profile updated successfully');
      }
    } catch (e) {
      _showSnack('Failed to save profile: $e', success: false);
    } finally {
      Loader.instance.hide();
    }
  }

  Future<void> saveSection(
    String table,
    List<String> fields,
    RxList<Map<String, TextEditingController>> ctrls,
  ) async {
    try {
      Loader.instance.show();
      for (var ctrlMap in ctrls) {
        final data = {for (final f in fields) f: ctrlMap[f]!.text};
        await supabase.from(table).update(data).eq('id', ctrlMap['id']!.text);
      }
      _showSnack('$table saved successfully');
    } catch (e) {
      _showSnack('Failed to save $table: $e', success: false);
    } finally {
      Loader.instance.hide();
    }
  }

  Future<void> addSection(
    String table,
    String? resumeId,
    Map<String, dynamic> defaults,
    Future<void> Function() refetch,
  ) async {
    try {
      Loader.instance.show();
      if (resumeId != null) defaults['resume_id'] = resumeId;
      await supabase.from(table).insert(defaults);
      await refetch();
      _showSnack('$table added');
    } catch (e) {
      _showSnack('Failed to add to $table: $e', success: false);
    } finally {
      Loader.instance.hide();
    }
  }

  Future<void> deleteSection(
    String table,
    String id,
    Future<void> Function() refetch,
  ) async {
    try {
      Loader.instance.show();
      await supabase.from(table).delete().eq('id', id);
      await refetch();
      _showSnack('Deleted from $table');
    } catch (e) {
      _showSnack('Failed to delete from $table: $e', success: false);
    } finally {
      Loader.instance.hide();
    }
  }

  // ===================== Helpers =====================
  Future<void> _fetchSection(
    String? resumeId,
    String table,
    List<String> fields,
    RxList<Map<String, TextEditingController>> ctrls,
  ) async {
    var query = supabase.from(table).select();

    if (resumeId != null &&
        [
          'skills',
          'experiences',
          'educations',
          'certifications',
          'projects',
        ].contains(table)) {
      query = query.eq('resume_id', resumeId);
    }

    final res = await query;
    ctrls.assignAll(
      List<Map<String, dynamic>>.from(res).map((row) {
        final m = <String, TextEditingController>{};
        m['id'] = TextEditingController(text: row['id'].toString());
        for (var f in fields) {
          m[f] = TextEditingController(text: row[f]?.toString() ?? '');
        }
        return m;
      }).toList(),
    );
  }

  Future<void> _fetchSectionForProject(
    String projectId,
    String table,
    List<String> fields,
    RxList<Map<String, TextEditingController>> ctrls,
  ) async {
    final res = await supabase.from(table).select().eq('project_id', projectId);
    ctrls.assignAll(
      List<Map<String, dynamic>>.from(res).map((row) {
        final m = <String, TextEditingController>{};
        m['id'] = TextEditingController(text: row['id'].toString());
        for (var f in fields) {
          m[f] = TextEditingController(text: row[f]?.toString() ?? '');
        }
        return m;
      }).toList(),
    );
  }
}
