import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseStrings {
  static String get projectUrl => dotenv.env['SUPABASE_URL'] ?? "";
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? "";

  //SERVICE KEY IS PRIVATE DONT SHARE IT WITH ANYONE
  static String get servieRoleKey => dotenv.env['SUPABASE_SERVICE_KEY'] ?? "";
}
