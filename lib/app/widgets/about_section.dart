import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // ← Add scroll if overflow happens
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 12),
            const ProfCard(),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: const Text(
                        "Get to Know Me",
                        style: TextStyle(
                          color: Color(0xFF211F20),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      "Passionate About Creating Digital Experiences",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.15,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudanSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantiumSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantiumSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantiumSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantiumSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantiumSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantiumtium, totam rem aperiam...',
                      style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.7),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        _StatBox(label: "Projects Completed", value: "150+"),
                        SizedBox(width: 38),
                        _StatBox(label: "Years Experience", value: "5+"),
                        SizedBox(width: 38),
                        _StatBox(label: "Client Satisfaction", value: "98%"),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const ResumeInfoCard(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, color: Colors.white54, size: 20),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;

  const _StatBox({required this.value, required this.label, Key? key}) : super(key: key);

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
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13.5,
            ),
          ),
        ],
      );
}


class ProfCard extends StatelessWidget {
  const ProfCard({Key? key}) : super(key: key);

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
            // Profile image
            Container(
              width: 104,
              height: 104,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white12,
              ),
              child: ClipOval(
                child: Image.network(
                  "https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "Marcus Thompson",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              "Creative Director & Developer",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15.5,
              ),
            ),
            const SizedBox(height: 24),
            // Contact information
            _InfoField(
              icon: Icons.email_outlined,
              text: "marcus@example.com",
            ),
            const SizedBox(height: 10),
            _InfoField(
              icon: Icons.phone,
              text: "+1 (555) 123-4567",
            ),
            const SizedBox(height: 10),
            _InfoField(
              icon: Icons.location_on,
              text: "San Francisco, CA",
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoField({required this.icon, required this.text, Key? key}) : super(key: key);

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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.5,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}


class ResumeInfoCard extends StatelessWidget {
  const ResumeInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 420,
  
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          // Info Grid (2 columns)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Column 1
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _InfoLabelValue(
                    label: "Specialization",
                    value: "UI/UX Design & Development",
                  ),
                  SizedBox(height: 20),
                  _InfoLabelValue(
                    label: "Education",
                    value: "Computer Science, MIT",
                  ),
                ],
              ),
              // Column 2
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _InfoLabelValue(
                    label: "Experience Level",
                    value: "Senior Professional",
                  ),
                  SizedBox(height: 20),
                  _InfoLabelValue(
                    label: "Languages",
                    value: "English, Spanish, French",
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 34),
          // Action Buttons Row
          Row(
            children: [
              // Download Resume Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Let's Talk OutlinedButton
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoLabelValue extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLabelValue(
      {required this.label, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}


