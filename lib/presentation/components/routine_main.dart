import 'package:flutter/material.dart';
import 'package:flutter_home_widget/dto/ClassScheduleModel.dart';
import 'package:flutter_home_widget/presentation/components/DayRoutine.dart';
import 'package:flutter_home_widget/presentation/components/SemesterSelectDropdownMenu.dart';

Map<String, int> weekdayOrder = {
  "Monday": 1,
  "Tuesday": 2,
  "Wednesday": 3,
  "Thursday": 4,
  "Friday": 5,
  "Saturday": 6,
  "Sunday": 7,
};

class RoutineMain extends StatefulWidget {
  final List<SemesterRoutine> semesterRoutines;
  final int totalSemesterNumber;
  const RoutineMain(
      {super.key,
      required this.semesterRoutines,
      required this.totalSemesterNumber});

  @override
  State<RoutineMain> createState() => _RoutineMainState();
}

class _RoutineMainState extends State<RoutineMain> {
  int selectedSemesterIndex = 0;

  void setSelectedSemesterIndex(int index) {
    setState(() {
      selectedSemesterIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    setSelectedSemesterIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.semesterRoutines.isEmpty) {
      return const Text("Loading data...");
    }
    return Column(children: <Widget>[
      SemesterSelectDropdownMenu(
        semesterRoutines: widget.semesterRoutines,
        selectedSemesterIndex: selectedSemesterIndex,
        setSelectedSemesterIndex: setSelectedSemesterIndex,
      ),
      for (FullDaySchedule day
          in widget.semesterRoutines[selectedSemesterIndex].days)
        DayRoutine(fullDaySchedule: day),
    ]);
  }
}
