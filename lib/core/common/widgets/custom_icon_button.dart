import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.icon,
    super.key,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.buttonSize,
    this.boxShadow,
    this.gradient,
    this.fillColor,
    this.trailing,
    this.onPressed,
  });

  final BorderRadius? borderRadius;
  final double? buttonSize;
  final Color? fillColor;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final Color? borderColor;
  final double? borderWidth;
  final Widget icon;
  final Widget? trailing;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) => Material(
    borderRadius: borderRadius,
    color: Colors.transparent,
    clipBehavior: Clip.antiAlias,
    child: Ink(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: fillColor,
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: borderWidth ?? 0,
        ),
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        gradient: gradient,
      ),
      child: Column(
        children: [
          IconButton(
            icon: icon,
            onPressed: onPressed,
            splashRadius: buttonSize,
          ),
          if(trailing != null) trailing!,
        ],
      ),
    ),
  );
}