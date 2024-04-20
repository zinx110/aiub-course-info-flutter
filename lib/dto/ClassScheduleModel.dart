class AllSemesterRoutine {
  List<SemesterRoutine> semesters;
  AllSemesterRoutine({required this.semesters});
}

class SemesterRoutine {
  String semester;
  List<FullDaySchedule> days;
  SemesterRoutine({required this.days, required this.semester});
}

class FullDaySchedule {
  String day;
  List<ClassData> classSlots;
  FullDaySchedule({required this.day, required this.classSlots});
}

class ClassData {
  String courseName;
  String classId;
  int credit;
  String section;
  String classType;
  String room;
  String time;
  ClassData(
      {required this.courseName,
      required this.classId,
      required this.section,
      required this.classType,
      required this.credit,
      required this.time,
      required this.room});

  factory ClassData.fromMap(Map<String, dynamic> map) {
    return ClassData(
      courseName: map['course_name'] as String,
      classId: map['class_id'] as String,
      credit: map['credit'] as int,
      section: map['section'] as String,
      classType: map['class_type'] as String,
      room: map['room'] as String,
      time: map['time'] as String, // Optional time field
    );
  }
}
