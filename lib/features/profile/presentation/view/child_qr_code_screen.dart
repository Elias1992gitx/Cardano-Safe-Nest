import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safenest/core/common/app/providers/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/features/profile/data/isolates/connection_isolate.dart';
import 'dart:isolate';

class ChildQRCodeScreen extends StatefulWidget {
  const ChildQRCodeScreen({super.key});

  @override
  _ChildQRCodeScreenState createState() => _ChildQRCodeScreenState();
}

class _ChildQRCodeScreenState extends State<ChildQRCodeScreen> {
  late ReceivePort _receivePort;

  @override
  void initState() {
    super.initState();
    _receivePort = ReceivePort();
    _startConnectionIsolate();
  }

  void _startConnectionIsolate() async {
    await Isolate.spawn(connectionIsolate, _receivePort.sendPort);
    _receivePort.listen((message) {
      if (message is Map<String, dynamic> && message['showDialog'] == true) {
        _showConnectionDialog();
      }
    });
  }

  void _showConnectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: context.theme.canvasColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          title: Text(
            'Remember!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: context.theme.primaryColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Connecting your phone allows your parents to:',
                style: GoogleFonts.plusJakartaSans(fontSize: 16),
              ),
              const SizedBox(height: 16),
              _buildFeatureSection(
                icon: Icons.shield,
                title: 'Digital Wellbeing',
                description: 'Monitor your screen time and app usage',
                backgroundColor: Colors.blue.shade50,
              ),
              const SizedBox(height: 16),
              _buildFeatureSection(
                icon: Icons.location_on,
                title: 'Location Sharing',
                description: 'See your location when needed',
                backgroundColor: Colors.orange.shade50,
                isOptional: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Got it, let\'s go!',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: context.theme.primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeatureSection({
    required IconData icon,
    required String title,
    required String description,
    required Color backgroundColor,
    bool isOptional = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: context.theme.primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isOptional) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: context.theme.primaryColor,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.plusJakartaSans(fontSize: 14),
                ),
              ],
            ),
          ),
          if (isOptional)
            Switch(
              value: false,
              onChanged: (value) {},
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userEmail = userProvider.user?.email ?? '';

    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Connect to Parent',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Scan this QR code with your parent\'s phone',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: QrImageView(
                    data: userEmail,
                    version: QrVersions.auto,
                    size: 200.0,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Lottie.asset(
                  'assets/lottie/qr_scan_animation.json',
                  width: 80,
                  height: 80,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _receivePort.close();
    super.dispose();
  }
}