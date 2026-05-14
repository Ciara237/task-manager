import 'package:flutter/material.dart';

/// Accent colors for priority semantics (High → red, Medium → orange, Low → green).
Color priorityColorFor(String priority) {
  switch (priority.toLowerCase()) {
    case 'high':
      return const Color(0xFFD32F2F);
    case 'medium':
      return const Color(0xFFE65100);
    case 'low':
      return const Color(0xFF2E7D32);
    default:
      return const Color(0xFF757575);
  }
}

Color priorityBadgeBackground(String priority) {
  switch (priority.toLowerCase()) {
    case 'high':
      return const Color(0xFFFFF0F0);
    case 'medium':
      return const Color(0xFFFFF3E0);
    case 'low':
      return const Color(0xFFE8F5E9);
    default:
      return const Color(0xFFF5F5F5);
  }
}

Color priorityBadgeForeground(String priority) => priorityColorFor(priority);

/// Sort key: lower = higher priority (High first).
int prioritySortKey(String priority) {
  switch (priority.toLowerCase()) {
    case 'high':
      return 0;
    case 'medium':
      return 1;
    case 'low':
      return 2;
    default:
      return 3;
  }
}
