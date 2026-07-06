import 'package:flutter/material.dart';

/// A reusable text field with StudyVoice design tokens.
class StudyTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool isMultiline;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

  const StudyTextField({
    super.key,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.controller,
    this.isMultiline = false,
    this.textInputAction,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      readOnly: readOnly,
      maxLines: isMultiline ? null : 1,
      minLines: isMultiline ? 3 : 1,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

/// A reusable search bar for StudyVoice.
class StudySearchBar extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const StudySearchBar({
    super.key,
    this.hint,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return StudyTextField(
      controller: controller,
      hint: hint ?? 'Search...',
      prefixIcon: const Icon(Icons.search),
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
    );
  }
}
