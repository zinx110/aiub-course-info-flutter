import 'package:flutter/material.dart';
import 'package:flutter_home_widget/dto/ClassScheduleModel.dart';

class DayRoutine extends StatefulWidget {
  final FullDaySchedule fullDaySchedule;

  const DayRoutine({
    super.key,
    required this.fullDaySchedule,
  });

  @override
  State<DayRoutine> createState() => _DayRoutineState();
}

class _DayRoutineState extends State<DayRoutine> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Divider(color: Colors.black),
      Text(widget.fullDaySchedule.day,
          style: TextStyle(color: Colors.blue[200])),
      DataTable(
        dataRowMaxHeight: double.infinity,
        columns: const <DataColumn>[
          DataColumn(
            label: Expanded(
              child: Text(
                'Class Name',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Time',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Room',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ],
        rows: <DataRow>[
          for (ClassData classData in widget.fullDaySchedule.classSlots)
            DataRow(
              cells: <DataCell>[
                DataCell(Text(
                  classData.courseName,
                )),
                DataCell(Text(
                  classData.time,
                )),
                DataCell(Text(classData.room)),
              ],
            ),
        ],
      ),
    ]);
  }
}
