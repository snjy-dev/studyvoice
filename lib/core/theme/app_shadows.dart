import 'package:flutter/material.dart';

/// Design tokens for elevation and shadows.
@immutable
abstract class AppShadows {
  const AppShadows._();

  static const List<BoxShadow> small = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x26000000),
      offset: Offset(0, 4),
      blurRadius: 8,
      spreadRadius: 3,
    ),
  ];

  static const List<BoxShadow> large = [
    BoxShadow(
      color: Color(0x33000000),
      offset: Offset(0, 10),
      blurRadius: 20,
      spreadRadius: 5,
    ),
  ];
}
