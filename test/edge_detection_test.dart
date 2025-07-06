import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_edge_detection/flutter_edge_detection.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('flutter_edge_detection');
  final log = <MethodCall>[];

  setUp(() {
    log.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      log.add(methodCall);
      // Return appropriate types based on method
      switch (methodCall.method) {
        case 'edge_detect':
          return true;
        case 'edge_detect_gallery':
          return true;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  group('FlutterEdgeDetection', () {
    test('detectEdges calls correct method with parameters', () async {
      const saveTo = '/test/path/result.jpg';
      const canUseGallery = true;
      const scanTitle = 'Custom Scan';
      const cropTitle = 'Custom Crop';
      const blackWhiteTitle = 'Custom BW';
      const resetTitle = 'Custom Reset';

      final result = await FlutterEdgeDetection.detectEdge(
        saveTo,
        canUseGallery: canUseGallery,
        androidScanTitle: scanTitle,
        androidCropTitle: cropTitle,
        androidCropBlackWhiteTitle: blackWhiteTitle,
        androidCropReset: resetTitle,
      );

      expect(log, hasLength(1));
      expect(log.first.method, 'edge_detect');
      expect(log.first.arguments, {
        'save_to': saveTo,
        'can_use_gallery': canUseGallery,
        'scan_title': scanTitle,
        'crop_title': cropTitle,
        'crop_black_white_title': blackWhiteTitle,
        'crop_reset_title': resetTitle,
      });
      expect(result, true);
    });

    test('detectEdgesFromGallery calls correct method with parameters', () async {
      const saveTo = '/test/path/result.jpg';
      const cropTitle = 'Custom Crop';
      const blackWhiteTitle = 'Custom BW';
      const resetTitle = 'Custom Reset';

      final result = await FlutterEdgeDetection.detectEdgeFromGallery(
        saveTo,
        androidCropTitle: cropTitle,
        androidCropBlackWhiteTitle: blackWhiteTitle,
        androidCropReset: resetTitle,
      );

      expect(log, hasLength(1));
      expect(log.first.method, 'edge_detect_gallery');
      expect(log.first.arguments, {
        'save_to': saveTo,
        'crop_title': cropTitle,
        'crop_black_white_title': blackWhiteTitle,
        'crop_reset_title': resetTitle,
        'from_gallery': true,
      });
      expect(result, true);
    });
  });
}
