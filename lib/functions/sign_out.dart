import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_home_widget/model/database_helper.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<dynamic> signOut(
    BuildContext context, dynamic updateLoggedInState) async {
  context.loaderOverlay.show();
  try {
    final databaseHelper = DatabaseHelper();
    await databaseHelper.deleteTables();
    updateLoggedInState(false);
    context.loaderOverlay.hide();
  } catch (e) {
    context.loaderOverlay.hide();
    AlertDialog(
      content: Text('error : $e'),
    );
  }
}
