import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/TextStyle/StyleText.dart';
import 'package:flutter/material.dart';
class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final String section;
  final String validateretrunText;
  final TextEditingController controller;

  CustomTextFormField(
      {required this.hintText,
      required this.controller,
      required this.section,
      required this.validateretrunText});
  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return validateretrunText.tr();
    }
    return null; // Validation passed
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return validateretrunText;
    } else if (!_isValidEmail(value)) {
      return 'Edit_profile.validateEmail'.tr();
    } else {
      return null; // Validation passed
    }
  }

  bool _isValidEmail(String input) {
    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return emailRegex.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.tr(),
          style: TextStyles.setting_Style,
        ),
        TextFormField(
          autocorrect: false,
          enableIMEPersonalizedLearning: false,
          textAlign: TextAlign.left,
          cursorWidth: 1.5,
          controller: controller,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 20, left: 10),
              border: OutlineInputBorder(),
              disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              hintText: hintText.tr(),
              hintStyle: TextStyles.pro_file_Style),
          validator: section == 'Edit_profile.email'.tr() ? validateEmail : validateInput,
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
