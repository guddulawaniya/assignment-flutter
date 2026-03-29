import 'constants.dart';

/// Image URL utility functions — equivalent to React Native ImageUtils
class ImageUtils {
  static String? getPosterUrl(String? path, [String? size]) {
    if (path == null) return null;
    return '${ApiConfig.imageBaseUrl}/${size ?? ImageSizes.poster.medium}$path';
  }

  static String? getBackdropUrl(String? path, [String? size]) {
    if (path == null) return null;
    return '${ApiConfig.imageBaseUrl}/${size ?? ImageSizes.backdrop.medium}$path';
  }

  static String? getProfileUrl(String? path, [String? size]) {
    if (path == null) return null;
    return '${ApiConfig.imageBaseUrl}/${size ?? ImageSizes.profile.medium}$path';
  }
}

/// Formatting utility functions — equivalent to React Native FormatUtils
class FormatUtils {
  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }

  static String formatYear(String dateString) {
    if (dateString.isEmpty) return '';
    return dateString.split('-').first;
  }

  static String formatRuntime(int minutes) {
    if (minutes == 0) return '';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours == 0) return '${mins}m';
    return '${hours}h ${mins}m';
  }

  static String formatCurrency(int amount) {
    if (amount == 0) return 'N/A';
    if (amount >= 1000000000) {
      return '\$${(amount / 1000000000).toStringAsFixed(1)}B';
    }
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    }
    return '\$$amount';
  }

  static String formatVoteCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
