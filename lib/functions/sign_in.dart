import 'dart:convert';
import 'dart:developer';
import 'package:flutter_home_widget/dto/ClassScheduleModel.dart';
import 'package:flutter_home_widget/model/database_helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<dynamic> signIn(
    BuildContext context, String username, String password) async {
  const uri = 'https://course-visualizer-proxy.onrender.com';

  try {
    final response = await http.post(Uri.parse(uri), headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded'
    }, body: <String, String>{
      'UserName': username,
      'Password': password,
    });

    if (response.statusCode == 200) {
      final jsonDecodedMap = jsonDecode(response.body);

      if (jsonDecodedMap['success']) {
        final result = jsonDecodedMap['result'];
        final semesterClassRoutine = result['semesterClassRoutine'];
        List<MapEntry<String, dynamic>> allSemestersData =
            semesterClassRoutine.entries.toList();

        List<SemesterRoutine> semesterRoutines = [];
        for (MapEntry<String, dynamic> semesterData in allSemestersData) {
          Map<String, dynamic> semesterDataMap = semesterData.value;

          String semesterName = semesterData.key;
          List<MapEntry<String, dynamic>> semesterDataInList =
              semesterDataMap.entries.toList();

          List<FullDaySchedule> weekSchedule = [];
          for (MapEntry<String, dynamic> singleDayData in semesterDataInList) {
            String day = singleDayData.key;
            var schedule = singleDayData.value;

            List<MapEntry<String, dynamic>> fullDayScheduleData =
                schedule.entries.toList();

            List<ClassData> classSlotsList = [];

            for (MapEntry<String, dynamic> singleClassSlot
                in fullDayScheduleData) {
              Map<String, dynamic> singleClassSlotMap = singleClassSlot.value;

              List<MapEntry<String, dynamic>> classesData =
                  singleClassSlotMap.entries.toList();

              String timeOfClass = singleClassSlot.key;
              Map<String, dynamic> dataOfClass = singleClassSlot.value;

              ClassData cl = ClassData(
                  courseName: dataOfClass['course_name'],
                  classId: dataOfClass['class_id'],
                  section: dataOfClass['section'],
                  classType: dataOfClass['type'],
                  credit: dataOfClass['credit'],
                  room: dataOfClass['room'],
                  time: timeOfClass);

              classSlotsList.add(cl);
            }

            FullDaySchedule fullDaySchedule =
                FullDaySchedule(classSlots: classSlotsList, day: day);
            weekSchedule.add(fullDaySchedule);
          }
          SemesterRoutine semesterRoutine =
              SemesterRoutine(days: weekSchedule, semester: semesterName);
          semesterRoutines.add(semesterRoutine);
        }
        AllSemesterRoutine allSemesterRoutine =
            AllSemesterRoutine(semesters: semesterRoutines);

        final databaseHelper = DatabaseHelper();
        // Open the database connection
        await databaseHelper.database;

        for (final sem in allSemesterRoutine.semesters) {
          var semId = await databaseHelper.insertSemester(sem);
          for (FullDaySchedule day in sem.days) {
            var dayId = await databaseHelper.insertDay(semId, day);

            for (ClassData classData in day.classSlots) {
              var classId =
                  await databaseHelper.insertClassData(dayId, classData);
            }
          }
        }
        return;
        // Insert the AllSemesterRoutine object
      } else {
        final message = jsonDecodedMap['message'];
        log("no success : $message");
        throw Exception('No Success');
      }
    } else {
      log("exception : $response");
      throw Exception('Failed to load data');
    }
  } catch (e) {
    log("Error : $e");
    throw Exception('Error occured');
  }
}
