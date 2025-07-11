import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String _apiUrl = "https://openrouter.ai/api/v1/chat/completions";

  // Make sure this is your valid OpenRouter API key
  static const String _apiKey = "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";

  static Future<String> sendMessage(String message) async {
    if (_apiKey.isEmpty) {
      throw Exception('API key is missing.');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
      'HTTP-Referer': 'https://yourapp.com', // Replace with your domain or any URL
      'X-Title': 'Motivfy Chat', // Optional but good practice
    };

    final body = jsonEncode({
      "model": "deepseek/deepseek-r1:free", // ✅ model must be exactly this
      "messages": [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": message}
      ],
      "temperature": 0.7
    });

    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      print('❌ ERROR: ${response.statusCode}');
      print(response.body);
      throw Exception('Failed to get response: ${response.body}');
    }
  }
}