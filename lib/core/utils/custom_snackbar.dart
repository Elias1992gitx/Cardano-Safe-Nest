import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/res/media_res.dart';

enum ContentType { help, failure, success, warning }

extension ContentTypeExtension on ContentType {
  Color color(BuildContext context) {
    switch (this) {
      case ContentType.failure:
        return Theme.of(context).colorScheme.error;
      case ContentType.success:
        return Theme.of(context).colorScheme.primary;
      case ContentType.warning:
        return Theme.of(context).colorScheme.secondaryContainer;
      case ContentType.help:
        return Theme.of(context).colorScheme.primaryContainer;
    }
  }

  String get assetSVG {
    switch (this) {
      case ContentType.failure:
        return MediaRes.failure;
      case ContentType.success:
        return MediaRes.success;
      case ContentType.warning:
        return MediaRes.warning;
      case ContentType.help:
        return MediaRes.help;
    }
  }
}

class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar({
    required this.title,
    required this.message,
    required this.contentType,
    super.key,
    this.color,
    this.titleFontSize,
    this.messageFontSize,
    this.inMaterialBanner = false,
  });

  final String title;
  final String message;
  final Color? color;
  final ContentType contentType;
  final bool inMaterialBanner;
  final double? titleFontSize;
  final double? messageFontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    final hsl = HSLColor.fromColor(color ?? contentType.color(context));
    final hslDark = hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0));

    final iconSpace = size.width * 0.12;

    return SizedBox(
      height: size.height * 0.08,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          _backgroundContainer(size, theme, hsl, context),
          _splashSVG(size, hslDark,context),
          _bubbleIcon(context, isRTL, iconSpace, size, hslDark),
          _content(context, isRTL, iconSpace, size, theme),
        ],
      ),
    );
  }

  Widget _backgroundContainer(
    Size size,
    ThemeData theme,
    HSLColor hsl,
    BuildContext context,
  ) {
    return Container(
      padding: EdgeInsetsDirectional.zero,
      decoration: BoxDecoration(
        color: color ?? contentType.color(context),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _splashSVG(Size size, HSLColor hslDark,context) {
    return Positioned(
      left: -size.height * 0.02,
      bottom: -size.height * 0.02,
      child: ClipRRect(
        child: SvgPicture.asset(
          MediaRes.bubbles,
          height: size.height * 0.08,
          width: size.width * 0.05,
          fit: BoxFit.cover,
          colorFilter: _getColorFilter(hslDark.toColor(), ui.BlendMode.srcIn),
        ),
      ),
    );
  }


  Widget _bubbleIcon(
    BuildContext context,
    bool isRTL,
    double iconSpace,
    Size size,
    HSLColor hslDark,
  ) {
    return Positioned(
      top: -size.height * 0.01,
      right: 0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap:(){
              if (inMaterialBanner) {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              } else {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }
            },
            child: SvgPicture.asset(
              MediaRes.back,
              height: size.height * 0.06,
              colorFilter: _getColorFilter(hslDark.toColor(), ui.BlendMode.srcIn),
            ),
          ),
          Positioned(
            top: size.height * 0.015,
            child: SvgPicture.asset(
              _getAssetByContentType(contentType),
              height: size.height * 0.020,
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(
    BuildContext context,
    bool isRTL,
    double iconSpace,
    Size size,
    ThemeData theme,
  ) {
    return Positioned.fill(
      left: isRTL ? size.width * 0.03 : iconSpace,
      right: isRTL ? iconSpace : size.width * 0.03,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.01),
          _titleRow(context, size, theme),
          SizedBox(height: size.height * 0.005),
          _messageText(size, theme),
          SizedBox(height: size.height * 0.01),
        ],
      ),
    );
  }

  Widget _titleRow(BuildContext context, Size size, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: title.length > 20?
          Text(
            '',
            style: GoogleFonts.montserrat(
              fontSize: 14,
            ),
          ):Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 14,
            ),
          ),
        ),
        // InkWell(
        //   onTap: () {
        //
        //   },
        //   child: SvgPicture.asset(
        //     _getAssetByContentType(contentType),
        //     height: size.height * 0.02,
        //   ),
        // ),
      ],
    );
  }

  Widget _messageText(Size size, ThemeData theme) {
    return Expanded(
      child: message.length > 20?
      Text(
        message.characters.take(12).toString(),
        style: GoogleFonts.montserrat(
          fontSize: 14,
        ),
      ):Text(
        message,
        style: GoogleFonts.montserrat(
          fontSize: 14,
        ),
      ),
    );
  }

  String assetSVG() => contentType.assetSVG;

  String _getAssetByContentType(ContentType contentType) {
    switch (contentType) {
      case ContentType.failure:
        return MediaRes.failure;
      case ContentType.success:
        return MediaRes.success;
      case ContentType.warning:
        return MediaRes.warning;
      case ContentType.help:
        return MediaRes.help;
    }
  }

  static ColorFilter? _getColorFilter(
    ui.Color? color,
    ui.BlendMode colorBlendMode,
  ) =>
      color == null ? null : ui.ColorFilter.mode(color, colorBlendMode);
}
