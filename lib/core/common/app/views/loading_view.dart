import 'package:flutter/material.dart';
import 'package:safenest/core/extensions/context_extensions.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            context.theme.primaryColor,
          ),
        ),
      ),
    );
  }
}
