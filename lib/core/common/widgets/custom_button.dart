import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FFButtonOptions {
  const FFButtonOptions(
      {this.textStyle,
        this.elevation,
        this.height,
        this.width,
        this.padding,
        this.color,
        this.disabledColor,
        this.disabledTextColor,
        this.splashColor,
        this.iconSize,
        this.iconColor,
        this.iconPadding,
        this.borderRadius,
        this.borderSide,
        this.boxShadow,});

  final TextStyle? textStyle;
  final double? elevation;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? disabledColor;
  final Color? disabledTextColor;
  final Color? splashColor;
  final double? iconSize;
  final Color? iconColor;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? iconPadding;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
}

class FFCustomButton extends StatefulWidget {
  const FFCustomButton({
    required this.text,
    required this.onPressed,
    required this.options,
    super.key,
    this.icon,
    this.iconData,
    this.trailing,
    this.showLoadingIndicator = true,
  });

  final String text;
  final Widget? icon;
  final Widget? trailing;
  final IconData? iconData;
  final Function onPressed;
  final FFButtonOptions options;
  final bool showLoadingIndicator;

  @override
  State<FFCustomButton> createState() => _FFCustomButtonState();
}

class _FFCustomButtonState extends State<FFCustomButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final Widget textWidget = Center(
      child: SizedBox(
        width: 23,
        height: 23,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.options.textStyle!.color ?? Colors.white,
          ),
        ),
      ),
    );

    final onPressed = widget.showLoadingIndicator
        ? () async {
      if (loading) {
        return;
      }
      setState(() => loading = true);
      try {
        await widget.onPressed();
      } finally {
        if (mounted) {
          setState(() => loading = false);
        }
      }
    }
        : () => widget.onPressed();

    final style = ButtonStyle(
      shape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius:
          widget.options.borderRadius ?? BorderRadius.circular(8),
          side: widget.options.borderSide ?? BorderSide.none,
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (states) {
          if (states.contains(WidgetState.disabled)) {
            return widget.options.disabledTextColor;
          }
          return widget.options.textStyle!.color;
        },
      ),
      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (states) {
          if (states.contains(WidgetState.disabled)) {
            return widget.options.disabledColor;
          }
          return widget.options.color;
        },
      ),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return widget.options.splashColor;
        }
        return null;
      }),
      padding: WidgetStateProperty.all(
        widget.options.padding ??
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      elevation:
      WidgetStateProperty.all<double>(widget.options.elevation ?? 2.0),
    );

    if (widget.icon != null || widget.iconData != null) {
      return SizedBox(
        height: widget.options.height,
        width: widget.options.width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: style,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: widget.options.iconPadding ?? EdgeInsets.zero,
                child: widget.icon ??
                    FaIcon(
                      widget.iconData,
                      size: widget.options.iconSize,
                      color: widget.options.iconColor ??
                          widget.options.textStyle!.color,
                    ),
              ),
              if (loading) textWidget else Text(
                widget.text,
                style: widget.options.textStyle,
              ),
              if (widget.trailing != null) widget.trailing!
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: widget.options.height,
      width: widget.options.width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: loading
            ? textWidget
            : Text(widget.text, style: widget.options.textStyle),
      ),
    );
  }
}
