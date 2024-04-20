import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_home_widget/functions/check_db.dart';
import 'package:flutter_home_widget/presentation/Screens/home_page.dart';
import 'package:flutter_home_widget/presentation/Screens/login_page.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AuthController extends StatefulWidget {
  const AuthController({super.key});

  @override
  State<AuthController> createState() => _AuthControllerState();
}

class _AuthControllerState extends State<AuthController> {
  bool? loggedIn; // Use nullable bool to indicate initial state

  void updateLoggedInState(bool isLoggedIn) {
    setState(() {
      loggedIn = isLoggedIn;
    });
  }

  @override
  void initState() {
    super.initState();
    checkDb(updateLoggedInState);
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        body: loggedIn == null // Show loading while checking Db
            ? const Center(
                child:
                    CircularProgressIndicator()) // Replace with desired loading indicator
            : (loggedIn!)
                ? HomePage(updateLoggedInState: updateLoggedInState)
                : LoginPage(updateLoggedInState: updateLoggedInState),
      ),
    );
  }
}
