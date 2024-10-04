import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/core/common/widgets/pattern_painter.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            painter: PatternPainter(
              color: Theme.of(context).primaryColor,
              opacity: 0.05,
            ),
            child: Container(),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 180,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Terms of Service',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Welcome to Safe Nest'),
                      _buildParagraph(
                        'Safe Nest is an online parental control application designed to help parents ensure their children\'s safety online by monitoring activity across social media platforms, location tracking, and more. By downloading, installing, or using the Safe Nest app, you agree to the following Terms of Service. Please read these terms carefully before using the app.',
                      ),
                      _buildSectionTitle('1. Acceptance of Terms'),
                      _buildParagraph(
                        'By accessing or using the Safe Nest app and services, you agree to be bound by these Terms of Service. If you do not agree to these terms, you are not authorized to use the app.',
                      ),
                      _buildSectionTitle('2. Eligibility'),
                      _buildParagraph(
                        'You must be at least 18 years old and the legal guardian of the monitored child to use the Safe Nest app. By using the app, you confirm that you have obtained appropriate legal consent to monitor the devices and activities of your child.',
                      ),
                      _buildSectionTitle('3. Use of the Service'),
                      _buildParagraph(
                        'The Safe Nest app provides features such as WhatsApp monitoring, location tracking, geofencing alerts, and social media activity control. You agree to use the app in accordance with local laws and regulations regarding the monitoring of minors\' devices and activities. The app is intended solely for monitoring children under your legal guardianship. Unauthorized monitoring of any other individual\'s device is strictly prohibited and may violate laws.',
                      ),
                      _buildSectionTitle('4. Account Registration and Security'),
                      _buildParagraph(
                        'You must provide accurate and complete information when registering for an account. You are responsible for maintaining the confidentiality of your account and any activities that occur under it. You agree to notify us immediately of any unauthorized use of your account.',
                      ),
                      _buildSectionTitle('5. Privacy'),
                      _buildParagraph(
                        'We respect your privacy and the privacy of your children. Please refer to our Privacy Policy for information on how we collect, use, and disclose personal information.',
                      ),
                      _buildSectionTitle('6. User Responsibilities'),
                      _buildParagraph(
                        'You agree to use Safe Nest in a lawful manner and only for its intended purpose. You are responsible for ensuring that your use of the app complies with applicable laws, including privacy and data protection regulations. You will not use the app to infringe upon the rights of others, harass, or violate any applicable laws.',
                      ),
                      _buildSectionTitle('7. Prohibited Actions'),
                      _buildParagraph(
                        'You may not reverse engineer, decompile, or disassemble any part of the Safe Nest app. You may not use the app to harm, exploit, or invade the privacy of any individual other than your child for whom you have legal guardianship. You may not use the app for any illegal or unethical purposes.',
                      ),
                      _buildSectionTitle('8. Subscription and Payment'),
                      _buildParagraph(
                        'Safe Nest may offer subscription plans for premium features. Subscription fees are billed on a recurring basis (monthly or annually) depending on the plan selected. You agree to provide accurate payment information and authorize us to charge your payment method for the subscription fees. You may cancel your subscription at any time, but no refunds will be provided for partial or unused subscription periods.',
                      ),
                      _buildSectionTitle('9. Modification and Termination of Service'),
                      _buildParagraph(
                        'We reserve the right to modify, suspend, or discontinue the app, features, or services at any time with or without notice. We may also terminate or suspend your access to the app if you violate these Terms of Service.',
                      ),
                      _buildSectionTitle('10. Disclaimer of Warranties'),
                      _buildParagraph(
                        'Safe Nest is provided "as is" and "as available" without warranties of any kind, either express or implied. We do not guarantee that the app will be error-free or uninterrupted, or that it will meet all of your expectations or requirements.',
                      ),
                      _buildSectionTitle('11. Changes to Terms of Service'),
                      _buildParagraph(
                        'We may update these Terms of Service from time to time. We will notify you of any changes by posting the updated terms within the app or via email. Your continued use of the app after any changes constitutes your acceptance of the revised terms.',
                      ),
                      _buildSectionTitle('12. Contact Information'),
                      _buildParagraph(
                        'If you have any questions or concerns about these Terms of Service, please contact us at:',
                      ),
                      InkWell(
                        onTap: () => _launchEmail('help@nexus-labs.com',context),
                        child: Text(
                          'help@nexus-labs.com',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          fontSize: 16,
          height: 1.5,
        ),
      ),
    );
  }

  void _launchEmail(String email,BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      // Show a dialog if the email client can't be launched
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Unable to open email client'),
            content: Text('Please email us at $email'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}