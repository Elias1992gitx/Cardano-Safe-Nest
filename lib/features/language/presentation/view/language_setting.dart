import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:safenest/core/common/app/providers/language_provider.dart';
import 'package:safenest/core/localization/app_localization.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('select_language')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildLanguageTile(context, 'english', 'en'),
          _buildLanguageTile(context, 'amharic', 'am'),
          _buildLanguageTile(context, 'arabic', 'ar'),
          _buildLanguageTile(context, 'german', 'de'),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, String languageKey, String languageCode) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isSelected = languageProvider.currentLanguage == languageCode;

    return Card(
      elevation:0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        
      ),
      child: ListTile(
        leading: const Icon(Icons.language, color: Colors.blueGrey),
        title: Text(
          AppLocalizations.of(context)!.translate(languageKey),
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
        onTap: () {
          languageProvider.setLanguage(languageCode);
        },
      ),
    );
  }
}