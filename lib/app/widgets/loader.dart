import 'package:flutter/material.dart';

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
            child: const Center(child: CircularProgressIndicator()),
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
