import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Slide-in animation on mount (entry animation)
class SlideInMount extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Offset fromOffset;

  const SlideInMount({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 900),
    this.fromOffset = const Offset(-1.0, 0), // Slide from left by default
  }) : super(key: key);

  @override
  _SlideInMountState createState() => _SlideInMountState();
}

class _SlideInMountState extends State<SlideInMount> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _visible ? Offset.zero : widget.fromOffset,
      duration: widget.duration,
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: widget.duration,
        child: widget.child,
      ),
    );
  }
}



class SlideOnVisibility extends StatefulWidget {
  final Widget child;
  final Offset fromOffset;
  final Duration duration;

  const SlideOnVisibility({
    Key? key,
    required this.child,
    this.fromOffset = const Offset(-1.0, 0), // Slide in from left
    this.duration = const Duration(milliseconds: 700),
  }) : super(key: key);

  @override
  State<SlideOnVisibility> createState() => _SlideOnVisibilityState();
}

class _SlideOnVisibilityState extends State<SlideOnVisibility> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _offsetAnimation = Tween<Offset>(
      begin: widget.fromOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_hasAnimated && info.visibleFraction > 0.1) {
      _controller.forward();
      _hasAnimated = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.key ?? UniqueKey(),
      onVisibilityChanged: _onVisibilityChanged,
      child: SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(
          opacity: _controller,
          child: widget.child,
        ),
      ),
    );
  }
}




