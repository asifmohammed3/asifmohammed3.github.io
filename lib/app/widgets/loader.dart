import 'package:flutter/material.dart';

class ProgressBarLoader extends StatefulWidget {
  const ProgressBarLoader({super.key});

  @override
  State<ProgressBarLoader> createState() => _ProgressBarLoaderState();
}

class _ProgressBarLoaderState extends State<ProgressBarLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);

    _progress = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 22,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6), // Rounded caps
        child: AnimatedBuilder(
          animation: _progress,
          builder: (context, child) {
            return Stack(
              children: [
                Container(color: Colors.white.withOpacity(0.2)), // Track
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _progress.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.white60],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class OverlayLoader extends StatelessWidget {
  const OverlayLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: Loader.instance.isLoading,
      builder: (context, isLoading, _) {
        if (!isLoading) return const SizedBox.shrink();
        return Positioned.fill(
          child: Container(
            color: Colors.black54,
            child: const Center(child: ProgressBarLoader()),
          ),
        );
      },
    );
  }
}

class Loader {
  Loader._privateConstructor();

  static final Loader instance = Loader._privateConstructor();

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  void show() => isLoading.value = true;

  void hide() => isLoading.value = false;
}
