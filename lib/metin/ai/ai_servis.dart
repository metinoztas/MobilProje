// lib/metin/ai/ai_servis.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class AiServis {

  static Future<String> mesajGonder(String mesaj) async {

    try {

      final response = await http.post(

        Uri.parse("http://10.0.2.2:8000/ai"),

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode({
          "message": mesaj,
        }),
      );

      final data = jsonDecode(response.body);

      return data["reply"];

    } catch (e) {

      return "AI bağlantı hatası oluştu.";
    }
  }
}