import 'package:assfiex_app_it14/employee_side/pages/components/button_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

DateTime today = DateTime.now();

// ignore: must_be_immutable
class EmployeeHome extends StatelessWidget {
  EmployeeHome({super.key});

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 17, 18),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topLeft,
              colors: [
                Color.fromARGB(255, 100, 206, 255),
                Color.fromARGB(255, 16, 133, 229)
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
        title: const Center(
          child: Text(
            'WELCOME TO ASFIEX',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[
                          300], // Background color (light grey or any color)
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      'SCHEDULE FOR THIS MONTH',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
          TableCalendar(
              focusedDay: today,
              firstDay: DateTime.utc(2024, 9, 24),
              lastDay: DateTime.utc(2030, 5, 6)),
          const SizedBox(height: 150),
          const Employee_ButtonMenu(),
        ],
      ),
    );
  }
}
