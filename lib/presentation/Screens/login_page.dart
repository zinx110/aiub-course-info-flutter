import 'dart:convert';
import 'dart:developer';
import 'package:flutter_home_widget/dto/ClassScheduleModel.dart';
import 'package:flutter_home_widget/functions/sign_in.dart';
import 'package:flutter_home_widget/presentation/Screens/home_page.dart';
import 'package:flutter_home_widget/presentation/controller/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home_widget/presentation/components/my_button.dart';
import 'package:flutter_home_widget/presentation/components/my_testfield.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  final dynamic updateLoggedInState;

  const LoginPage({super.key, required this.updateLoggedInState});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errorMessage = '';
  void setErrorMessage(String errorMessage) {
    setState(() {
      this.errorMessage = errorMessage;
    });
  }

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign in method
  Future<dynamic> handleSubmit(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;
    // if (username == '' || password == '') {
    //   setErrorMessage("Please enter your Id and Password");
    //   return;
    // }
    try {
      context.loaderOverlay.show();
      await signIn(context, username, password);
      widget.updateLoggedInState(true);
      context.loaderOverlay.hide();
    } catch (e) {
      context.loaderOverlay.hide();
      setErrorMessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
          backgroundColor: Colors.grey[200],
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Icon(Icons.home, size: 100),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      'Welcome. Please enter your id and password',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    MyTextField(
                      controller: usernameController,
                      hintText: 'Username',
                      obscureText: false,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MyButton(
                      onTap: () => handleSubmit(context),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
