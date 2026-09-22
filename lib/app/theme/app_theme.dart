import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lotus_ai/app/theme/app_colors.dart';
import 'package:lotus_ai/app/theme/theme_extensions.dart';
import 'package:lotus_ai/features/settings/entity/app_settings.dart';

class AppTheme {
  const AppTheme._();

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryLight,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFEADDFF),
    onPrimaryContainer: Color(0xFF21005D),
    secondary: Color(0xFF625B71),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFE8DEF8),
    onSecondaryContainer: Color(0xFF1D192B),
    surface: AppColors.bgLight,
    onSurface: AppColors.textLight,
    surfaceContainerHighest: Color(0xFFE7E0EC),
    onSurfaceVariant: Color(0xFF49454F),
    outline: Color(0xFF79747E),
    outlineVariant: Color(0xFFCAC4D0),
    error: Color(0xFFB3261E),
    onError: Colors.white,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryDark,
    onPrimary: Color(0xFF381E72),
    primaryContainer: Color(0xFF4F378B),
    onPrimaryContainer: Color(0xFFEADDFF),
    secondary: Color(0xFFCCC2DC),
    onSecondary: Color(0xFF332D41),
    secondaryContainer: Color(0xFF4A4458),
    onSecondaryContainer: Color(0xFFE8DEF8),
    surface: AppColors.bgDark,
    onSurface: AppColors.textDark,
    surfaceContainerHighest: Color(0xFF28282D),
    onSurfaceVariant: Color(0xFFCAC4D0),
    outline: Color(0xFF938F99),
    outlineVariant: Color(0xFF35353C),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
  );

  static const ColorScheme sepiaColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primarySepia,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFF0D3A6),
    onPrimaryContainer: Color(0xFF2E1B03),
    secondary: Color(0xFF7A6A50),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFE9D9BE),
    onSecondaryContainer: Color(0xFF2A2010),
    surface: AppColors.bgSepia,
    onSurface: AppColors.textSepia,
    surfaceContainerHighest: Color(0xFFE6D8BC),
    onSurfaceVariant: Color(0xFF5C4E39),
    outline: Color(0xFF8A7A5F),
    outlineVariant: Color(0xFFD8C7A5),
    error: Color(0xFF9A3412),
    onError: Colors.white,
  );

  static ThemeData getTheme(AppThemeType type) {
    switch (type) {
      case AppThemeType.light:
        return lightTheme;
      case AppThemeType.sepia:
        return sepiaTheme;
      case AppThemeType.dark:
        return darkTheme;
    }
  }

  static ThemeData get lightTheme {
    final baseText = GoogleFonts.interTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: lightColorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.surface,
        foregroundColor: lightColorScheme.onSurface,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0.5,
      ),
      textTheme: baseText,
      extensions: const <ThemeExtension<dynamic>>[
        AppChatTheme(
          userBubbleBg: AppColors.userBubbleLight,
          userBubbleFg: Colors.white,
          aiBubbleBg: AppColors.aiBubbleLight,
          aiBubbleFg: AppColors.textLight,
          codeBlockBg: Color(0xFF1E1E2E),
          codeBlockHeaderBg: Color(0xFF181825),
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    final baseText = GoogleFonts.interTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: darkColorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: darkColorScheme.surface,
        foregroundColor: darkColorScheme.onSurface,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
      ),
      textTheme: baseText.apply(
        bodyColor: AppColors.textDark,
        displayColor: AppColors.textDark,
      ),
      extensions: const <ThemeExtension<dynamic>>[
        AppChatTheme(
          userBubbleBg: AppColors.userBubbleDark,
          userBubbleFg: AppColors.textDark,
          aiBubbleBg: AppColors.aiBubbleDark,
          aiBubbleFg: AppColors.textDark,
          codeBlockBg: Color(0xFF18181E),
          codeBlockHeaderBg: Color(0xFF121216),
        ),
      ],
    );
  }

  static ThemeData get sepiaTheme {
    final baseText = GoogleFonts.merriweatherTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: sepiaColorScheme,
      scaffoldBackgroundColor: sepiaColorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: sepiaColorScheme.surface,
        foregroundColor: sepiaColorScheme.onSurface,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surfaceSepia,
        elevation: 0.5,
      ),
      textTheme: baseText.apply(
        bodyColor: AppColors.textSepia,
        displayColor: AppColors.textSepia,
      ),
      extensions: const <ThemeExtension<dynamic>>[
        AppChatTheme(
          userBubbleBg: AppColors.userBubbleSepia,
          userBubbleFg: Colors.white,
          aiBubbleBg: AppColors.aiBubbleSepia,
          aiBubbleFg: AppColors.textSepia,
          codeBlockBg: Color(0xFF3E2723),
          codeBlockHeaderBg: Color(0xFF2C1D18),
        ),
      ],
    );
  }
}
