# Flutter Edge Detection

A Flutter plugin to detect edges of objects, scan paper, detect corners, and detect rectangles. It allows cropping of the detected object image and returns the path of the cropped image.

## Features

- 📱 **Cross-platform**: Works on both Android and iOS
- 📷 **Camera Integration**: Live camera scanning with edge detection
- 🖼️ **Gallery Support**: Process images from device gallery
- ✂️ **Smart Cropping**: Automatic edge detection and cropping
- 🎨 **Image Enhancement**: Black and white filter options
- 🔧 **Customizable UI**: Customizable button titles and labels
- 🛡️ **Error Handling**: Comprehensive error handling with custom exceptions

## Requirements

- Flutter: >=3.27.0
- Dart: >=3.0.0
- Android: API level 21+ (Android 5.0+)
- iOS: 13.0+

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_edge_detection: ^1.0.0
```

## Usage

### Basic Usage

```dart
import 'package:flutter_edge_detection/flutter_edge_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

// Scan with camera
Future<void> scanWithCamera() async {
  try {
    final directory = await getApplicationSupportDirectory();
    final imagePath = join(
      directory.path,
      'edge_detection_${DateTime.now().millisecondsSinceEpoch}.jpeg',
    );

    final success = await FlutterEdgeDetection.detectEdge(
      imagePath,
      canUseGallery: true,
      androidScanTitle: 'Scanning',
      androidCropTitle: 'Crop',
      androidCropBlackWhiteTitle: 'Black White',
      androidCropReset: 'Reset',
    );

    if (success) {
      print('Image saved to: $imagePath');
    } else {
      print('Scanning was cancelled');
    }
  } on EdgeDetectionException catch (e) {
    print('Error: ${e.message}');
  }
}

// Scan from gallery
Future<void> scanFromGallery() async {
  try {
    final directory = await getApplicationSupportDirectory();
    final imagePath = join(
      directory.path,
      'edge_detection_${DateTime.now().millisecondsSinceEpoch}.jpeg',
    );

    final success = await FlutterEdgeDetection.detectEdgeFromGallery(
      imagePath,
      androidCropTitle: 'Crop',
      androidCropBlackWhiteTitle: 'Black White',
      androidCropReset: 'Reset',
    );

    if (success) {
      print('Image saved to: $imagePath');
    } else {
      print('Processing was cancelled');
    }
  } on EdgeDetectionException catch (e) {
    print('Error: ${e.message}');
  }
}
```

### Error Handling

The plugin provides custom exceptions for better error handling:

```dart
try {
  await FlutterEdgeDetection.detectEdge(imagePath);
} on EdgeDetectionException catch (e) {
  print('Error Code: ${e.code}');
  print('Error Message: ${e.message}');
  print('Error Details: ${e.details}');
} catch (e) {
  print('Unexpected error: $e');
}
```

## API Reference

### FlutterEdgeDetection.detectEdge()

Scans an object using the camera with edge detection.

**Parameters:**

- `saveTo` (String): The file path where the cropped image will be saved
- `canUseGallery` (bool, optional): Whether to allow switching to gallery mode (default: true)
- `androidScanTitle` (String, optional): Title for the scan screen on Android (default: "Scanning")
- `androidCropTitle` (String, optional): Title for the crop button on Android (default: "Crop")
- `androidCropBlackWhiteTitle` (String, optional): Title for the black/white filter button on Android (default: "Black White")
- `androidCropReset` (String, optional): Title for the reset button on Android (default: "Reset")

**Returns:** `Future<bool>` - `true` if successful, `false` if cancelled

### FlutterEdgeDetection.detectEdgeFromGallery()

Processes an image from the gallery with edge detection.

**Parameters:**

- `saveTo` (String): The file path where the cropped image will be saved
- `androidCropTitle` (String, optional): Title for the crop button on Android (default: "Crop")
- `androidCropBlackWhiteTitle` (String, optional): Title for the black/white filter button on Android (default: "Black White")
- `androidCropReset` (String, optional): Title for the reset button on Android (default: "Reset")

**Returns:** `Future<bool>` - `true` if successful, `false` if cancelled

### EdgeDetectionException

Custom exception thrown when edge detection operations fail.

**Properties:**

- `code` (String): The error code
- `message` (String): The error message
- `details` (dynamic): Additional error details

## Permissions

### Android

Add the following permissions to your `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

### iOS

Add the following keys to your `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan documents</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to select images for scanning</string>
```

## Example

See the `example/` directory for a complete working example.

## Screenshots

![Android Screenshots](screenshots/android/)
![iOS Screenshots](screenshots/ios/)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes.

## Support

If you encounter any issues or have questions, please file an issue on the GitHub repository.
