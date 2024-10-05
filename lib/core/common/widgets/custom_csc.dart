import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/extensions/context_extensions.dart';

class CustomCSC extends StatefulWidget {
  final void Function(String)? onCountrySelected;
  final void Function(String)? onStateChanged;
  final void Function(String)? onCityChanged;
  final String? initialCountry;
  final String? initialState;
  final String? initialCity;

  const CustomCSC({
    super.key,
    this.onCountrySelected,
    this.onStateChanged,
    this.onCityChanged,
    this.initialCountry,
    this.initialState,
    this.initialCity,
  });

  @override
  State<CustomCSC> createState() => _CustomCSCState();
}

class _CustomCSCState extends State<CustomCSC> {
  OutlineInputBorder formOutlineBorder = const OutlineInputBorder(
    borderSide: BorderSide(
      width: 0,
      color: Colors.transparent,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CSCPicker(
          dropdownDecoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: context.theme.colorScheme.tertiaryContainer.withOpacity(.5),
          ),
          disabledDropdownDecoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            color: context.theme.colorScheme.tertiaryContainer.withOpacity(.5),
            border: Border.all(
              color: Colors.transparent,
              width: 0,
            ),
          ),
          countrySearchPlaceholder: 'Country',
          stateSearchPlaceholder: 'State',
          citySearchPlaceholder: 'City',
          defaultCountry: getCountryEnum(widget.initialCountry),
          selectedItemStyle: GoogleFonts.outfit(
            textStyle: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 16,
                height: 2.5,
                textBaseline: TextBaseline.alphabetic),
          ),
          dropdownHeadingStyle: GoogleFonts.plusJakartaSans(
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 16,
            ),
          ),
          dropdownItemStyle: GoogleFonts.plusJakartaSans(
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 16,
            ),
          ),
          dropdownDialogRadius: 10,
          searchBarRadius: 50,
          onCountryChanged: (country) {
            if (country != null && widget.onCountrySelected != null) {
              widget.onCountrySelected!(country);
            }
          },
          onStateChanged: (state) {
            if (state != null && widget.onStateChanged != null) {
              widget.onStateChanged!(state);
            }
          },
          onCityChanged: (city) {
            if (city != null && widget.onCityChanged != null) {
              widget.onCityChanged!(city);
            }
          },
        ),
      ],
    );
  }

  CscCountry? getCountryEnum(String? countryCode) {
    if (countryCode == null) return null;
    try {

      return CscCountry.values.firstWhere(
        (c) =>
            c.toString().split('.').last.toUpperCase() ==
            countryCode.toUpperCase(),
        orElse: () => CscCountry.United_States,
      );
    } catch (e) {
      return null;
    }
  }
}