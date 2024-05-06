import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // убрать кнопку возврата на предыдущую страницу
          // automaticallyImplyLeading: false,
          title: const Text('Главная страница'),
        ),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('главная страница')],
        ));
  }
}
