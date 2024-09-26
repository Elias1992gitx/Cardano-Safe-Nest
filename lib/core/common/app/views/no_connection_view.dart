import 'package:flutter/material.dart';

class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('No Internet Connection'),
      ),
    );
  }
}