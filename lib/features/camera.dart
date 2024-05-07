import 'dart:io';

import 'package:camera/camera.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:image/image.dart' as img;

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  const Camera({super.key, required this.cameras});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController cameraController; // Контроллер камеры
  late Future<void> cameraValue; // Инициализация камеры
  List<File> imagesList = []; // Список изображений
  bool isFlashOn = false; // Флаг для включения/выключения
  bool isRearCamera = true; // Флаг для выбора передней или задней камеры

  // Параметры для кадрирования
  final double imgWidth = 312;
  final double imgHeight = 104;

  Future<File> saveImage(XFile image) async {
    final downloadPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);

    // Create a new file in the download directory
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File('$downloadPath/$fileName');

    // Мега функция для сохранения изображения во временное хранилище и кадрирование в новый файл

    // Read image file as a list of bytes
    List<int> imageBytes = await image.readAsBytes();
    img.Image? originalImage = img.decodeImage(imageBytes);

    // Calculate the scale between the captured image and the display size
    final double scaleX =
        originalImage!.width / MediaQuery.of(context).size.width;
    final double scaleY =
        originalImage.height / MediaQuery.of(context).size.height;

    // Calculate the crop dimensions to match the red border, applying the scale factor
    int cropX =
        ((MediaQuery.of(context).size.width / 2 - imgWidth / 2) * scaleX)
            .toInt();
    int cropY =
        ((MediaQuery.of(context).size.height / 2 - imgHeight / 2) * scaleY)
            .toInt();
    int cropWidth = (imgWidth * scaleX).toInt();
    int cropHeight = (imgHeight * scaleY).toInt();

    // Ensure cropping within the image bounds
    cropX = cropX.clamp(0, originalImage.width - cropWidth);
    cropY = cropY.clamp(0, originalImage.height - cropHeight);

    img.Image croppedImage =
        img.copyCrop(originalImage, cropX, cropY, cropWidth, cropHeight);

    // Encode the cropped image to PNG and save to disk
    await file.writeAsBytes(img.encodePng(croppedImage));
    return file;
  }

  // Функция для запуска камеры
  void takePicture() async {
    XFile? image;

    if (cameraController.value.isTakingPicture ||
        !cameraController.value.isInitialized) {
      return;
    }

    // FLASH MODE
    if (isFlashOn == false) {
      await cameraController.setFlashMode(FlashMode.off);
    } else {
      await cameraController.setFlashMode(FlashMode.torch);
    }
    image = await cameraController.takePicture();

    if (cameraController.value.flashMode == FlashMode.torch) {
      setState(() {
        cameraController.setFlashMode(FlashMode.off);
      });
    }

    final file = await saveImage(image);
    setState(() {
      imagesList.add(file);
    });

    if (kDebugMode) {
      print('IMAGE $image'); // IMAGE Instance of 'XFile'
      print('IMAGE PATH ${image.path}'); // .../cache/CAP5727844755284016842.jpg
    }

    MediaScanner.loadMedia(path: file.path);
  }

  void startCamera(int camera) {
    cameraController = CameraController(
      widget.cameras[camera],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    cameraValue = cameraController.initialize();
  }

  // Запуск камеры
  @override
  void initState() {
    startCamera(0);
    super.initState();
  }

  // Завершение работы камеры
  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(255, 255, 255, .7),
        shape: const CircleBorder(),
        onPressed: takePicture,
        child: const Icon(
          Icons.camera_alt,
          size: 40,
          color: Colors.black87,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          FutureBuilder(
            future: cameraValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                  width: size.width,
                  height: size.height,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: 100,
                      child: CameraPreview(cameraController),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 5, top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isFlashOn = !isFlashOn;
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(50, 0, 0, 0),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: isFlashOn
                              ? const Icon(
                                  Icons.flash_on,
                                  color: Colors.white,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.flash_off,
                                  color: Colors.white,
                                  size: 30,
                                ),
                        ),
                      ),
                    ),
                    const Gap(10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isRearCamera = !isRearCamera;
                        });
                        isRearCamera ? startCamera(0) : startCamera(1);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(50, 0, 0, 0),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: isRearCamera
                              ? const Icon(
                                  Icons.camera_rear,
                                  color: Colors.white,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.camera_front,
                                  color: Colors.white,
                                  size: 30,
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // Оверлей для красной рамки
          Align(
            alignment: Alignment.center,
            child: Container(
              width: imgWidth,
              height: imgHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 3.0),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7, bottom: 75),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: imagesList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image(
                                height: 104,
                                width: 312,
                                opacity: const AlwaysStoppedAnimation(07),
                                image: FileImage(
                                  File(imagesList[index].path),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
