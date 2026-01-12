import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart'; // ← Changed import
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_editor/video_editor.dart';

class VideoExporter {
  static Future<File?> exportReel(VideoEditorController controller) async {
    try {
      final dir = await getTemporaryDirectory();
      final outputPath =
          "${dir.path}/reel_${DateTime.now().millisecondsSinceEpoch}.mp4";

      // Get trim values in seconds
      final start = controller.startTrim.inSeconds;
      final duration = controller.trimmedDuration.inSeconds;

      // Crop calculations (same as before)
      final crop = controller.minCrop;
      final cropMax = controller.maxCrop;
      final video = controller.videoDimension;

      final cropW = ((cropMax.dx - crop.dx) * video.width).toInt();
      final cropH = ((cropMax.dy - crop.dy) * video.height).toInt();
      final cropX = (crop.dx * video.width).toInt();
      final cropY = (crop.dy * video.height).toInt();

      // FFmpeg command - same logic, just cleaner formatting
      final command = [
        '-ss', start.toString(),
        '-i', controller.file.path,
        '-t', duration.toString(),
        '-vf', 'crop=$cropW:$cropH:$cropX:$cropY',
        '-preset', 'ultrafast',
        '-movflags', '+faststart',
        '-y', // Overwrite output file if exists
        outputPath,
      ];

      // Execute using the new package
      final session = await FFmpegKit.executeWithArguments(command);

      // Check if successful
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        final file = File(outputPath);
        if (await file.exists()) {
          print('Export successful: $outputPath');
          return file;
        }
      } else {
        // Optional: Get logs for debugging
        final logs = await session.getLogs();
        final failStackTrace = await session.getFailStackTrace();
        print('Export failed with code: ${returnCode?.getValue()}');
        print('FFmpeg logs: ${logs.map((log) => log.getMessage()).join('\n')}');
        if (failStackTrace != null) {
          print('Fail stack trace: $failStackTrace');
        }
      }

      return null;
    } catch (e, stack) {
      print('Exception during video export: $e');
      print(stack);
      return null;
    }
  }
}