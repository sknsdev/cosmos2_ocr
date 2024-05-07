import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ocr_cosmos2/screens/auth/login_screen.dart';
import 'package:ocr_cosmos2/screens/camera/camera_screen.dart';
import 'package:ocr_cosmos2/screens/camera/gallery_screen.dart';
import 'package:ocr_cosmos2/screens/main_screen.dart';

final _key = GlobalKey<NavigatorState>();

final goRouterCustom = GoRouter(
  navigatorKey: _key,
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'auth',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/main_screen',
      name: 'main',
      builder: (context, state) => const MainScreen(title: 'Вы вошли'),
    ),
    GoRoute(
      path: '/camera_screen',
      name: 'camera',
      builder: (context, state) => const CameraScreen(),
    ),
    GoRoute(
      path: '/gallery_screen',
      name: 'gallery',
      builder: (context, state) =>
          GalleryScreen(imagePath: state.extra as String),
    ),
  ],
);
