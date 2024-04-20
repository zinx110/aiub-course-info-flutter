import 'dart:convert';
import 'dart:developer';

import 'package:flutter_home_widget/dto/ClassScheduleModel.dart';
import 'package:flutter_home_widget/model/database_helper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<void> getSemesterRoutine(dynamic updateData) async {
  try {
    final databaseHelper = DatabaseHelper();
    final data = await databaseHelper.getAllData();
    updateData(data);
  } catch (e) {
    log("exception in getSemesterRoutine $e");
  }
}
