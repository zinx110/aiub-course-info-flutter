import 'package:flutter_home_widget/dto/ClassScheduleModel.dart';
import 'package:flutter_home_widget/functions/get_semester_routine.dart';
import 'package:flutter_home_widget/functions/sign_out.dart';
import 'package:flutter_home_widget/presentation/components/routine_main.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final dynamic updateLoggedInState;
  const HomePage({super.key, required this.updateLoggedInState});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SemesterRoutine> semestersData = [];

  void setRoutineData(List<SemesterRoutine> data) {
    setState(() {
      semestersData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getSemesterRoutine(setRoutineData);
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
                      height: 25,
                    ),
                    const Icon(Icons.home, size: 100),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Welcome. Please enter your id and password',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    RoutineMain(
                      semesterRoutines: semestersData,
                      totalSemesterNumber: semestersData.length,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    GestureDetector(
                      onTap: () => signOut(context, widget.updateLoggedInState),
                      child: const Text('Log Out'),
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
