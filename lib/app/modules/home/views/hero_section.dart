import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/models.dart';
import '../../../widgets/slide_in_widget.dart';
import '../controllers/home_controller.dart';



class HeroSection extends GetView<HomeController> {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: AnimatedBuilder(
        animation: controller.bubbleController,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned(
                left: 100,
                top: 400 + controller.bubbleAnimation1.value,
                child: _bubble(150, const Color(0xFF2A2A2A)),
              ),
              Positioned(
                right: 200,
                top: 150 - controller.bubbleAnimation2.value,
                child: _bubble(220, const Color(0xFF1C1C1C)),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Flex(
                    direction: isWide ? Axis.horizontal : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // LEFT: Expanded + animated inner content
                      Expanded(
                        flex: isWide ? 2 : 0,
                        child: SlideInMount(
                          fromOffset: const Offset(-1.0, 0),
                          child: _leftContent(
                            isWide,
                            controller.heroSection.value ??
                                HeroSectionModel(
                                  name: '',
                                  animatedRoles: [''],
                                  description: '',
                                  profileImageUrl: '',
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40, height: 40),
                      // RIGHT: Expanded + animated image content
                      MediaQuery.of(context).size.width > 400? Expanded(
                        flex: 1,
                        child: SlideInMount(
                          fromOffset: const Offset(1.0, 0),
                          child: _rightImage(
                            controller.heroSection.value?.profileImageUrl ?? '',
                          ),
                        ),
                      ):SizedBox(),
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

  Widget _leftContent(bool isWide, HeroSectionModel heroData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
      isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Text(
          heroData.name,
          style: const TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 20),
            children: [
              const TextSpan(
                text: "I'm a ",
                style: TextStyle(color: Colors.white),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: SizedBox(
                  height: 30,
                  child: AnimatedTextKit(
                    animatedTexts: heroData.animatedRoles
                        .map(
                          (role) => TyperAnimatedText(
                        role,
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 20,
                        ),
                        speed: const Duration(milliseconds: 150),
                      ),
                    )
                        .toList(),
                    repeatForever: true,
                    pause: const Duration(milliseconds: 500),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          heroData.description,
          style: const TextStyle(color: Colors.white70, height: 1.6),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 32),
        _buttons(isWide),
      ],
    );
  }

  Widget _buttons(bool isWide) {
    return Row(
      mainAxisAlignment: isWide ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        Flexible(
          child: ElevatedButton(
            onPressed: () => controller.scrollToSection('portfolio'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF2C0000),
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              elevation: 5,
            ),
            child: const Text(
              "View My Work",
              style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: OutlinedButton(
            onPressed: () => controller.scrollToSection('contact'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white, width: 2),
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ).copyWith(
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (states) => states.contains(MaterialState.hovered)
                      ? Colors.white
                      : Colors.transparent),
              foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (states) => states.contains(MaterialState.hovered)
                      ? Colors.black
                      : Colors.white),
            ),
            child: const Text(
              "Get In Touch",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Widget _rightImage(String imageUrl) {
    if (imageUrl.isEmpty) return const SizedBox();
    return Stack(
      children: [
        Container(
          width: 320,
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF2A2A2A),
                offset: Offset(20, 20),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(4, 6),
                blurRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              imageUrl,
              width: 320,
              height: 400,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
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
