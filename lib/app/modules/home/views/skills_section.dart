import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_website/app/modules/home/controllers/home_controller.dart';

import '../../../models/models.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/LinedTitle.dart';

class SkillsSection extends GetView<HomeController> {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final half = (controller.skills.length / 2).ceil();
    final firstColumn = controller.skills.take(half).toList();
    final secondColumn = controller.skills.skip(half).toList();

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          children: [
            // Title
            LinedTitle(
              text: "Skills",
              lineColor: Colors.white,
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 38),

            // Skills Grid (Dynamic)
            Responsive(
              mobile: _SkillColumn(skills: controller.skills),
              desktop: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _SkillColumn(skills: firstColumn)),
                  const SizedBox(width: 42),
                  Expanded(child: _SkillColumn(skills: secondColumn)),
                ],
              ),
              tablet: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _SkillColumn(skills: firstColumn)),
                  const SizedBox(width: 42),
                  Expanded(child: _SkillColumn(skills: secondColumn)),
                ],
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class _SkillColumn extends StatelessWidget {
  final List<Skill> skills;

  const _SkillColumn({required this.skills});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF232323),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var skill in skills) ...[
            _SkillBar(skill: skill),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}

class _SkillBar extends StatelessWidget {
  final Skill skill;

  const _SkillBar({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              skill.label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Text(
              "${skill.level}%",
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Animate progress bar
        LayoutBuilder(
          builder: (context, constraints) {
            // constraints.maxWidth gives actual available width
            return TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween<double>(begin: 0, end: skill.level / 100),
              builder: (context, value, _) {
                return Stack(
                  children: [
                    Container(
                      height: 7,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.09),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Container(
                      height: 7,
                      width: constraints.maxWidth * value,
                      // Use actual available width here
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
