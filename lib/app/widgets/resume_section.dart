import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ResumeRightPanel extends StatelessWidget {
  const ResumeRightPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 900),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // Top title
          Center(
            child: Column(
              children: const [
                Text(
                  "Resume",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Magnam dolores commodi suscipit. Necessitatibus eius consequatur ex aliquid fuga eum quidem...",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
          _sectionTitle("🧠 Professional Experience"),
          const SizedBox(height: 20),

          // Job Entries
          _experienceCard(
            title: "Senior Software Architect",
            company: "Tech Innovations Inc.",
            duration: "2022 - Present",
            bullets: [
              "Lead the architectural design and implementation of enterprise-scale applications",
              "Mentor team of 12 developers and establish technical best practices",
              "Drive adoption of microservices architecture and cloud-native solutions",
              "Reduce system downtime by 75% through improved architecture and monitoring",
            ],
          ),
          const SizedBox(height: 28),
          _experienceCard(
            title: "Lead Developer",
            company: "Digital Solutions Corp.",
            duration: "2019 - 2022",
            bullets: [
              "Spearheaded development of company’s flagship product reaching 1M+ users",
              "Implemented CI/CD pipeline reducing deployment time by 60%",
              "Managed team of 8 developers across multiple projects",
              "Increased code test coverage from 45% to 90%",
            ],
          ),

          const SizedBox(height: 40),
          _sectionTitle("🎓 Education"),
          const SizedBox(height: 20),

          _educationItem(
            degree: "Master of Science in Computer Science",
            university: "Stanford University",
            duration: "2017 - 2019",
            detail:
                "Specialized in Artificial Intelligence and Machine Learning. Graduated with honors.",
          ),
          const SizedBox(height: 24),
          _educationItem(
            degree: "Bachelor of Science in Software Engineering",
            university: "MIT",
            duration: "2013 - 2017",
            detail: "Dean’s List all semesters. Led university’s coding club.",
          ),

          const SizedBox(height: 40),
          _sectionTitle("📜 Certifications"),
          const SizedBox(height: 20),
          _certificationItem("AWS Certified Solutions Architect – Professional", "2023"),
          _certificationItem("Google Cloud Professional Architect", "2022"),

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(duration, style: const TextStyle(color: Colors.white60, fontSize: 13)),
        Text(company, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        ...bullets.map((point) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("• ", style: TextStyle(color: Colors.white)),
                Expanded(
                  child: Text(
                    point,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Widget _educationItem({
    required String degree,
    required String university,
    required String duration,
    required String detail,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(degree,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(duration, style: const TextStyle(color: Colors.white60, fontSize: 13)),
        Text(university, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 6),
        Text(detail, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    );
  }

  Widget _certificationItem(String title, String year) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Text("• ", style: TextStyle(color: Colors.white)),
          Expanded(
            child: Text(
              "$title ($year)",
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}



class ResumeProfileCard extends StatelessWidget {
  const ResumeProfileCard({super.key});

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
            // Profile Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                                  "https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg",
                                  width: 320,
                                  height: 400,
                                  fit: BoxFit.cover,
                                )
              ),
            ),
            const SizedBox(height: 24),

            // Professional Summary
            const Text(
              "Professional Summary",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Driven software architect with expertise in developing scalable, high-performance enterprise solutions. Passionate about leveraging cutting-edge technologies to solve complex business challenges.",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Contact Info
            const Text(
              "Contact Information",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            contactRow(Icons.location_on, "742 Evergreen Terrace, Springfield, MA 02101"),
            contactRow(Icons.email, "contact@example.com"),
            contactRow(Icons.phone, "+1 (555) 123-4567"),
            contactRow(FontAwesomeIcons.linkedin, "linkedin.com/in/example"),
            const SizedBox(height: 24),

            // Technical Skills
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

