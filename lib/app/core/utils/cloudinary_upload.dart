import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

/// =======================================================
/// CLOUDINARY UPLOAD UTILITY — FAITHCONNECT
/// =======================================================
class CloudinaryUpload {
  // 🌱 Loaded from .env
  static final String cloudName =
      dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';

  static final String profilePreset =
      dotenv.env['CLOUDINARY_PROFILE_PRESET'] ?? '';

  static final String postImagePreset =
      dotenv.env['CLOUDINARY_POST_IMAGE_PRESET'] ?? '';

  static final String postVideoPreset =
      dotenv.env['CLOUDINARY_POST_VIDEO_PRESET'] ?? '';

  static final String reelVideoPreset =
      dotenv.env['CLOUDINARY_REEL_VIDEO_PRESET'] ?? '';

  /// ─────────────────────────────────────────────
  /// UPLOAD IMAGE (Profile / Post Image)
  /// ─────────────────────────────────────────────
  static Future<String?> uploadImage(
    File imageFile, {
    required CloudinaryUploadType type,
  }) async {
    late final String preset;
    late final String folder;

    switch (type) {
      case CloudinaryUploadType.profile:
        preset = profilePreset;
        folder = "faithconnect/profiles";
        break;

      case CloudinaryUploadType.postImage:
        preset = postImagePreset;
        folder = "faithconnect/posts/images";
        break;

      default:
        throw Exception("Invalid image upload type");
    }

    return _uploadFile(
      file: imageFile,
      preset: preset,
      folder: folder,
      resourceType: "image",
    );
  }

  /// ─────────────────────────────────────────────
  /// UPLOAD VIDEO (Post Video / Reel)
  /// ─────────────────────────────────────────────
  static Future<String?> uploadVideo(
    File videoFile, {
    required CloudinaryUploadType type,
  }) async {
    late final String preset;
    late final String folder;

    switch (type) {
      case CloudinaryUploadType.postVideo:
        preset = postVideoPreset;
        folder = "faithconnect/posts/videos";
        break;

      case CloudinaryUploadType.reel:
        preset = reelVideoPreset;
        folder = "faithconnect/reels";
        break;

      default:
        throw Exception("Invalid video upload type");
    }

    return _uploadFile(
      file: videoFile,
      preset: preset,
      folder: folder,
      resourceType: "video",
    );
  }

  /// =======================================================
  /// INTERNAL UPLOADER
  /// =======================================================
  static Future<String?> _uploadFile({
    required File file,
    required String preset,
    required String folder,
    required String resourceType, // image | video
  }) async {
    try {
      if (cloudName.isEmpty || preset.isEmpty) {
        throw Exception("❌ Cloudinary env variables missing");
      }

      if (!file.existsSync()) {
        print("❌ File does not exist: ${file.path}");
        return null;
      }

      final uri = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/$resourceType/upload",
      );

      final multipartFile = await http.MultipartFile.fromPath(
        "file",
        file.path,
        contentType: resourceType == "video"
            ? MediaType("video", "mp4")
            : MediaType("image", "jpeg"),
      );

      final request = http.MultipartRequest("POST", uri)
        ..fields["upload_preset"] = preset
        ..fields["folder"] = folder
        ..fields["timestamp"] =
            DateTime.now().millisecondsSinceEpoch.toString()
        ..files.add(multipartFile);

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final json = jsonDecode(responseBody);
        return json["secure_url"] as String?;
      } else {
        print("❌ Cloudinary upload failed (${response.statusCode})");
        print(responseBody);
        return null;
      }
    } catch (e, stack) {
      print("❌ Cloudinary upload exception: $e");
      print(stack);
      return null;
    }
  }
}

/// =======================================================
/// UPLOAD TYPES
/// =======================================================
enum CloudinaryUploadType {
  profile,
  postImage,
  postVideo,
  reel,
}
