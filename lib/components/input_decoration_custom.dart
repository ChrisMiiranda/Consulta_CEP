import 'package:flutter/material.dart';

class CustomInputDecoration extends InputDecoration {
  final String text;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;

  const CustomInputDecoration(
      this.text, {
        this.suffixIcon,
        this.prefixIcon,
        this.borderColor,
        this.padding,
      });

  @override
  get hintText => text;

  @override
  get hintStyle => const TextStyle(
    color: Colors.white60,
    fontSize: 18,
  );

  @override
  get floatingLabelBehavior => FloatingLabelBehavior.always;

  @override
  get labelText => null;

  @override
  get counterText => "";

  @override
  get contentPadding =>
      padding ?? const EdgeInsets.only(left: 0, top: 15);

  @override
  get enabledBorder => UnderlineInputBorder(
    borderSide: BorderSide(
      color: (borderColor != null) ? borderColor! : Colors.white,
      width: 1,
    ),
  );

  @override
  get focusedBorder => UnderlineInputBorder(
    borderSide: BorderSide(
      color: (borderColor != null) ? borderColor! : Colors.white,
      width: 1,
    ),
  );

  @override
  get errorBorder => const UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.redAccent, width: 1),
  );

  @override
  get focusedErrorBorder => const UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.redAccent, width: 1),
  );
}
