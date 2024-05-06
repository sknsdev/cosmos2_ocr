// экран камеры
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  final imgWidth = 300; // Image height
  final imgHeight = 100; // Image width

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final _cameras = await availableCameras();
    // final firstCamera = cameras.first;

    _controller = CameraController(
      _cameras![0],
      ResolutionPreset.ultraHigh,
    );
    await _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isCapturing = false;

  Future<void> _captureAndCrop() async {
    if (_isCapturing) {
      // If the previous capture is still ongoing, ignore new requests
      return;
    }
    _isCapturing = true;

    try {
      final XFile picture = await _controller.takePicture();

      context.push(
        '/gallery_screen',
        extra: picture.path,
      );
    } catch (e) {
      print('Error capturing picture: $e');
    } finally {
      _isCapturing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: imgWidth.toDouble(),
              height: imgHeight.toDouble(),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple, width: 2.0),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.purple,
            onPressed: _captureAndCrop,
            child: const Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
