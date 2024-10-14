import 'package:assfiex_app_it14/employee_side/components/button_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class EmployeeHome extends StatefulWidget {
  const EmployeeHome({super.key});

  @override
  State<EmployeeHome> createState() => _HomeState();
}

class _HomeState extends State<EmployeeHome> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
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
        title: Container(
          padding: const EdgeInsets.only(left: 23),
          child: const Text(
            'WELCOME EMPLOYEE',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
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

          // Mudisplay ang mga employee sa calendar
          Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/icon/ASFIEXLOGO.png',
                  fit: BoxFit.cover,
                ),
              ),
              TableCalendar(
                focusedDay: focusedDay,
                firstDay: DateTime.utc(2024, 9, 24),
                lastDay: DateTime.utc(2030, 5, 6),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    this.selectedDay = selectedDay;
                    this.focusedDay = focusedDay;
                  });
                },
                selectedDayPredicate: (day) {
                  return isSameDay(selectedDay, day);
                },
                calendarStyle: const CalendarStyle(
                  defaultTextStyle:
                      TextStyle(color: Colors.white, fontSize: 16),
                  weekendTextStyle: TextStyle(color: Colors.blue, fontSize: 16),
                  selectedTextStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(color: Colors.white),
                  todayDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.white, fontSize: 14),
                  weekendStyle: TextStyle(color: Colors.blue, fontSize: 14),
                ),
                headerStyle: HeaderStyle(
                  titleTextStyle:
                      const TextStyle(color: Colors.white, fontSize: 18),
                  formatButtonTextStyle: const TextStyle(color: Colors.white),
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  leftChevronIcon: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  ),
                  rightChevronIcon: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                  titleCentered: true,
                  formatButtonVisible: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          // Real-time updates sa schedule basi sa date na nainput
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('CreateSched')
                  .where('CreatedDate', isEqualTo: formatDate(selectedDay))
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var schedules = snapshot.data!.docs.map((doc) {
                  return {
                    'start': doc['Start'],
                    'end': doc['End'],
                    'nickname': doc['Nickname'],
                    'position': doc['Position'],
                    'hours': doc['Hours'],
                    'scheduleId': doc['ScheduleID'],
                  };
                }).toList();

                if (schedules.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const Center(
                        child: Text(
                          "There are no schedules for this day",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7)),
                    child: ListView.builder(
                      itemCount: schedules.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              color: const Color.fromARGB(0, 75, 54, 54),
                              child: Container(
                                margin: const EdgeInsets.only(top: 2),
                                padding: const EdgeInsets.all(2),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topLeft,
                                    colors: [
                                      Color.fromARGB(255, 6, 83, 146),
                                      Color.fromARGB(255, 100, 206, 255),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: ListTile(
                                    title: Text(
                                      'Nickname: ${schedules[index]['nickname']}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Position: ${schedules[index]['position']}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Hours: ${schedules[index]['hours']}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'From: ${schedules[index]['start']} to ${schedules[index]['end']}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ));
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.only(left: 115),
                  child: const Employee_ButtonMenu()),
            ],
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}
