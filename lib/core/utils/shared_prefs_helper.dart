import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _visitorTokenKey = 'visitor_token';
  static const String _deviceIdKey = 'device_id';

  static Future<void> saveVisitorToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_visitorTokenKey, token);
  }

  static Future<String?> getVisitorToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_visitorTokenKey);
  }

  static Future<void> saveDeviceId(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_deviceIdKey, deviceId);
  }

  static Future<String?> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_deviceIdKey);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}