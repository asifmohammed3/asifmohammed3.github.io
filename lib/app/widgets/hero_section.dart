import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _bubbleController;
  late Animation<double> _bubbleAnimation1;
  late Animation<double> _bubbleAnimation2;

  @override
  void initState() {
    super.initState();

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _bubbleAnimation1 = Tween<double>(begin: 0, end: 30).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.easeInOut),
    );
    _bubbleAnimation2 = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    if (_bubbleController.isAnimating) {
      _bubbleController.stop();
    }
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          return Stack(
            children: [
              // Animated bubbles
              Positioned(
                left: -100,
                top: 100 + _bubbleAnimation1.value,
                child: _bubble(300, const Color(0xFF2A2A2A)),
              ),
              Positioned(
                right: -60,
                top: 150 - _bubbleAnimation2.value,
                child: _bubble(200, const Color(0xFF1C1C1C)),
              ),

              // Main centered content
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Flex(
                    direction: isWide ? Axis.horizontal : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left content
                      Expanded(
                        flex: isWide ? 2 : 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: isWide
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.center,
                          children: [
                            Text(
                              "SnapFolio",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Mohammed Asif",
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(fontSize: 20),
                                children: [
                                  TextSpan(
                                      text: "I'm a ",
                                      style: TextStyle(color: Colors.white)),
                                  TextSpan(
                                    text: "Flutter Dev",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              "Passionate about creating exceptional digital experiences that\n"
                                  "blend innovative design with functional development. Let's bring your vision to life.",
                              style: TextStyle(
                                  color: Colors.white70, height: 1.6),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            Wrap(
                              spacing: 16,
                              runSpacing: 10,
                              alignment: WrapAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    "View My Work",
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    side:
                                    const BorderSide(color: Colors.white),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text("Get In Touch"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Wrap(
                              spacing: 18,
                              alignment: WrapAlignment.center,
                              children: const [
                                FaIcon(FontAwesomeIcons.xTwitter,
                                    color: Colors.white, size: 18),
                                FaIcon(FontAwesomeIcons.facebookF,
                                    color: Colors.white, size: 18),
                                FaIcon(FontAwesomeIcons.instagram,
                                    color: Colors.white, size: 18),
                                FaIcon(FontAwesomeIcons.linkedinIn,
                                    color: Colors.white, size: 18),
                              ],
                            )
                          ],
                        ),
                      ),

                      const SizedBox(width: 40, height: 40),

                      // Right image
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                offset: Offset(4, 6),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              "https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg",
                              width: 320,
                              height: 400,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _bubble(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
