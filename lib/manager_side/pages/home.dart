import 'package:assfiex_app_it14/manager_side/components/button_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime today = DateTime.now();

  // Function to sign out the user
  void signUserOut() {
    FirebaseAuth.instance.signOut();
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
                      'SCHEDULE FOR EVERYDAY',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),

          // Calendar to display the current day with customized styles
          TableCalendar(
            focusedDay: today,
            firstDay: DateTime.utc(2024, 9, 24),
            lastDay: DateTime.utc(2030, 5, 6),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                today = selectedDay; // Set the selected day
              });
            },
            calendarStyle: CalendarStyle(
              defaultTextStyle: TextStyle(color: Colors.white, fontSize: 16),
              weekendTextStyle: TextStyle(color: Colors.red, fontSize: 16),
              selectedTextStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              selectedDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.white, fontSize: 14),
              weekendStyle: TextStyle(color: Colors.red, fontSize: 14),
            ),
            headerStyle: HeaderStyle(
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
              formatButtonTextStyle: TextStyle(color: Colors.white),
              formatButtonDecoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              titleCentered: true,
              formatButtonVisible: false, // Hide format button if not needed
            ),
          ),
          const SizedBox(height: 20),

          // StreamBuilder for real-time updates of schedules
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('CreateSched')
                  .snapshots(), // Listen to the 'CreateSched' collection
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Extracting schedules from the Firestore snapshot
                var schedules = snapshot.data!.docs.map((doc) {
                  return {
                    'employeeId': doc['EmployeeID'],
                    'start': doc['Start'],
                    'end': doc['End'],
                    'nickname': doc['Nickname'],
                    'position': doc['Position'],
                    'hours': doc['Hours'],
                    'scheduleId': doc['ScheduleID'],
                  };
                }).toList();

                return ListView.builder(
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
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          const ButtonMenu(),
        ],
      ),
    );
  }
}
