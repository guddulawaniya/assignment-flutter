import 'package:flutter/material.dart';
import '../theme.dart';

/// RatingBadge — equivalent to React Native RatingBadge.tsx
class RatingBadge extends StatelessWidget {
  final double rating;
  final String size; // 'small' | 'medium' | 'large'

  const RatingBadge({
    super.key,
    required this.rating,
    this.size = 'medium',
  });

  Color _getColor() {
    if (rating >= 7) {
      return const Color(0xFF22C55E);
    }
    if (rating >= 5) {
      return const Color(0xFFF59E0B);
    }
    return const Color(0xFFEF4444);
  }

  Map<String, double> _getSizeStyles() {
    switch (size) {
      case 'small':
        return {'fontSize': 10, 'padding': 3, 'minWidth': 28};
      case 'large':
        return {'fontSize': 14, 'padding': 6, 'minWidth': 42};
      default:
        return {'fontSize': 12, 'padding': 4, 'minWidth': 36};
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizeStyle = _getSizeStyles();

    return Container(
      constraints: BoxConstraints(minWidth: sizeStyle['minWidth']!),
      padding: EdgeInsets.all(sizeStyle['padding']!),
      decoration: BoxDecoration(
        color: _getColor(),
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '★',
            style: TextStyle(
              fontSize: sizeStyle['fontSize']!,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: sizeStyle['fontSize']!,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
