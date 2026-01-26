import 'package:flutter_dotenv/flutter_dotenv.dart';

/* -- LIST OF Constants used in APIs -- */

// Example
String get tSecretAPIKey => dotenv.get('SECRET_API_KEY', fallback: '');
