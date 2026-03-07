import 'package:flutter/material.dart';
import 'package:dwellly_flutter/core/theme/app_theme.dart';

class AvatarUtils {
  static String sanitizeUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.contains('localhost') || url.contains('127.0.0.1')) {
      const serverIp = '10.0.2.2';
      return url
          .replaceAll('localhost', serverIp)
          .replaceAll('127.0.0.1', serverIp);
    }
    return url;
  }

  static String getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  static String getFallbackAvatarUrl(String? identifier) {
    if (identifier == null || identifier.isEmpty) {
      return 'https://ui-avatars.com/api/?background=55B97D&color=fff&name=?';
    }
    return 'https://ui-avatars.com/api/?background=55B97D&color=fff&name=${Uri.encodeComponent(identifier)}';
  }

  static Widget buildAvatar({
    String? imageUrl,
    String? fallbackName,
    double radius = 20,
    Border? border,
  }) {
    final sanitizedUrl = sanitizeUrl(imageUrl);
    final hasValidImage = sanitizedUrl.isNotEmpty;

    if (hasValidImage) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(sanitizedUrl),
        backgroundColor: AppTheme.primaryGreen.withValues(alpha: 0.1),
        child: null,
      );
    }

    final initials = getInitials(fallbackName);
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppTheme.primaryGreen,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.8,
        ),
      ),
    );
  }
}
