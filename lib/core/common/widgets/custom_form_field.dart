import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/extensions/context_extensions.dart';


typedef SubmitCallback(String value);

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    this.textInputType,
    this.textInputAction,
    this.initialValue,
    this.maxLength,
    this.overrideValidator = false,
    this.prefixText,
    this.controller,
    this.focusNode,
    this.textAlign,
    this.style,
    this.autofocus,
    this.onSubmitted,
    this.borderRadius,
    this.validator,
    this.isEnabled,
    this.labelText,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.readOnly,
    this.maxLines,
    this.autoValidateMode,
    this.isPassword = false,
    this.onSaved,
    this.prefixIcon,
    this.onChange,
    this.inputFormatter,
    this.fillColor,
    this.contentPadding,
    this.suffixIcon,
    this.onSuffixTap
  });

  final EdgeInsetsDirectional? contentPadding;
  final String? hintText;
  final bool overrideValidator;
  final bool? readOnly;
  final String? labelText;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final FocusNode? focusNode;
  final TextAlign? textAlign;
  final VoidCallback? onSuffixTap;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final SubmitCallback? onSubmitted;
  final String? Function(String?)? validator;
  TextInputAction? textInputAction;
  void Function(String)? onSaved, onChange;
  final String? initialValue;
  final Widget? prefix;
  final Widget? prefixIcon;
  final int? maxLines;
  final double? borderRadius;
  final bool? isEnabled;
  final String? prefixText;
  final bool? autofocus;
  final int? maxLength;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatter;
  final AutovalidateMode? autoValidateMode;

  TextInputType? textInputType;
  bool isPassword = false;
  OutlineInputBorder formOutlineBorder = const OutlineInputBorder(
    borderSide: BorderSide(
      width: 0,
      color: Colors.transparent,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus ?? false,

      style: style ??
          GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 16,
            ),
          ),
      maxLines: maxLines,
      enabled: isEnabled,
      readOnly:readOnly??false,
      textAlign: textAlign ?? TextAlign.start,
      initialValue: initialValue,
      obscureText: isPassword,
      inputFormatters: inputFormatter,
      keyboardType: textInputType,
      validator: overrideValidator ?
      validator
          : (value) {
        if(value == null || value.isEmpty){
          return "This Field can't be empty";
        }
        return validator?.call(value);
      },
      onSaved: (val) {
        onSaved!(val!);
      },
      onChanged: onChange,
      maxLength: maxLength,
      onFieldSubmitted: onSubmitted,
      focusNode: focusNode,
      controller: controller,

      textInputAction: textInputAction,
      autovalidateMode: autoValidateMode,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        filled: true,
        prefix: prefix,
        prefixText: prefixText,
        prefixStyle: GoogleFonts.montserrat(
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: context.theme.textTheme.bodyMedium!.color,
          ),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon != null
            ? GestureDetector(
          onTap: onSuffixTap,
          child: suffixIcon,
        )
            : null,
        border: formOutlineBorder,
        counterText: '',
        labelStyle: GoogleFonts.montserrat(
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 16,
          ),
        ),
        hintStyle: hintStyle ?? GoogleFonts.montserrat(
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 16,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color:  Colors.transparent,
            width: 0,
          ),
          borderRadius: BorderRadius.circular(borderRadius ?? 50),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color:  Colors.transparent,
            width: 0,
          ),
          borderRadius: BorderRadius.circular(borderRadius ?? 50),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color:  Colors.transparent,
            width: 0,
          ),
          borderRadius: BorderRadius.circular(borderRadius ?? 50),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color:  Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(borderRadius ?? 50),
        ),

        fillColor: fillColor?? context.theme.colorScheme
            .tertiaryContainer.withOpacity(.5),
        contentPadding:contentPadding?? const EdgeInsetsDirectional
            .fromSTEB(20, 18, 0, 18),
      ),
    );
  }

  CustomTextFormField copyWith({
    String? hintText,
    bool? overrideValidator,
    String? labelText,
    TextStyle? style,
    FocusNode? focusNode,
    TextAlign? textAlign,
    TextEditingController? controller,
    SubmitCallback? onSubmitted,
    String? Function(String?)? validator,
    TextInputAction? textInputAction,
    void Function(String)? onSaved,
    void Function(String)? onChange,
    String? initialValue,
    Widget? prefix,
    int? maxLines,
    double? borderRadius,
    bool? isEnabled,
    bool? autofocus,
    int? maxLength,
    AutovalidateMode? autoValidateMode,
    TextInputType? textInputType,
    bool? isPassword,
    OutlineInputBorder? formOutlineBorder,
  }) {
    return CustomTextFormField(
      hintText: hintText ?? this.hintText,
      overrideValidator: overrideValidator ?? this.overrideValidator,
      labelText: labelText ?? this.labelText,
      style: style ?? this.style,
      focusNode: focusNode ?? this.focusNode,
      textAlign: textAlign ?? this.textAlign,
      controller: controller ?? this.controller,
      onSubmitted: onSubmitted ?? this.onSubmitted,
      validator: validator ?? this.validator,
      textInputAction: textInputAction ?? this.textInputAction,
      onSaved: onSaved ?? this.onSaved,
      onChange: onChange ?? this.onChange,
      initialValue: initialValue ?? this.initialValue,
      prefix: prefix ?? this.prefix,
      maxLines: maxLines ?? this.maxLines,
      borderRadius: borderRadius ?? this.borderRadius,
      isEnabled: isEnabled ?? this.isEnabled,
      autofocus: autofocus ?? this.autofocus,
      maxLength: maxLength ?? this.maxLength,
      autoValidateMode: autoValidateMode ?? this.autoValidateMode,
      textInputType: textInputType ?? this.textInputType,
      isPassword: isPassword ?? this.isPassword,
    );
  }
}
