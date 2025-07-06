import 'dart:async';
import 'dart:io';
import 'package:flutter_edge_detection/flutter_edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edge Detection Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _imagePath;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Edge Detection Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _isProcessing ? null : _getImageFromCamera(context);
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Scan with Camera'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _isProcessing ? null : _getImageFromGallery(context);
              },
              icon: const Icon(Icons.photo_library),
              label: const Text('Upload from Gallery'),
            ),
            const SizedBox(height: 32),
            if (_isProcessing)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Processing...'),
                  ],
                ),
              ),
            if (_imagePath != null) ...[
              const Text(
                'Cropped image path:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _imagePath!,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(_imagePath!),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _getImageFromCamera(BuildContext context) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        if (mounted) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Camera permission is required'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

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

      if (mounted) {
        setState(() {
          if (success) {
            _imagePath = imagePath;
          }
        });

        if (success) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image processed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image processing was cancelled'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } on EdgeDetectionException catch (e) {
      if (mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unexpected error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _getImageFromGallery(BuildContext context) async {
    setState(() {
      _isProcessing = true;
    });

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

      if (mounted) {
        setState(() {
          if (success) {
            _imagePath = imagePath;
          }
        });

        if (success) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image processed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image processing was cancelled'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } on EdgeDetectionException catch (e) {
      if (mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unexpected error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}
