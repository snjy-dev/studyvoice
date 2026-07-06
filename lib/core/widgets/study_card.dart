import 'package:flutter/material.dart';
import 'package:study_voice/core/theme/app_radius.dart';
import 'package:study_voice/core/theme/app_spacing.dart';

/// A reusable Card widget with StudyVoice design tokens.
class StudyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final Color? color;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const StudyCard({
    super.key,
    required this.child,
    this.padding,
    this.elevation,
    this.color,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppRadius.medium;
    final card = Card(
      elevation: elevation,
      color: color,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: effectiveRadius),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSpacing.m),
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: effectiveRadius,
        child: card,
      );
    }

    return card;
  }
}
