import 'package:faithconnect/app/core/config/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ThemeController extends GetxController {
  final RxBool _isDarkMode = false.obs;
  final TokenStorage _storage = TokenStorage();

  bool get isDarkMode => _isDarkMode.value;

  ThemeMode get themeMode => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() async {
    super.onInit();

    // 1. Try to load user-saved preference first
    final savedTheme = await _storage.getThemePreference();

    if (savedTheme != null) {
      _isDarkMode.value = savedTheme;
    } else {
      // 2. If no user preference → use system
      _updateFromSystem();
    }

    // 3. Listen to system changes only if user didn't override
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      if (savedTheme == null) { // only if user never chose
        _updateFromSystem();
      }
    };
  }

  void _updateFromSystem() {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final shouldBeDark = brightness == Brightness.dark;

    if (_isDarkMode.value != shouldBeDark) {
      _isDarkMode.value = shouldBeDark;
      Get.changeThemeMode(themeMode);
      Get.forceAppUpdate();
    }
  }

  /// User manually toggles → save preference
  Future<void> toggleTheme() async {
    _isDarkMode.toggle();
    await _storage.saveThemePreference(_isDarkMode.value);
    Get.changeThemeMode(themeMode);
    Get.forceAppUpdate();
  }

  Future<void> setLightMode() async {
    _isDarkMode.value = false;
    await _storage.saveThemePreference(false);
    Get.changeThemeMode(ThemeMode.light);
  }

  Future<void> setDarkMode() async {
    _isDarkMode.value = true;
    await _storage.saveThemePreference(true);
    Get.changeThemeMode(ThemeMode.dark);
  }
}

/// =======================================================
/// APP COLOR EXTENSION (for custom colors)
/// =======================================================
class AppColors extends ThemeExtension<AppColors> {
  final Color divider;
  final Color iconMuted;
  final Color chipBackground;
  final Color chatBubbleMe;
  final Color chatBubbleOther;

  const AppColors({
    required this.divider,
    required this.iconMuted,
    required this.chipBackground,
    required this.chatBubbleMe,
    required this.chatBubbleOther,
  });

  @override
  AppColors copyWith({
    Color? divider,
    Color? iconMuted,
    Color? chipBackground,
    Color? chatBubbleMe,
    Color? chatBubbleOther,
  }) {
    return AppColors(
      divider: divider ?? this.divider,
      iconMuted: iconMuted ?? this.iconMuted,
      chipBackground: chipBackground ?? this.chipBackground,
      chatBubbleMe: chatBubbleMe ?? this.chatBubbleMe,
      chatBubbleOther: chatBubbleOther ?? this.chatBubbleOther,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      divider: Color.lerp(divider, other.divider, t)!,
      iconMuted: Color.lerp(iconMuted, other.iconMuted, t)!,
      chipBackground: Color.lerp(chipBackground, other.chipBackground, t)!,
      chatBubbleMe: Color.lerp(chatBubbleMe, other.chatBubbleMe, t)!,
      chatBubbleOther:
          Color.lerp(chatBubbleOther, other.chatBubbleOther, t)!,
    );
  }
}

/// =======================================================
/// COLOR PALETTE (BASED ON IMAGE)
/// =======================================================
class AppPalette {
  // Primary
  static const Color primary = Color(0xFF111827); // charcoal
  static const Color accent = Color(0xFF2563EB); // soft blue

  // Light mode
  static const Color lightBg = Color(0xFFF4F5F7);
  static const Color lightSurface = Colors.white;
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightDivider = Color(0xFFE5E7EB);

  // Dark mode
  static const Color darkBg = Color(0xFF0B1220);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkTextPrimary = Color(0xFFE5E7EB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkDivider = Color(0xFF1F2937);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color danger = Color(0xFFEF4444);
}

/// =======================================================
/// LIGHT THEME
/// =======================================================
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppPalette.lightBg,

  colorScheme: const ColorScheme.light(
    primary: AppPalette.primary,
    secondary: AppPalette.accent,
    background: AppPalette.lightBg,
    surface: AppPalette.lightSurface,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: AppPalette.lightTextPrimary,
    onSurface: AppPalette.lightTextPrimary,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppPalette.lightBg,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppPalette.lightTextPrimary),
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppPalette.lightTextPrimary,
    ),
  ),

  cardTheme: CardThemeData(
    color: AppPalette.lightSurface,
    elevation: 6,
    shadowColor: Colors.black.withOpacity(0.06),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),

  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppPalette.lightTextPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: AppPalette.lightTextSecondary,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppPalette.accent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 0,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppPalette.lightBg,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  ),

  extensions: const [
    AppColors(
      divider: AppPalette.lightDivider,
      iconMuted: Color(0xFF9CA3AF),
      chipBackground: Color(0xFFF1F5F9),
      chatBubbleMe: Color(0xFF2563EB),
      chatBubbleOther: Color(0xFFE5E7EB),
    ),
  ],
);

/// =======================================================
/// DARK THEME
/// =======================================================
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppPalette.darkBg,

  colorScheme: const ColorScheme.dark(
    primary: AppPalette.accent,
    secondary: AppPalette.accent,
    background: AppPalette.darkBg,
    surface: AppPalette.darkSurface,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: AppPalette.darkTextPrimary,
    onSurface: AppPalette.darkTextPrimary,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppPalette.darkSurface,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppPalette.darkTextPrimary),
  ),

  cardTheme: CardThemeData(
    color: AppPalette.darkSurface,
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),

  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppPalette.darkTextPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: AppPalette.darkTextSecondary,
    ),
  ),

  extensions: const [
    AppColors(
      divider: AppPalette.darkDivider,
      iconMuted: Color(0xFF6B7280),
      chipBackground: Color(0xFF1F2937),
      chatBubbleMe: Color(0xFF2563EB),
      chatBubbleOther: Color(0xFF1F2937),
    ),
  ],
);
