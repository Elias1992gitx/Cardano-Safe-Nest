import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:safenest/core/extensions/context_extensions.dart';

class ConnectionInfoPopup extends StatefulWidget {
  final VoidCallback onClose;

  const ConnectionInfoPopup({Key? key, required this.onClose}) : super(key: key);

  @override
  _ConnectionInfoPopupState createState() => _ConnectionInfoPopupState();
}

class _ConnectionInfoPopupState extends State<ConnectionInfoPopup> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _locationSharingEnabled = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _closePopup() {
    _animationController.reverse().then((_) => widget.onClose());
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Remember!',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: context.theme.primaryColor,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _closePopup,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Connecting your phone allows your parents to:',
                style: GoogleFonts.plusJakartaSans(fontSize: 16),
              ),
              const SizedBox(height: 24),
              _buildFeatureSection(
                icon: IconlyLight.shield_done,
                title: 'Digital Wellbeing',
                description: 'Monitor your screen time and app usage',
                backgroundColor: Colors.blue.shade50,
              ),
              const SizedBox(height: 16),
              _buildFeatureSection(
                icon: IconlyLight.location,
                title: 'Location Sharing',
                description: 'See your location when needed',
                backgroundColor: Colors.orange.shade50,
                isOptional: true,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _closePopup,
                  style: TextButton.styleFrom(
                    backgroundColor: context.theme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Got it, let\'s go!',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
                      _buildInfoIcon(),
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
              value: _locationSharingEnabled,
              onChanged: (value) {
                setState(() {
                  _locationSharingEnabled = value;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildInfoIcon() {
    return Tooltip(
      message: 'Optional location sharing with your parents',
      child: Icon(
        IconlyLight.info_circle,
        size: 18,
        color: context.theme.primaryColor,
      ),
    );
  }
}