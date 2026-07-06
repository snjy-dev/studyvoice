import 'package:flutter/material.dart';

/// Reusable loading indicators of different sizes.
class LoadingIndicator extends StatelessWidget {
  final LoadingSize size;

  const LoadingIndicator({
    super.key,
    this.size = LoadingSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    double dimension;
    switch (size) {
      case LoadingSize.small:
        dimension = 16.0;
        break;
      case LoadingSize.medium:
        dimension = 32.0;
        break;
      case LoadingSize.large:
        dimension = 48.0;
        break;
    }

    return Center(
      child: SizedBox(
        width: dimension,
        height: dimension,
        child: const CircularProgressIndicator(strokeWidth: 3),
      ),
    );
  }
}

enum LoadingSize { small, medium, large }
