import 'package:flutter/material.dart';
import 'package:study_voice/core/theme/app_spacing.dart';

/// A reusable Scaffold wrapper for StudyVoice.
/// 
/// Ensures consistent [SafeArea] and horizontal padding.
class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool useSafeArea;
  final bool applyPadding;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.useSafeArea = true,
    this.applyPadding = true,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    var currentBody = body;

    if (applyPadding) {
      currentBody = Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
        child: currentBody,
      );
    }

    if (useSafeArea) {
      currentBody = SafeArea(child: currentBody);
    }

    return Scaffold(
      appBar: appBar,
      body: currentBody,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
