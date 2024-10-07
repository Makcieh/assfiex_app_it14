import 'package:assfiex_app_it14/manager_side/components/button_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

DateTime today = DateTime.now();

// ignore: must_be_immutable
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  DateTime today = DateTime.now();
  List<Map<String, dynamic>> schedules = [];

  // Function to fetch and sort schedules by start time
  void fetchSchedules(String selectedDate) async {
    FirebaseFirestore.instance
        .collection(
            'CreateSched') // Assumes collection 'schedules' exists in Firestore
        .where('scheduleDate', isEqualTo: selectedDate)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        schedules = querySnapshot.docs
            .map((doc) => {
                  'employeeId': doc['EmployeeID'],
                  'start': doc['Start'],
                  'end': doc['End'],
                  'nickname': doc['Nickname'],
                  'position': doc['Position'],
                  'hours': doc['Hours'],
                  'scheduleId': doc['ScheduleID'],
                })
            .toList();

        // Sorting schedules by start time
        schedules.sort((a, b) {
          return a['start'].compareTo(b['start']);
        });
      });
    });
  }

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
        title: const Text(
          'WELCOME TO ASFIEX',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'SCHEDULE FOR THIS MONTH',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
          // Calendar to select dates
          TableCalendar(
              focusedDay: today,
              firstDay: DateTime.utc(2024, 9, 24),
              lastDay: DateTime.utc(2030, 5, 6),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  today = selectedDay;
                  fetchSchedules(selectedDay
                      .toIso8601String()
                      .split('T')[0]); // Fetch schedules for selected day
                });
              }),
          const SizedBox(height: 20),

          // Displaying the sorted schedules
          Expanded(
            child: ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Nickname: ${schedules[index]['nickname']}',
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Position: ${schedules[index]['position']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'From: ${schedules[index]['start']} to ${schedules[index]['end']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Hours: ${schedules[index]['hours']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),
          const ButtonMenu(),
        ],
      ),
    );
  }
}
