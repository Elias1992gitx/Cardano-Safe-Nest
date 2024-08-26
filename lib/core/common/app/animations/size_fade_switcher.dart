import 'package:flutter/material.dart';

class SizeFadeSwitcher extends StatelessWidget {
  const SizeFadeSwitcher({
    required this.child, super.key
  });
  final Widget child;
  @override  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        transitionBuilder: (child,animation){
          final sizeAnimation = Tween<double>(begin: 0,end: 1).animate(
            CurvedAnimation(
                parent: animation,
                curve: const Interval(0, 0.5)
            ),
          );
          final fadeAnimation = Tween<double>(begin: 0,end: 1).animate(
            CurvedAnimation(
                parent: animation,
                curve: const Interval(0.5, 1),
            ),
          );
          return FadeTransition(
            opacity: fadeAnimation,
            child: SizeTransition(
                sizeFactor: sizeAnimation,
                child: child,
            ),
          );
        },
        duration: const Duration(milliseconds: 400),
        child: child,
    );
  }
}
