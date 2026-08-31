# ==============================================================================
# ProGuard / R8 Rules for GeoQuiz App
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. General Flutter & Reflection Metadata
# ------------------------------------------------------------------------------
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# ------------------------------------------------------------------------------
# 2. Google Mobile Ads SDK (com.google.android.gms:play-services-ads)
# Reference: https://developers.google.com/admob/android/quick-start
# ------------------------------------------------------------------------------
-keep class com.google.android.gms.ads.** { *; }
-keep public class com.google.ads.** { *; }
-keep class com.google.android.gms.common.** { *; }

# Preserve WebView JavaScript interfaces used by GMA SDK
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Preserve AdMob mediation adapters and custom events if used
-keep public class * extends com.google.android.gms.ads.mediation.MediationAdapter {
    public *;
}
-keep public class * extends com.google.android.gms.ads.mediation.customevent.CustomEvent {
    public *;
}

# ------------------------------------------------------------------------------
# 3. Drift & SQLite (sqlite3_flutter_libs / native bindings)
# Reference: https://drift.simonbinder.eu/
# ------------------------------------------------------------------------------
-keep class org.sqlite.** { *; }
-keep class com.simonbinder.sqlite3.** { *; }
-keepclasseswithmembernames class * {
    native <methods>;
}
