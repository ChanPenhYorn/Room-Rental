import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

class SessionHelper {
  static const String _sessionBackupKey = 'auth_session_backup';
  static const String _sessionTimestampKey = 'auth_session_timestamp';

  /// Save session backup to SharedPreferences for iOS simulator fallback
  static Future<void> saveSessionBackup(AuthSuccess authSuccess) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Store essential session data
      final sessionData = {
        'authUserId': authSuccess.authUserId.toString(),
        'scopeNames': authSuccess.scopeNames.join(','),
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      await prefs.setString(_sessionBackupKey, jsonEncode(sessionData));
      await prefs.setString(_sessionTimestampKey, DateTime.now().toIso8601String());
      
      print('✅ [SessionHelper] Session backup saved successfully');
    } catch (e) {
      print('⚠️ [SessionHelper] Failed to save session backup: $e');
    }
  }

  /// Load session backup from SharedPreferences
  static Future<Map<String, dynamic>?> loadSessionBackup() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = prefs.getString(_sessionBackupKey);
      
      if (sessionJson != null) {
        final sessionData = jsonDecode(sessionJson) as Map<String, dynamic>;
        print('✅ [SessionHelper] Session backup loaded successfully');
        return sessionData;
      }
      
      return null;
    } catch (e) {
      print('⚠️ [SessionHelper] Failed to load session backup: $e');
      return null;
    }
  }

  /// Check if backup session is still valid (not too old)
  static bool isBackupValid(Map<String, dynamic> backupSession) {
    try {
      final timestampString = backupSession['timestamp'] as String?;
      if (timestampString == null) return false;
      
      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();
      
      // Consider backup valid for 24 hours
      final isValid = now.difference(timestamp).inHours < 24;
      
      if (!isValid) {
        print('⚠️ [SessionHelper] Session backup expired');
      }
      
      return isValid;
    } catch (e) {
      print('⚠️ [SessionHelper] Failed to validate session backup: $e');
      return false;
    }
  }

  /// Clear session backup from SharedPreferences
  static Future<void> clearSessionBackup() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_sessionBackupKey);
      await prefs.remove(_sessionTimestampKey);
      print('✅ [SessionHelper] Session backup cleared successfully');
    } catch (e) {
      print('⚠️ [SessionHelper] Failed to clear session backup: $e');
    }
  }
}