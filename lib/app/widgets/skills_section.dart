import 'package:flutter/material.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data for front and back-end
    final frontEndSkills = [
      Skill(label: "HTML/CSS", level: 95),
      Skill(label: "JavaScript", level: 85),
      Skill(label: "React", level: 80),
    ];
    final backEndSkills = [
      Skill(label: "Node.js", level: 75),
      Skill(label: "Python", level: 70),
      Skill(label: "SQL", level: 65),
    ];

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          children: [
            // Title
            const Text(
              'Skills',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Necessitatibus eius consequatur ex aliquid fuga eum quidem sint consectetur velit',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 38),
            // Skill Columns
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Front-end
                Expanded(
                  child: _SkillColumn(
                    title: "Front-end Development",
                    skills: frontEndSkills,
                  ),
                ),
                const SizedBox(width: 42),
                // Back-end
                Expanded(
                  child: _SkillColumn(
                    title: "Back-end Development",
                    skills: backEndSkills,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillColumn extends StatelessWidget {
  final String title;
  final List<Skill> skills;

  const _SkillColumn({required this.title, required this.skills, Key? key}) : super(key: key);

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
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 21,
            ),
          ),
          const SizedBox(height: 22),
          for (var skill in skills) ...[
            _SkillBar(skill: skill),
            const SizedBox(height: 24),
          ]
        ],
      ),
    );
  }
}

class Skill {
  final String label;
  final int level; // 0-100

  Skill({required this.label, required this.level});
}

class _SkillBar extends StatelessWidget {
  final Skill skill;

  const _SkillBar({required this.skill, Key? key}) : super(key: key);

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
            )
          ],
        ),
        const SizedBox(height: 8),
        // Animate progress bar
        TweenAnimationBuilder<double>(
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
                  width: MediaQuery.of(context).size.width * 0.31 * value,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
