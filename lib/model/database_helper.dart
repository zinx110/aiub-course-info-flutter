import 'dart:developer';

import 'package:flutter_home_widget/dto/ClassScheduleModel.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String _databaseName = "AIUB.db";

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = "$dbPath/$_databaseName";
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Aiub (id INTEGER PRIMARY KEY  AUTOINCREMENT, name TEXT, value TEXT)');
      await db.execute('''
          CREATE TABLE IF NOT EXISTS semesters (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            semester TEXT NOT NULL
          )
          ''');
      await db.execute('''
          CREATE TABLE IF NOT EXISTS  days (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            semester_id INTEGER NOT NULL,
            day TEXT NOT NULL,
            FOREIGN KEY (semester_id) REFERENCES semesters(id)
          )
          ''');

      await db.execute('''
          CREATE TABLE IF NOT EXISTS  class_data (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            day_id INTEGER NOT NULL,
            course_name TEXT NOT NULL,
            class_id TEXT NOT NULL,
            credit INTEGER NOT NULL,
            section TEXT NOT NULL,
            class_type TEXT NOT NULL,
            room TEXT NOT NULL,
            time TEXT NOT NULL,
            FOREIGN KEY (day_id) REFERENCES days(id)
          )
          ''');
    });
  }

  Future<bool> dbExists() async {
    try {
      Database db = await DatabaseHelper().database;
      List<Map> result = await db.query('semesters');
      log("data exists : ${result.isNotEmpty}");
      return result.isNotEmpty;
    } catch (e) {
      log("exception in dbExists : $e");
      return false;
    }
  }

  Future<void> deleteTables() async {
    try {
      Database db = await DatabaseHelper().database;
      db.delete('Aiub');
      db.delete('semesters');
      db.delete('days');
      db.delete('class_data');
      return;
    } catch (e) {
      log('error $e');
      return;
    }
  }

  Future<dynamic> insertSemester(SemesterRoutine sem) async {
    try {
      Database db = await DatabaseHelper().database;

      await db.execute(
          'INSERT INTO semesters (semester) VALUES (?)', [sem.semester]);
      var semData = await db.rawQuery(
          'SELECT * FROM semesters WHERE semester = ?', [sem.semester]);
      var semDataSingle = semData[0];
      var semId = semDataSingle['id'];
      return semId;
    } catch (e) {
      throw Exception('error');
    }
  }

  Future<dynamic> insertDay(int semId, FullDaySchedule day) async {
    try {
      Database db = await DatabaseHelper().database;

      await db.execute(
          'INSERT INTO days (semester_id,day) VALUES (?,?)', [semId, day.day]);
      var dayData = await db.rawQuery(
          'SELECT * FROM days WHERE day = ? AND semester_id = ?',
          [day.day, semId]);
      var dayDataSingle = dayData[0];
      var dayId = dayDataSingle['id'];
      return dayId;
    } catch (e) {
      throw Exception('error');
    }
  }

  Future<dynamic> insertClassData(int dayId, ClassData data) async {
    try {
      Database db = await DatabaseHelper().database;

      await db.execute(
          'INSERT INTO class_data (day_id, course_name,class_id,credit,section,class_type,room,time) VALUES (?,?,?,?,?,?,?,?)',
          [
            dayId,
            data.courseName,
            data.classId,
            data.credit,
            data.section,
            data.classType,
            data.room,
            data.time
          ]);
      var classData = await db.rawQuery(
          'SELECT * FROM class_data WHERE day_id = ? AND course_name = ?',
          [dayId, data.courseName]);
      var classDataSingle = classData[0];
      var classId = classDataSingle['id'];
      return classId;
    } catch (e) {
      throw Exception('error');
    }
  }

  Future<List<SemesterRoutine>> getAllData() async {
    Database db = await DatabaseHelper().database;

    List<Map<String, Object?>> semDataRawList =
        await db.rawQuery('SELECT * FROM semesters');

    List<SemesterRoutine> semesters = [];
    for (Map<String, dynamic> semDataRaw in semDataRawList) {
      String semName = semDataRaw['semester'];
      int semId = semDataRaw['id'];

      List<Map<String, Object?>> dayDataRawList =
          await db.rawQuery('SELECT * FROM days WHERE semester_id = $semId');
      List<FullDaySchedule> daysDataList = [];
      for (Map<String, dynamic> dayDataRaw in dayDataRawList) {
        String dayName = dayDataRaw['day'];
        int dayId = dayDataRaw['id'];

        List<Map<String, Object?>> classDataRawList =
            await db.rawQuery('SELECT * FROM class_data WHERE day_id = $dayId');
        List<ClassData> fulldayDataList = [];
        for (Map<String, dynamic> classDataRaw in classDataRawList) {
          log('classDataRaw $classDataRaw');
          ClassData newClassData = ClassData(
              classId: classDataRaw['class_id'],
              classType: classDataRaw['class_type'],
              courseName: classDataRaw['course_name'],
              credit: classDataRaw['credit'],
              room: classDataRaw['room'],
              section: classDataRaw['section'],
              time: classDataRaw['time']);

          fulldayDataList.add(newClassData);
        }
        FullDaySchedule newFullDaySchedule =
            FullDaySchedule(day: dayName, classSlots: fulldayDataList);
        daysDataList.add(newFullDaySchedule);
      }
      SemesterRoutine newSemesterRoutine =
          SemesterRoutine(days: daysDataList, semester: semName);
      semesters.add(newSemesterRoutine);
    }
    return semesters;
  }
}
