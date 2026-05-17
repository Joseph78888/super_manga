import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized theme configuration for Super Manga.
///
/// Follows Material 3 design principles and focuses primarily on a premium deep dark mode.
class AppTheme {
  static const Color primaryBackgroundColor = Color(0xFF0B0914);
  static const Color _seedColor = Color(0xFF815BED);

  static const Color navBarColor = Color(0xFF0F0C1B);
  static const Color accentRed = Color(0xFFE55B5B);
  static const Color textMuted = Color(0xFF8B8A95);

  /// Returns the default dark theme for the application.
  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.outfitTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: primaryBackgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.dark,
        surface: primaryBackgroundColor,
        onSurface: Colors.white,
      ),
      textTheme: baseTextTheme.copyWith(
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBackgroundColor,
        elevation: 0,
        centerTitle: false,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: navBarColor,
        selectedItemColor: accentRed,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        MangaAppColors(
          featuredGradient: [Color(0xFF8B77F6), Color(0xFF5341D1)],
          trendingBlue: [Color(0xFF7A6CF8), Color(0xFF5041DE)],
          trendingRed: [Color(0xFFEF5350), Color(0xFFC62828)],
          trendingGreen: [Color(0xFF42E0AE), Color(0xFF16A085)],
          trendingOrange: [Color(0xFFFF9800), Color(0xFFE65100)],
          trendingMagenta: [Color(0xFFE040FB), Color(0xFFAA00FF)],
          trendingTeal: [Color(0xFF26C6DA), Color(0xFF006064)],
          surfaceCard: Color(0xFF161423),
          surfaceElevated: Color(0xFF1E1A33),
          surfaceInput: Color(0xFF1A1A2E),
          headerGradientStart: Color(0xFF2E1C4B),
          headerGradientEnd: Color(0xFF0F0B1A),
        ),
      ],
    );
  }
}

/// Custom design tokens for specific use cases in Super Manga.
@immutable
class MangaAppColors extends ThemeExtension<MangaAppColors> {
  final List<Color> featuredGradient;
  final List<Color> trendingBlue;
  final List<Color> trendingRed;
  final List<Color> trendingGreen;
  final List<Color> trendingOrange;
  final List<Color> trendingMagenta;
  final List<Color> trendingTeal;
  final Color surfaceCard;
  final Color surfaceElevated;
  final Color surfaceInput;
  final Color headerGradientStart;
  final Color headerGradientEnd;

  const MangaAppColors({
    required this.featuredGradient,
    required this.trendingBlue,
    required this.trendingRed,
    required this.trendingGreen,
    required this.trendingOrange,
    required this.trendingMagenta,
    required this.trendingTeal,
    required this.surfaceCard,
    required this.surfaceElevated,
    required this.surfaceInput,
    required this.headerGradientStart,
    required this.headerGradientEnd,
  });

  @override
  MangaAppColors copyWith({
    List<Color>? featuredGradient,
    List<Color>? trendingBlue,
    List<Color>? trendingRed,
    List<Color>? trendingGreen,
    List<Color>? trendingOrange,
    List<Color>? trendingMagenta,
    List<Color>? trendingTeal,
    Color? surfaceCard,
    Color? surfaceElevated,
    Color? surfaceInput,
    Color? headerGradientStart,
    Color? headerGradientEnd,
  }) {
    return MangaAppColors(
      featuredGradient: featuredGradient ?? this.featuredGradient,
      trendingBlue: trendingBlue ?? this.trendingBlue,
      trendingRed: trendingRed ?? this.trendingRed,
      trendingGreen: trendingGreen ?? this.trendingGreen,
      trendingOrange: trendingOrange ?? this.trendingOrange,
      trendingMagenta: trendingMagenta ?? this.trendingMagenta,
      trendingTeal: trendingTeal ?? this.trendingTeal,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceInput: surfaceInput ?? this.surfaceInput,
      headerGradientStart: headerGradientStart ?? this.headerGradientStart,
      headerGradientEnd: headerGradientEnd ?? this.headerGradientEnd,
    );
  }

  @override
  MangaAppColors lerp(ThemeExtension<MangaAppColors>? other, double t) {
    if (other is! MangaAppColors) return this;
    return MangaAppColors(
      featuredGradient: _lerpGradient(
        featuredGradient,
        other.featuredGradient,
        t,
      ),
      trendingBlue: _lerpGradient(trendingBlue, other.trendingBlue, t),
      trendingRed: _lerpGradient(trendingRed, other.trendingRed, t),
      trendingGreen: _lerpGradient(trendingGreen, other.trendingGreen, t),
      trendingOrange: _lerpGradient(trendingOrange, other.trendingOrange, t),
      trendingMagenta: _lerpGradient(trendingMagenta, other.trendingMagenta, t),
      trendingTeal: _lerpGradient(trendingTeal, other.trendingTeal, t),
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      surfaceInput: Color.lerp(surfaceInput, other.surfaceInput, t)!,
      headerGradientStart: Color.lerp(
        headerGradientStart,
        other.headerGradientStart,
        t,
      )!,
      headerGradientEnd: Color.lerp(
        headerGradientEnd,
        other.headerGradientEnd,
        t,
      )!,
    );
  }

  List<Color> _lerpGradient(List<Color> a, List<Color> b, double t) {
    return List.generate(a.length, (index) {
      if (index < b.length) {
        return Color.lerp(a[index], b[index], t)!;
      }
      return a[index];
    });
  }
}
