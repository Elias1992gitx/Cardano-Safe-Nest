import 'package:flutter/material.dart';

class GradientBg extends StatelessWidget {
  const GradientBg({required this.child,this.image, super.key});

  final Widget child;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        // TODO(background-img-setting): set optimal background image
        child: SafeArea(
          child: child,
        ),
      ),
    );
  }
}
