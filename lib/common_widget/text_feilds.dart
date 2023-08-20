import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timer_app/common_widget/screen_util_wrapper.dart';

class BorderTextFeild extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hinText;
  final bool? readonly;
  final bool? isenabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final void Function(String str)? onChangedValue;
  final AutovalidateMode? autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onTap;
  final FocusNode? focusNode;
  final Color? fillColor;

  const BorderTextFeild(
      {super.key,
      required this.controller,
      this.labelText,
      this.hinText,
      this.readonly,
      this.isenabled,
      this.prefixIcon,
      this.suffixIcon,
      this.validator,
      this.keyboardType,
      this.onChangedValue,
      this.autovalidateMode,
      this.inputFormatters,
      this.onTap,
      this.focusNode,
      this.fillColor});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      readOnly: readonly ?? false,
      onTap: onTap,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        hintText: hinText,
        enabled: isenabled ?? true,
        hintStyle: TextStyle(
            fontSize: ScreenUtilWrapper.setResponsiveSize(12),
            color: Colors.grey),
        labelText: labelText,
        suffixIcon: suffixIcon,
        labelStyle: TextStyle(
            fontSize: ScreenUtilWrapper.setResponsiveSize(12),
            color: Colors.grey),
        prefixIcon: prefixIcon,
        isDense: true,
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.red,
        )),
        errorStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: Colors.red,
              fontSize: ScreenUtilWrapper.setResponsiveSize(10),
            ),
        errorMaxLines: 4,
        filled: true,
        fillColor: fillColor ?? Colors.white,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(ScreenUtilWrapper.setResponsiveSize(5)),
          borderSide: const BorderSide(color: Colors.black54, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black54, width: 1.0),
            borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }
}
