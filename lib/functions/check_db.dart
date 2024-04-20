import 'dart:developer';

import 'package:flutter_home_widget/model/database_helper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<void> checkDb(dynamic updateLoggedInState) async {
  try {
    final databaseHelper = DatabaseHelper();
    bool exists = await databaseHelper.dbExists();
    updateLoggedInState(exists);
    return;
  } catch (e) {
    log('Exception happened in checkDb : $e');
    return;
  }
}
