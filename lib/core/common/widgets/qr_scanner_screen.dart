import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:lottie/lottie.dart';

class QRScannerScreen extends StatefulWidget {
  final Function(String) onQRCodeScanned;

  const QRScannerScreen({Key? key, required this.onQRCodeScanned}) : super(key: key);

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _hasScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan Parent QR Code',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (_hasScanned) return;
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final scannedEmail = barcode.rawValue;
                if (scannedEmail != null && scannedEmail.contains('@')) {
                  setState(() {
                    _hasScanned = true;
                  });
                  widget.onQRCodeScanned(scannedEmail);
                  Navigator.of(context).pop();
                  break;
                }
              }
            },
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black54,
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: context.theme.cardColor, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Center(
            child: Lottie.asset(
              'assets/lottie/qr_scan_animation.json',
              width: 300,
              height: 300,
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Text(
              'Align the QR code within the frame',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}