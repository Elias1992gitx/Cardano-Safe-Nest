import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safenest/core/common/app/providers/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:safenest/core/extensions/context_extensions.dart';

class ChildQRCodeScreen extends StatelessWidget {
  const ChildQRCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userId = userProvider.user?.uid ?? '';

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
                    data: userId,
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
}