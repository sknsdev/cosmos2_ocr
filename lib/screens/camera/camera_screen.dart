import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ocr_cosmos2/screens/camera/camera.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription>? cameras; // Сделали nullable
  late Future<void> _initCameras;

  @override
  void initState() {
    super.initState();
    _initCameras = initializeCameras();
  }

  Future<void> initializeCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras(); // Присвоили значение переменной cameras
    setState(() {}); // Обновляем UI после получения списка камер
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initCameras,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            cameras != null) {
          // Проверяем, что cameras не равно null
          return Camera(
            cameras: cameras!,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
