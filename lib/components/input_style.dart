import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CamposInput extends TextStyle {
  final Color? textColor;
  const CamposInput({this.textColor});

  @override
  get color => (textColor != null) ? textColor : Colors.white;
  @override
  get letterSpacing => .5;
  @override
  get fontWeight => FontWeight.w300;
  @override
  get fontSize => 16;
  @override
  get fontFamily => "FormulaCondensed";
}