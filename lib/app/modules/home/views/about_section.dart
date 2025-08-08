import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_website/app/utils/responsive.dart';

import '../../../models/models.dart';
import '../controllers/home_controller.dart';

class ProfileCard extends GetView<HomeController> {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  // 📱 Mobile Layout (stacked)
  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfCard(profile: controller.profileData),
          const SizedBox(height: 20),
          _rightPanel(),
        ],
      ),
    );
  }

  // 💻 Desktop Layout (side-by-side)
  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 12),
            ProfCard(profile: controller.profileData),
            const SizedBox(width: 12),
            Expanded(child: _rightPanel()),
          ],
        ),
      ),
    );
  }

  // 📱💻 Tablet Layout (side-by-side but narrower)
  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 4, child: ProfCard(profile: controller.profileData)),
          const SizedBox(width: 12),
          Expanded(flex: 6, child: _rightPanel()),
        ],
      ),
    );
  }

  // 🔹 Right Side Panel (same design reused in all layouts)
  Widget _rightPanel() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 900),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          _TagLine(tagLine: controller.profileData.tagLine),
          SizedBox(height: 18),
          _Heading(heading: controller.profileData.heading),
          SizedBox(height: 18),
          _Description(desc: controller.profileData.description),
          SizedBox(height: 24),
          _StatsRow(statList: controller.profileData.stats),
          SizedBox(height: 24),
          ResumeInfoCard(info: controller.profileData.resumeInfo),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _TagLine extends StatelessWidget {
  final String tagLine;

  const _TagLine({required this.tagLine});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Text(
        tagLine,
        style: const TextStyle(
          color: Color(0xFF211F20),
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  final String heading;

  const _Heading({required this.heading});

  @override
  Widget build(BuildContext context) {
    return Text(
      heading,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        height: 1.15,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _Description extends StatelessWidget {
  final String desc;

  const _Description({required this.desc});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantiumSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantiumSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantiumSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantiumSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantiumSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantiumSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantiumtium, totam rem aperiam...',
      style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.7),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final List<StatItem> statList;

  const _StatsRow({required this.statList});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 38,
      runSpacing: 16,
      children: statList
          .map((stat) => _StatBox(label: stat.label, value: stat.value))
          .toList(),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;

  const _StatBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        label,
        style: const TextStyle(color: Colors.white70, fontSize: 13.5),
      ),
    ],
  );
}

class ProfCard extends StatelessWidget {
  final ProfileModel profile;

  const ProfCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 370,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF232323),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 104,
              height: 104,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white12,
              ),
              child: ClipOval(
                child: Image.network(profile.imageUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              profile.name,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              profile.title,
              style: const TextStyle(color: Colors.white70, fontSize: 15.5),
            ),
            const SizedBox(height: 24),
            _InfoField(icon: Icons.email_outlined, text: profile.email),
            const SizedBox(height: 10),
            _InfoField(icon: Icons.phone, text: profile.phone),
            const SizedBox(height: 10),
            _InfoField(icon: Icons.location_on, text: profile.location),
          ],
        ),
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoField({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF282828),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 13),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 17),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14.5),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class ResumeInfoCard extends StatelessWidget {
  final ResumeInfo info;

  const ResumeInfoCard({super.key, required this.info});

  bool get isMobile => Get.width < 600;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info section
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoLabelValue(
                      label: "Specialization",
                      value: info.specialization,
                    ),
                    const SizedBox(height: 20),
                    _InfoLabelValue(label: "Education", value: info.education),
                    const SizedBox(height: 20),
                    _InfoLabelValue(
                      label: "Experience Level",
                      value: info.experienceLevel,
                    ),
                    const SizedBox(height: 20),
                    _InfoLabelValue(label: "Languages", value: info.languages),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InfoLabelValue(
                            label: "Specialization",
                            value: info.specialization,
                          ),
                          const SizedBox(height: 20),
                          _InfoLabelValue(
                            label: "Education",
                            value: info.education,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InfoLabelValue(
                            label: "Experience Level",
                            value: info.experienceLevel,
                          ),
                          const SizedBox(height: 20),
                          _InfoLabelValue(
                            label: "Languages",
                            value: info.languages,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 34),
          // Buttons section
          isMobile
              ? Column(
                  children: [
                    _buildDownloadButton(),
                    const SizedBox(height: 12),
                    _buildTalkButton(),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _buildDownloadButton()),
                    const SizedBox(width: 20),
                    Expanded(child: _buildTalkButton()),
                  ],
                ),
        ],
      ),
    );
  }

  /// Download Resume Button
  Widget _buildDownloadButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // TODO: Add download resume action
      },
      icon: const Icon(Icons.download_outlined, color: Color(0xFF2C0000)),
      label: const Padding(
        padding: EdgeInsets.symmetric(vertical: 13),
        child: Text(
          "Download Resume",
          style: TextStyle(
            color: Color(0xFF2C0000),
            fontWeight: FontWeight.bold,
            fontSize: 16.5,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2C0000),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        elevation: 0,
      ),
    );
  }

  /// Let's Talk Button
  Widget _buildTalkButton() {
    return OutlinedButton.icon(
      onPressed: () {
        // TODO: Add "Let's Talk" action
      },
      icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      label: const Padding(
        padding: EdgeInsets.symmetric(vertical: 13),
        child: Text(
          "Let's Talk",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.5,
          ),
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class _InfoLabelValue extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLabelValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
