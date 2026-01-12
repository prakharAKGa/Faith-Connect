import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenStorage {
  final _storage = const FlutterSecureStorage();

  // Keys
  static const String _tokenKey = 'access_token';
  static const String _roleKey = 'user_role';
  static const String _userIdKey = 'user_id';      // NEW: for storing user ID
  static const String _themeKey = 'is_dark_mode';

  /// ── Auth Token, Role & User ID ─────────────────────────────────────

  Future<void> saveAuthToken(String token) async {
    final decoded = JwtDecoder.decode(token);

    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(
      key: _roleKey,
      value: decoded['role']?.toString() ?? '',
    );

    // NEW: Store user ID from JWT payload
    final userId = decoded['id']?.toString();
    if (userId != null) {
      await _storage.write(key: _userIdKey, value: userId);
    }
  }

  Future<String?> getRole() => _storage.read(key: _roleKey);
  Future<String?> getToken() => _storage.read(key: _tokenKey);

  // NEW: Get stored user ID
  Future<String?> getUserId() => _storage.read(key: _userIdKey);

  /// ── Theme Preference ───────────────────────────────────────────────

  Future<void> saveThemePreference(bool isDark) async {
    await _storage.write(key: _themeKey, value: isDark.toString());
  }

  Future<bool?> getThemePreference() async {
    final value = await _storage.read(key: _themeKey);
    if (value == null) return null;
    return value == 'true';
  }

  /// ── Clear everything (logout + reset theme) ────────────────────────
  Future<void> clear() async {
    await _storage.deleteAll();
  }
}