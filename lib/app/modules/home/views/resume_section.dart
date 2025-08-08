import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../models/models.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/LinedTitle.dart';
import '../../../widgets/dotted_timeline.dart';
import '../controllers/home_controller.dart';

class ResumeSection extends GetView<HomeController> {
  const ResumeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.resumeSectionData.value;

      if (data == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          LinedTitle(
            text: "Resume",
            lineColor: Colors.white,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "gfghfhgfjhgfjhgfjhgjhjh",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),

          Responsive(
            mobile: _buildMobileLayout(data),
            tablet: _buildTabletLayout(data),
            desktop: _buildDesktopLayout(data),
          ),
        ],
      );
    });
  }
}

// Mobile layout: typically stacked vertically with smaller widths
Widget _buildMobileLayout(dynamic data) {
  return Column(
    children: [
      ResumeProfileCard(profile: data.profile),

      const SizedBox(height: 16),

      ResumeRightPanel(
        experiences: data.experiences,
        educations: data.educations,
        certifications: data.certifications,
      ),
    ],
  );
}

// Tablet layout: can be two columns but adjusted widths and spacing
Widget _buildTabletLayout(dynamic data) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(flex: 4, child: ResumeProfileCard(profile: data.profile)),
      const SizedBox(width: 16),
      Expanded(
        flex: 7,
        child: ResumeRightPanel(
          experiences: data.experiences,
          educations: data.educations,
          certifications: data.certifications,
        ),
      ),
    ],
  );
}

// Desktop layout: wide with generous spacing
Widget _buildDesktopLayout(dynamic data) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(width: 12),
      SizedBox(width: 360, child: ResumeProfileCard(profile: data.profile)),
      const SizedBox(width: 12),
      Expanded(
        child: ResumeRightPanel(
          experiences: data.experiences,
          educations: data.educations,
          certifications: data.certifications,
        ),
      ),
    ],
  );
}

class ResumeRightPanel extends StatelessWidget {
  final List<Experience> experiences;
  final List<Education> educations;
  final List<Certification> certifications;

  const ResumeRightPanel({
    super.key,
    required this.experiences,
    required this.educations,
    required this.certifications,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 900),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const SizedBox(height: 40),
          _sectionTitle("🧠 Professional Experience"),
          const SizedBox(height: 20),

          ...experiences.map(
            (exp) => _experienceCard(
              title: exp.role,
              company: exp.company,
              duration: exp.duration,
              bullets: exp.description
                  .split('. ')
                  .where((s) => s.isNotEmpty)
                  .toList(),
            ),
          ),
          const SizedBox(height: 40),
          _sectionTitle("🎓 Education"),
          const SizedBox(height: 20),

          ...educations.map(
            (edu) => _educationItem(
              degree: edu.degree,
              university: edu.institution,
              duration: edu.year,
              detail: edu.description,
            ),
          ),

          const SizedBox(height: 40),
          _sectionTitle("📜 Certifications"),
          const SizedBox(height: 20),

          ...certifications.map(
            (cert) => _certificationItem(cert.title, cert.year),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _experienceCard({
    required String title,
    required String company,
    required String duration,
    required List<String> bullets,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DottedTimeline(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    duration,
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                  Text(company, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  ...bullets.map(
                    (point) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("• ", style: TextStyle(color: Colors.white)),
                        Expanded(
                          child: Text(
                            point,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _educationItem({
    required String degree,
    required String university,
    required String duration,
    required String detail,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: IntrinsicHeight(
        child: Row(
          children: [
            DottedTimeline(),
            const SizedBox(width: 16),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    degree,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    duration,
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                  Text(
                    university,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    detail,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _certificationItem(String title, String year) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: IntrinsicHeight(
        child: Row(
          children: [
            DottedTimeline(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    year,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResumeProfileCard extends StatelessWidget {
  final ProfileModel profile;

  const ResumeProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  profile.imageUrl,
                  width: 320,
                  height: 400,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Professional Summary",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              profile.description,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 24),

            const Text(
              "Contact Information",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            contactRow(Icons.location_on, profile.location),
            contactRow(Icons.email, profile.email),
            contactRow(Icons.phone, profile.phone),
            contactRow(FontAwesomeIcons.linkedin, "linkedin.com/in/example"),
            const SizedBox(height: 24),

            const Text(
              "Technical Skills",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            skillProgress("Web Development", 0.95),
            skillProgress("UI/UX Design", 0.85),
            skillProgress("Cloud Architecture", 0.90),
            skillProgress("Project Management", 0.80),
          ],
        ),
      ),
    );
  }

  Widget contactRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget skillProgress(String skill, double percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              Text(
                "${(percent * 100).toInt()}%",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.grey[700],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}
