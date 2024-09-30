import 'package:flutter/material.dart';
import 'package:safenest/core/extensions/context_extensions.dart';

class CustomProfilePic extends StatelessWidget {
  const CustomProfilePic({
    required this.imageProvider,
    required this.onClicked,
    super.key,
    this.isEdit = false,
    this.radius,
  });
  final ImageProvider imageProvider;
  final bool isEdit;
  final VoidCallback onClicked;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final color = context.theme.colorScheme.secondary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          if (isEdit) Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final image = imageProvider;

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: radius ?? 128,
          height: radius ?? 128,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
    color: Colors.white,
    all: 3,
    child: buildCircle(
      color: color,
      all: 8,
      child: InkWell(
        onTap: onClicked,
        child: Icon(
          isEdit ? Icons.add_a_photo : Icons.edit,
          color: Colors.white,
          size: 20,
        ),
      ),
    ),
  );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
