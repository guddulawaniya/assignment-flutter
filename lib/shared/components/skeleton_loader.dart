import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme.dart';

/// SkeletonLoader — equivalent to React Native SkeletonLoader.tsx
/// Uses shimmer package for the pulsing animation effect
class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppBorderRadius.sm,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Shimmer.fromColors(
      baseColor: colors.skeleton,
      highlightColor: colors.skeletonHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colors.skeleton,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
