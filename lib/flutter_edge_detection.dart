/// A Flutter plugin for real-time edge detection and document scanning
/// with advanced image processing capabilities.
library flutter_edge_detection;

import 'package:flutter/services.dart';

/// Provides static methods for performing edge detection and document scanning.
///
/// Use [detectEdge] to launch a live camera scanner and [detectEdgeFromGallery]
/// to process an image selected from the device gallery.
class FlutterEdgeDetection {
  static const MethodChannel _channel = MethodChannel('flutter_edge_detection');

  /// Scans an object using the device camera with edge detection.
  ///
  /// The cropped image is written to [saveTo], which must be a writable,
  /// absolute file path (for example, a path inside
  /// `getApplicationSupportDirectory()`).
  ///
  /// The [canUseGallery] flag determines whether the user can switch to the
  /// gallery from the camera UI.
  ///
  /// On Android, you can customize the scan UI by providing localized titles
  /// for [androidScanTitle], [androidCropTitle],
  /// [androidCropBlackWhiteTitle], and [androidCropReset].
  ///
  /// Returns `true` if the operation was successful and the image was saved,
  /// or `false` if the user cancelled the flow.
  ///
  /// Throws an [EdgeDetectionException] if the underlying platform call fails.
  static Future<bool> detectEdge(
    String saveTo, {
    bool canUseGallery = true,
    String androidScanTitle = 'Scanning',
    String androidCropTitle = 'Crop',
    String androidCropBlackWhiteTitle = 'Black White',
    String androidCropReset = 'Reset',
  }) async {
    try {
      final bool? result = await _channel.invokeMethod('edge_detect', {
        'save_to': saveTo,
        'can_use_gallery': canUseGallery,
        'scan_title': androidScanTitle,
        'crop_title': androidCropTitle,
        'crop_black_white_title': androidCropBlackWhiteTitle,
        'crop_reset_title': androidCropReset,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      throw EdgeDetectionException(
        code: e.code,
        message: e.message ?? 'Unknown error occurred',
        details: e.details,
      );
    }
  }

  /// Scans an object from an existing gallery image with edge detection.
  ///
  /// The cropped image is written to [saveTo], which must be a writable,
  /// absolute file path (for example, a path inside
  /// `getApplicationSupportDirectory()`).
  ///
  /// On Android, you can customize the crop UI by providing localized titles
  /// for [androidCropTitle], [androidCropBlackWhiteTitle], and
  /// [androidCropReset].
  ///
  /// Returns `true` if the operation was successful and the image was saved,
  /// or `false` if the user cancelled the flow.
  ///
  /// Throws an [EdgeDetectionException] if the underlying platform call fails.
  static Future<bool> detectEdgeFromGallery(
    String saveTo, {
    String androidCropTitle = 'Crop',
    String androidCropBlackWhiteTitle = 'Black White',
    String androidCropReset = 'Reset',
  }) async {
    try {
      final bool? result = await _channel.invokeMethod('edge_detect_gallery', {
        'save_to': saveTo,
        'crop_title': androidCropTitle,
        'crop_black_white_title': androidCropBlackWhiteTitle,
        'crop_reset_title': androidCropReset,
        'from_gallery': true,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      throw EdgeDetectionException(
        code: e.code,
        message: e.message ?? 'Unknown error occurred',
        details: e.details,
      );
    }
  }
}

/// Exception thrown when edge detection operations fail.
class EdgeDetectionException implements Exception {
  /// The error code returned by the platform implementation.
  final String code;

  /// A human-readable description of the error.
  final String message;

  /// Additional platform-specific error details, if available.
  final dynamic details;

  /// Creates a new [EdgeDetectionException].
  const EdgeDetectionException({
    required this.code,
    required this.message,
    this.details,
  });

  @override
  String toString() => 'EdgeDetectionException($code, $message)';
}
