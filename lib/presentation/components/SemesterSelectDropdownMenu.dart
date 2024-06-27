import 'package:flutter/material.dart';
import 'package:flutter_home_widget/dto/ClassScheduleModel.dart';

class SemesterSelectDropdownMenu extends StatefulWidget {
  final List<SemesterRoutine> semesterRoutines;
  final int selectedSemesterIndex;
  final Function(int) setSelectedSemesterIndex;
  const SemesterSelectDropdownMenu(
      {super.key,
      required this.semesterRoutines,
      required this.selectedSemesterIndex,
      required this.setSelectedSemesterIndex});

  @override
  State<SemesterSelectDropdownMenu> createState() =>
      _SemesterSelectDropdownMenuState();
}

class _SemesterSelectDropdownMenuState
    extends State<SemesterSelectDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.semesterRoutines[widget.selectedSemesterIndex].semester,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (
        String? value,
      ) {
        int selectedIndex = widget.semesterRoutines.indexWhere(
          (SemesterRoutine routine) => routine.semester == value,
        );
        widget.setSelectedSemesterIndex(selectedIndex);
      },
      items: widget.semesterRoutines
          .map<DropdownMenuItem<String>>((SemesterRoutine value) {
        return DropdownMenuItem<String>(
          value: value.semester,
          child: Text(value.semester),
        );
      }).toList(),
    );
  }
}
