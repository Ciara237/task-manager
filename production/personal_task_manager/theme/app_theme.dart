import 'package:flutter/material.dart';

/// Design tokens aligned with TaskFlow / FocusPath mockups.
abstract final class AppColors {
  static const Color primaryDark = Color(0xFF0D4F3C);
  static const Color teal = Color(0xFF00C896);
  static const Color mintSurface = Color(0xFFE8FBF4);
  static const Color mintChip = Color(0xFFB9F5DA);
  static const Color pageBackground = Color(0xFFF7F9F8);
  static const Color cardStroke = Color(0xFFE6EBE9);
  static const Color headlineNavy = Color(0xFF1A2B28);
  static const Color bodyGrey = Color(0xFF5C6F6A);
  static const Color labelCaps = Color(0xFF7A8B86);
}

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

ThemeData buildAppTheme() {
  const Color seed = AppColors.primaryDark;

  final ColorScheme scheme = ColorScheme.fromSeed(
    seedColor: seed,
    primary: AppColors.primaryDark,
    secondary: AppColors.teal,
    surface: Colors.white,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.pageBackground,
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.primaryDark,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryDark,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.cardStroke),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: AppColors.mintChip,
      labelTextStyle: WidgetStateProperty.resolveWith((Set<WidgetState> s) {
        if (s.contains(WidgetState.selected)) {
          return const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: AppColors.primaryDark,
          );
        }
        return const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: AppColors.bodyGrey,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((Set<WidgetState> s) {
        return IconThemeData(
          color: s.contains(WidgetState.selected)
              ? AppColors.primaryDark
              : AppColors.bodyGrey,
        );
      }),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.teal,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.headlineNavy,
        side: const BorderSide(color: AppColors.cardStroke),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.cardStroke),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.cardStroke),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
      ),
      labelStyle: const TextStyle(
        color: AppColors.labelCaps,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
      ),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.cardStroke, thickness: 1),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.headlineNavy,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.headlineNavy,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.headlineNavy, height: 1.45),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.bodyGrey, height: 1.45),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: AppColors.labelCaps,
      ),
    ),
  );
}

/// Decorative list-style mark + app name for app bars (FocusPath).
class BrandedAppTitle extends StatelessWidget {
  const BrandedAppTitle(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = Theme.of(context).appBarTheme.titleTextStyle ??
        Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFF0A1F1C),
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ) ??
        const TextStyle(
          color: Color(0xFF0A1F1C),
          fontWeight: FontWeight.w800,
          fontSize: 18,
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const _ListGlyph(),
        const SizedBox(width: 10),
        Text(label, style: titleStyle),
      ],
    );
  }
}

class _ListGlyph extends StatelessWidget {
  const _ListGlyph();

  static const Color _c = Color(0xFF0A1F1C);

  @override
  Widget build(BuildContext context) {
    Widget bar(double width) {
      return Container(
        width: width,
        height: 2,
        decoration: BoxDecoration(
          color: _c,
          borderRadius: BorderRadius.circular(1),
        ),
      );
    }

    return SizedBox(
      height: 18,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          bar(18),
          const SizedBox(height: 4),
          bar(22),
          const SizedBox(height: 4),
          bar(14),
        ],
      ),
    );
  }
}
