import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

/// Central utility helper for asynchronous, native hardware-accelerated image compression.
class ImageCompressUtil {
  /// Compresses a [File] image asynchronously.
  /// Returns a new compressed [File], or the original [File] if compression fails.
  static Future<File> compressImage(
    File originalFile, {
    int quality = 60,
    int minWidth = 1280,
    int minHeight = 1280,
  }) async {
    try {
      if (!await originalFile.exists()) {
        log("⚠️ Original file does not exist: ${originalFile.path}");
        return originalFile;
      }

      final Directory tempDir = await getTemporaryDirectory();
      final String targetPath =
          '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final XFile? compressedFile =
          await FlutterImageCompress.compressAndGetFile(
        originalFile.absolute.path,
        targetPath,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
        format: CompressFormat.jpeg,
      );

      if (compressedFile == null) {
        log("❌ Image compression returned null for: ${originalFile.path}");
        return originalFile;
      }

      final File finalFile = File(compressedFile.path);
      final int originalSize = await originalFile.length();
      final int compressedSize = await finalFile.length();

      log(
        "📸 Image Compressed Successfully:\n"
        "   Original Size: ${(originalSize / 1024).toStringAsFixed(2)} KB\n"
        "   Compressed Size: ${(compressedSize / 1024).toStringAsFixed(2)} KB\n"
        "   Path: ${finalFile.path}",
      );

      return finalFile;
    } catch (e) {
      log("❌ Image compression error: $e");
      return originalFile;
    }
  }

  /// Compresses an image given its file path string.
  /// Returns the compressed file path String, or null/original path on failure.
  static Future<String?> compressImagePath(
    String imagePath, {
    int quality = 60,
    int minWidth = 1280,
    int minHeight = 1280,
  }) async {
    final File originalFile = File(imagePath);
    final File compressedFile = await compressImage(
      originalFile,
      quality: quality,
      minWidth: minWidth,
      minHeight: minHeight,
    );
    return compressedFile.path;
  }

  /// Compresses a [File] image into [Uint8List] bytes.
  /// Useful for base64 encoding or binary transfers.
  static Future<Uint8List> compressImageBytes(
    File originalFile, {
    int quality = 60,
    int minWidth = 1280,
    int minHeight = 1280,
  }) async {
    try {
      if (!await originalFile.exists()) {
        return await originalFile.readAsBytes();
      }

      final Uint8List? bytes = await FlutterImageCompress.compressWithFile(
        originalFile.absolute.path,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
        format: CompressFormat.jpeg,
      );

      if (bytes != null && bytes.isNotEmpty) {
        return bytes;
      }

      return await originalFile.readAsBytes();
    } catch (e) {
      log("❌ Image compress bytes error: $e");
      return await originalFile.readAsBytes();
    }
  }
}
