import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash:generateContent';

  /// Get Gemini API key from .env file
  static String? get _apiKey => dotenv.env['GEMINI_API_KEY'];

  /// Generate a product description using Gemini AI
  ///
  /// [productName] - The name of the product
  /// [maxCharacters] - Maximum characters for the description (default: 300)
  /// Returns the generated description or null if failed
  static Future<String?> generateProductDescription({
    required String productName,
    int maxCharacters = 300,
  }) async {
    try {
      // Get API key from .env
      final apiKey = _apiKey;
      if (apiKey == null || apiKey.isEmpty) {
        if (kDebugMode) {
          print('❌ Gemini API key not found in .env file');
        }
        return null;
      }

      final url = Uri.parse('$_baseUrl?key=$apiKey');

final prompt = '''
You are writing product descriptions for a Pakistani online grocery store. 
Your task: Write a compelling, specific, and accurate description for "$productName".

Rules:
- Be accurate: If you know what "$productName" is, describe it precisely.
- If unsure, infer logically from the name but do NOT add unrelated items.
- Mention taste, texture, packaging size, and brand details if relevant.
- Keep it appealing but realistic, no overhype.
- Max $maxCharacters characters.
- Output ONLY the description text, no intro or formatting.
- DONT WRITE AVAILABILITY, OR QUANTITY.

Example:
Product: "Cocomo"
Description: "Peek Freans Cocomo are crispy biscuits filled with rich chocolate cream, loved by kids and adults alike. Perfect for tea-time or on-the-go snacking."
''';



      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': prompt,
              },
            ],
          },
        ],
        'generationConfig': {
          'temperature': 0.7,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 1024,
        },
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (kDebugMode) {
          print('🔍 Gemini API Response: ${response.body}');
        }

        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          final description =
              data['candidates'][0]['content']['parts'][0]['text'];

          if (kDebugMode) {
            print('📝 Raw description from AI: $description');
          }

          // Clean up the response and ensure it's within character limit
          final cleanedDescription = description.trim();
          if (cleanedDescription.length <= maxCharacters) {
            return cleanedDescription;
          } else {
            // Truncate to max characters, trying to end at a word boundary
            final truncated = cleanedDescription.substring(0, maxCharacters);
            final lastSpaceIndex = truncated.lastIndexOf(' ');
            if (lastSpaceIndex > maxCharacters * 0.8) {
              // If we can find a space in the last 20%
              return truncated.substring(0, lastSpaceIndex) + '...';
            } else {
              return truncated + '...';
            }
          }
        }
      } else {
        if (kDebugMode) {
          print(
              '❌ Gemini API error: ${response.statusCode} - ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error generating product description: $e');
      }
    }

    return null;
  }

  /// Check if API key is configured in .env
  static bool isApiKeyConfigured() {
    final apiKey = _apiKey;
    return apiKey != null && apiKey.isNotEmpty;
  }
}
