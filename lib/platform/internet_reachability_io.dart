import 'dart:io';

/// DNS lookup — works on mobile/desktop, not in the browser.
Future<bool> canReachInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}

/// TCP reachability for a host (e.g. Supabase).
Future<bool> canReachHost(String host, int port) async {
  try {
    final socket = await Socket.connect(
      host,
      port,
      timeout: const Duration(seconds: 15),
    );
    socket.destroy();
    return true;
  } catch (_) {
    return false;
  }
}
