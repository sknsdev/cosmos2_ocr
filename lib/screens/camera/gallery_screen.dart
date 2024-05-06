import 'dart:io';

import 'package:flutter/material.dart';

class GalleryScreen extends StatelessWidget {
  final String? imagePath;
  const GalleryScreen({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('asdasd'),
      ),
      body: Column(
        children: [
          Expanded(child: Image.file(File(imagePath!))),
        ],
      ),
    );
  }
}
