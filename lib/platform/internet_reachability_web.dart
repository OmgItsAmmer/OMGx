import 'package:http/http.dart' as http;

/// Browser: use HTTP instead of dart:io DNS/socket checks.
Future<bool> canReachInternet() async {
  try {
    final response = await http
        .get(Uri.parse('https://www.gstatic.com/generate_204'))
        .timeout(const Duration(seconds: 8));
    return response.statusCode == 204 || response.statusCode == 200;
  } catch (_) {
    // CORS or offline — fall through to permissive check below.
  }
  try {
    final response = await http
        .head(Uri.parse('https://www.google.com'))
        .timeout(const Duration(seconds: 8));
    return response.statusCode >= 200 && response.statusCode < 500;
  } catch (_) {
    // If the browser has a network interface, avoid blocking the app.
    return true;
  }
}

/// Check Supabase (or any HTTPS API) via HTTP — sockets are unavailable on web.
Future<bool> canReachHost(String host, int port) async {
  final scheme = port == 443 || port == 0 ? 'https' : 'http';
  final effectivePort = port == 0 ? (scheme == 'https' ? 443 : 80) : port;
  final base = '$scheme://$host${effectivePort == 443 || effectivePort == 80 ? '' : ':$effectivePort'}';

  try {
    final response = await http
        .get(Uri.parse('$base/auth/v1/health'))
        .timeout(const Duration(seconds: 15));
    return response.statusCode >= 200 && response.statusCode < 500;
  } catch (_) {
    try {
      final response = await http
          .head(Uri.parse(base))
          .timeout(const Duration(seconds: 15));
      return response.statusCode > 0;
    } catch (_) {
      return true;
    }
  }
}
