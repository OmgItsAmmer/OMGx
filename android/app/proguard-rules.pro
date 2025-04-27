# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.plugin.editing.** { *; }

# Supabase
-keep class io.flutter.plugins.supabase.** { *; }
-keep class com.google.crypto.tink.** { *; }

# Keep your model classes 
-keep class com.yourpackage.models.** { *; }
-keepclassmembers class com.yourpackage.models.** { *; }

# Prevent name obfuscation of Flutter plugins
-keep class com.example.admin_dashboard_v3.** { *; }

# Keep sensitive data classes obfuscated
-keepattributes SourceFile,LineNumberTable
-keep class androidx.appcompat.widget.** { *; }

# Secure Storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Google Play Core
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-keep class com.google.android.play.core.** { *; }

# Remove your own debugging code in release
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
    public static int w(...);
    public static int e(...);
}

# Shrink unused code
-optimizations !code/simplification/arithmetic
-optimizationpasses 5

# Remove debug logs in release 
-assumenosideeffects class java.io.PrintStream {
    public void println(...);
    public void print(...);
} 