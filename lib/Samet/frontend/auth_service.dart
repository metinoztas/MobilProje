import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Authentication Servis Sınıfı
/// Backend API ile iletişim kurar, JWT token yönetimini sağlar.
class AuthService {
  // ─── Yapılandırma ────────────────────────────────────────
  // Android Emulator için: 10.0.2.2
  // iOS Simulator için: 127.0.0.1
  // Gerçek cihaz için: Bilgisayarınızın yerel IP adresini yazın
  static const String baseUrl = 'http://10.0.2.2:8001';

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  // ─── Kayıt Ol ────────────────────────────────────────────
  /// Yeni kullanıcı kaydı oluşturur.
  /// Başarılı ise kullanıcı bilgilerini döndürür.
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message'], 'user': data['user']};
      } else {
        return {'success': false, 'message': data['detail'] ?? 'Kayıt başarısız.'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Sunucuya bağlanılamadı. Lütfen tekrar deneyin.'};
    }
  }

  // ─── Giriş Yap ───────────────────────────────────────────
  /// Kullanıcı girişi yapar.
  /// Başarılı ise JWT token'ı yerel depolamaya kaydeder.
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Token ve kullanıcı bilgilerini kaydet
        await _saveToken(data['token']);
        await _saveUser(data['user']);
        return {'success': true, 'message': data['message'], 'user': data['user']};
      } else {
        return {'success': false, 'message': data['detail'] ?? 'Giriş başarısız.'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Sunucuya bağlanılamadı. Lütfen tekrar deneyin.'};
    }
  }

  // ─── Kullanıcı Bilgisi ────────────────────────────────────
  /// Token ile giriş yapmış kullanıcının bilgilerini getirir.
  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final token = await getToken();
      if (token == null) {
        return {'success': false, 'message': 'Oturum bulunamadı.'};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'user': data};
      } else {
        // Token geçersiz ise temizle
        await logout();
        return {'success': false, 'message': data['detail'] ?? 'Oturum doğrulanamadı.'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Sunucuya bağlanılamadı.'};
    }
  }

  // ─── Çıkış Yap ───────────────────────────────────────────
  /// Token ve kullanıcı bilgilerini yerel depolamadan siler.
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // ─── Token Yönetimi ──────────────────────────────────────

  /// Kayıtlı JWT token'ı döndürür.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Token'ı SharedPreferences'a kaydeder.
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Kullanıcı bilgilerini SharedPreferences'a kaydeder.
  static Future<void> _saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));
  }

  /// Kayıtlı kullanıcı bilgilerini döndürür.
  static Future<Map<String, dynamic>?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(_userKey);
    if (userStr != null) {
      return jsonDecode(userStr);
    }
    return null;
  }

  /// Kullanıcının giriş yapıp yapmadığını kontrol eder.
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
