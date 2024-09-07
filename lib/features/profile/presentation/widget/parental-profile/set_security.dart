import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'dart:ui';

class SetPinPage extends StatefulWidget {
  final Function(String) onPinSet;

  const SetPinPage({Key? key, required this.onPinSet}) : super(key: key);

  @override
  _SetPinPageState createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  final TextEditingController _pinController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    _pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _submitPin(String pin) {
    if (pin.length == 4) {
      widget.onPinSet(pin);
      Navigator.of(context).pop(pin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.onSurface;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: GoogleFonts.poppins(
        fontSize: 22,
        color: theme.colorScheme.onSurface,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Set PIN', style: GoogleFonts.poppins()),
      ),
      body: Stack(
        children: [
          // Blurred background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: theme.colorScheme.background.withOpacity(0.5),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter a 4-digit PIN',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Pinput(
                    controller: _pinController,
                    focusNode: focusNode,
                    defaultPinTheme: defaultPinTheme,
                    separatorBuilder: (index) => const SizedBox(width: 8),
                    validator: (value) {
                      return value?.length == 4 ? null : 'PIN must be 4 digits';
                    },
                    onCompleted: _submitPin,
                    onSubmitted: _submitPin,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
