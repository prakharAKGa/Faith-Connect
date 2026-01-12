# =============================================================================
# FLUTTER - MUST KEEP ALL FLUTTER CLASSES
# =============================================================================
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**
-keep class io.flutter.plugin.** { *; }

# =============================================================================
# PIGEON CHANNELS - THIS IS THE #1 FIX FOR YOUR CHANNEL-ERROR
# =============================================================================
-keep class dev.flutter.pigeon.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn dev.flutter.pigeon.**

# =============================================================================
# FIREBASE CORE & ALL FIREBASE LIBRARIES
# =============================================================================
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**
-keep class com.google.firebase.messaging.** { *; }
-keep class com.google.firebase.iid.** { *; }

# =============================================================================
# EXOPLAYER (better_player_plus uses it)
# =============================================================================
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**

# =============================================================================
# GENERAL ANDROID SUPPORT / MULTIDEX
# =============================================================================
-keep class androidx.** { *; }
-dontwarn androidx.**
-keep class com.google.** { *; }
-dontwarn com.google.**

# =============================================================================
# PREVENT R8 FROM REMOVING REFLECTION NEEDED BY PLUGINS
# =============================================================================
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# =============================================================================
# SAFE DEFAULTS (prevents random crashes in release)
# =============================================================================
-dontoptimize
-dontshrink
-keep class * { *; }  # ← Temporary nuclear option - remove after testing