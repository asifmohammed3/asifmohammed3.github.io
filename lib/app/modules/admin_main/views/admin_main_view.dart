import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_main_controller.dart';

class AdminMainView extends GetView<AdminMainController> {
  const AdminMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Admin Panel")),
      body: Row(
        children: [
          _leftSidebar(),
          Expanded(child: _rightTabs()),
        ],
      ),
    );
  }

  Widget _leftSidebar() {
    final tCtrl = TextEditingController();
    final sCtrl = TextEditingController();
    return Container(
      width: 280,
      color: Colors.grey[900],
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          TextField(
            controller: tCtrl,
            decoration: const InputDecoration(labelText: "Title"),
          ),
          TextField(
            controller: sCtrl,
            decoration: const InputDecoration(labelText: "Subtitle"),
          ),
          ElevatedButton(
            onPressed: () {
              controller.addResume(tCtrl.text, sCtrl.text);
              tCtrl.clear();
              sCtrl.clear();
            },
            child: const Text("Add Resume"),
          ),
          const Divider(color: Colors.white54),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.resumes.length,
                itemBuilder: (_, i) {
                  final r = controller.resumes[i];
                  final active = r['id'] == controller.activeResumeId.value;
                  return ListTile(
                    title: Text(
                      r['title'] ?? '',
                      style: TextStyle(
                        color: active ? Colors.orange : Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      r['subtitle'] ?? '',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Icon(
                      Icons.check_circle,
                      color: active ? Colors.green : Colors.white54,
                    ),
                    onTap: () => controller.setActiveResume(r['id']),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rightTabs() {
    return Obx(() {
      if (controller.activeResumeId.value == null) {
        return const Center(
          child: Text(
            "Select or add a resume",
            style: TextStyle(color: Colors.white),
          ),
        );
      }
      return DefaultTabController(
        length: 6, // Reduced main tabs
        child: Column(
          children: [
            const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: "Profile"),
                Tab(text: "Skills"),
                Tab(text: "Experience"),
                Tab(text: "Education"),
                Tab(text: "Certifications"),
                Tab(text: "Projects"), // Projects has sub-tabs inside
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _editableProfileSection(),
                  _editableListSection('skills', [
                    'label',
                    'level',
                  ], controller.skillsCtrls),
                  _editableListSection('experiences', [
                    'company',
                    'role',
                    'duration',
                    'description',
                  ], controller.expCtrls),
                  _editableListSection('educations', [
                    'degree',
                    'institution',
                    'year',
                    'description',
                  ], controller.eduCtrls),
                  _editableListSection('certifications', [
                    'title',
                    'year',
                  ], controller.certCtrls),
                  _projectsWithExtras(),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _projectsWithExtras() {
    return Row(
      children: [
        // Left pane: project list
        Expanded(
          flex: 1,
          child: _editableListSection(
            'projects',
            ['title', 'description', 'type', 'img_url', 'project_url'],
            controller.projectCtrls,
            onSelect: (id) => controller.fetchProjectExtras(id),
          ),
        ),

        // Right pane: details & features
        Expanded(
          flex: 1,
          child: Obx(() {
            if (controller.selectedProjectId.value == null) {
              return const Center(
                child: Text(
                  "Select a project to see extras",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(tabs: [Tab(text: "Details")]),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _editableListSection('project_details', [
                          'project_id',
                          'title',
                          'description',
                          'img_url',
                          'client',
                          'date',
                          'project_url',
                          'features',
                        ], controller.projectDetailsCtrls),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _editableProfileSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _tf("Name", controller.nameCtrl),
          _tf("Title", controller.titleCtrl),
          _tf("Image URL", controller.imageUrlCtrl),
          _tf("Email", controller.emailCtrl),
          _tf("Phone", controller.phoneCtrl),
          _tf("Location", controller.locationCtrl),
          _tf("Tag Line", controller.tagLineCtrl),
          _tf("Heading", controller.headingCtrl),
          _tf("Description", controller.descriptionCtrl, maxLines: 3),
          _tf("Specialization", controller.specializationCtrl),
          _tf("Education", controller.educationCtrl),
          _tf("Experience Level", controller.experienceLevelCtrl),
          _tf("Languages", controller.languagesCtrl),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: controller.saveProfile,
            icon: const Icon(Icons.save),
            label: const Text("Save Profile"),
          ),
        ],
      ),
    );
  }

  Widget _editableListSection(
    String title,
    List<String> fields,
    RxList<Map<String, TextEditingController>> ctrls, {
    Function(String)? onSelect,
  }) {
    return Obx(() {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            for (var c in ctrls)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var f in fields)
                    _tf(f, c[f]!, maxLines: f == 'features' ? 4 : 1),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.deleteSection(
                          title,
                          c['id']!.text,
                          () => _refetchForTable(title),
                        ),
                      ),
                      if (onSelect != null)
                        OutlinedButton(
                          onPressed: () => onSelect(c['id']!.text),
                          child: const Text("Edit Extras"),
                        ),
                    ],
                  ),
                  const Divider(),
                ],
              ),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => controller.addSection(
                    title,
                    _resumeIdForTable(title),
                    _defaultsFor(title),
                    () => _refetchForTable(title),
                  ),
                  icon: const Icon(Icons.add),
                  label: Text("Add $title"),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => controller.saveSection(title, fields, ctrls),
                  icon: const Icon(Icons.save),
                  label: Text("Save $title"),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  String? _resumeIdForTable(String table) {
    if ([
      'skills',
      'experiences',
      'educations',
      'certifications',
      'projects',
    ].contains(table)) {
      return controller.activeResumeId.value;
    }
    return null;
  }

  Map<String, dynamic> _defaultsFor(String table) {
    switch (table) {
      case 'skills':
        return {'label': 'New Skill', 'level': 0};
      case 'experiences':
        return {'company': '', 'role': '', 'duration': '', 'description': ''};
      case 'educations':
        return {'degree': '', 'institution': '', 'year': '', 'description': ''};
      case 'certifications':
        return {'title': '', 'year': ''};
      case 'projects':
        return {
          'title': '',
          'description': '',
          'type': '',
          'img_url': '',
          'project_url': '',
        };
      case 'contact_infos':
        return {'icon': '', 'title': '', 'text': ''};
      case 'project_details':
        return {
          'project_id': controller.selectedProjectId.value ?? '',
          'title': '',
          'description': '',
          'img_url': '',
          'client': '',
          'date': '',
          'project_url': '',
          'features': '[]',
        };
      case 'project_features':
        return {
          'project_id': controller.selectedProjectId.value ?? '',
          'title': '',
          'description': '',
        };
      default:
        return {};
    }
  }

  Future<void> _refetchForTable(String table) {
    if (table == 'project_details' || table == 'project_features') {
      return controller.fetchProjectExtras(controller.selectedProjectId.value!);
    }
    return controller.fetchAllSections(controller.activeResumeId.value!);
  }

  Widget _tf(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
        ),
      ),
    );
  }
}
