import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:safenest/features/profile/presentation/bloc/parental_info_bloc.dart';
import 'package:provider/provider.dart';
import 'package:safenest/core/common/app/providers/user_provider.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ChildQRCodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userId = userProvider.user?.uid ?? '';

    return Scaffold(
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
                SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.all(16),
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
                SizedBox(height: 40),
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