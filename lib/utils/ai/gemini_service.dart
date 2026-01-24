import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = 'AIzaSyBUy6-focntjOOc1G-uRpNv8f43GgKSb-w';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';

  /// Generates a product description for a Pakistani karyana (grocery) product
  /// 
  /// [productName] - The name of the product
  /// Returns the generated description or throws an exception on error
  static Future<String> generateProductDescription(String productName) async {
    if (kDebugMode) {
      print('[GeminiService] Starting description generation for product: "$productName"');
    }

    // Try gemini-3.0-flash first, fallback to gemini-2.5-flash if not available
    try {
      if (kDebugMode) {
        print('[GeminiService] Attempting with model: gemini-3.0-flash');
      }
      return await _generateWithModel(productName, 'gemini-3.0-flash');
    } catch (e) {
      // Check if it's a 404 error (model not found)
      if (e.toString().contains('404') || 
          e.toString().contains('not found') || 
          e.toString().contains('NOT_FOUND')) {
        if (kDebugMode) {
          print('[GeminiService] ⚠️ gemini-3.0-flash not available, falling back to gemini-2.5-flash');
        }
        // Fallback to gemini-2.5-flash
        return await _generateWithModel(productName, 'gemini-2.5-flash');
      } else {
        // Re-throw if it's a different error
        rethrow;
      }
    }
  }

  /// Internal method to generate description with a specific model
  static Future<String> _generateWithModel(String productName, String modelName) async {
    final modelUrl = '$_baseUrl/$modelName:generateContent';
    
    if (kDebugMode) {
      print('[GeminiService] Using model: $modelName');
      print('[GeminiService] API URL: $modelUrl');
    }

    try {
      final url = Uri.parse('$modelUrl?key=$_apiKey');
      
      if (kDebugMode) {
        print('[GeminiService] Constructed URL: ${url.toString().replaceAll(_apiKey, '***API_KEY_HIDDEN***')}');
      }
      
      final prompt = '''
Generate a detailed, professional product description for a Pakistani karyana (grocery) product named "$productName".

The description should:
- Be in English
- Be at least 3-5 sentences long (minimum 80 words maximum 120 words)
- Highlight key features, quality, and benefits
- Be suitable for an e-commerce product listing
- Sound professional and appealing to customers
- Mention if it's commonly used in Pakistani cuisine (if applicable)
- Include details about packaging, quality, and usage

Product name: $productName

IMPORTANT: Generate a complete, full-length product description. Do not truncate or stop early. Write at least 3-5 detailed sentences.
''';

      if (kDebugMode) {
        print('[GeminiService] Prompt length: ${prompt.length} characters');
        print('[GeminiService] Request configuration: temperature=0.7, topK=40, topP=0.95, maxTokens=2048');
      }

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 2048,
        }
      };

      if (kDebugMode) {
        print('[GeminiService] Sending POST request to Gemini API...');
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          if (kDebugMode) {
            print('[GeminiService] ❌ Request timeout after 30 seconds');
          }
          throw Exception('Request timeout. Please try again.');
        },
      );

      if (kDebugMode) {
        print('[GeminiService] Response received');
        print('[GeminiService] Response status code: ${response.statusCode}');
        print('[GeminiService] Response body length: ${response.body.length} characters');
      }

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('[GeminiService] ✅ Successfully received response from API');
        }

        final responseData = json.decode(response.body);
        
        if (kDebugMode) {
          print('[GeminiService] Parsing response data...');
          print('[GeminiService] Response keys: ${responseData.keys.join(", ")}');
        }
        
        if (responseData['candidates'] != null && 
            responseData['candidates'].isNotEmpty &&
            responseData['candidates'][0]['content'] != null &&
            responseData['candidates'][0]['content']['parts'] != null &&
            responseData['candidates'][0]['content']['parts'].isNotEmpty) {
          
          final description = responseData['candidates'][0]['content']['parts'][0]['text'] as String;
          final trimmedDescription = description.trim();
          
          if (kDebugMode) {
            print('[GeminiService] ✅ Description generated successfully using $modelName');
            print('[GeminiService] Generated description length: ${trimmedDescription.length} characters');
            print('[GeminiService] Full description: $trimmedDescription');
            if (trimmedDescription.length < 100) {
              print('[GeminiService] ⚠️ WARNING: Description is shorter than expected (${trimmedDescription.length} chars)');
            }
          }
          
          return trimmedDescription;
        } else {
          if (kDebugMode) {
            print('[GeminiService] ❌ Invalid response format from Gemini API');
            print('[GeminiService] Response structure: ${json.encode(responseData)}');
          }
          throw Exception('Invalid response format from Gemini API');
        }
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error']?['message'] ?? 'Unknown error occurred';
        
        if (kDebugMode) {
          print('[GeminiService] ❌ API error response');
          print('[GeminiService] Status code: ${response.statusCode}');
          print('[GeminiService] Error message: $errorMessage');
          print('[GeminiService] Full error data: ${json.encode(errorData)}');
        }
        
        throw Exception('Gemini API error: $errorMessage');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[GeminiService] ❌ Exception occurred during description generation with $modelName');
        print('[GeminiService] Error type: ${e.runtimeType}');
        print('[GeminiService] Error message: ${e.toString()}');
      }
      
      if (e.toString().contains('timeout')) {
        rethrow;
      }
      throw Exception('Failed to generate description with $modelName: ${e.toString()}');
    }
  }
}
