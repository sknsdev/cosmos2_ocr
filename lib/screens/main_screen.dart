import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ocr_cosmos2/components/common/my_button.dart';

class MainScreen extends StatelessWidget {
  final String title;
  const MainScreen({super.key, required this.title});

  void toScreenButton(BuildContext context) {
    context.push('/camera_screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // отключает стрелку назад
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text('Страница для информации'),
            const SizedBox(height: 50),
            MyButton(
              onTap: () => toScreenButton(context),
              title: 'Камера',
            ),
          ],
        ),
      ),
    );
  }
}
