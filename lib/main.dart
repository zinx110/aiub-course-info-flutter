import 'package:flutter/material.dart';
import 'package:flutter_home_widget/presentation/Screens/home_page.dart';
import 'package:flutter_home_widget/presentation/controller/auth_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Home Widget.',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthController(),
    );
  }
}
