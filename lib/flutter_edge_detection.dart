/// A Flutter plugin for real-time edge detection and document scanning with advanced image processing capabilities.
library flutter_edge_detection;

import 'dart:async';

import 'package:flutter/services.dart';

/// A Flutter plugin for real-time edge detection and document scanning with advanced image processing capabilities.
class FlutterEdgeDetection {
  static const MethodChannel _channel = MethodChannel('flutter_edge_detection');

  /// Call this method to scan the object edge in live camera.
  ///
  /// [saveTo] is the file path where the cropped image will be saved.
  /// [canUseGallery] determines if the user can switch to gallery mode.
  /// [androidScanTitle] is the title for the scan screen on Android.
  /// [androidCropTitle] is the title for the crop button on Android.
  /// [androidCropBlackWhiteTitle] is the title for the black/white filter button on Android.
  /// [androidCropReset] is the title for the reset button on Android.
  ///
  /// Returns `true` if the operation was successful, `false` otherwise.
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

  /// Call this method to scan the object edge from a gallery image.
  ///
  /// [saveTo] is the file path where the cropped image will be saved.
  /// [androidCropTitle] is the title for the crop button on Android.
  /// [androidCropBlackWhiteTitle] is the title for the black/white filter button on Android.
  /// [androidCropReset] is the title for the reset button on Android.
  ///
  /// Returns `true` if the operation was successful, `false` otherwise.
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
  /// The error code.
  final String code;

  /// The error message.
  final String message;

  /// Additional error details.
  final dynamic details;

  const EdgeDetectionException({
    required this.code,
    required this.message,
    this.details,
  });

  @override
  String toString() => 'EdgeDetectionException($code, $message)';
}
