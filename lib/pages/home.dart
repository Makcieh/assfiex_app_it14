import 'package:assfiex_app_it14/components/button_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

DateTime today = DateTime.now();

// ignore: must_be_immutable
class Home extends StatelessWidget {
  Home({super.key});

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey,
                    child: const Text('SCHEDULE FOR THIS MONTH')),
              ],
            ),
          ),
          TableCalendar(
              focusedDay: today,
              firstDay: DateTime.utc(2024, 9, 24),
              lastDay: DateTime.utc(2030, 5, 6)),
          const SizedBox(height: 150),
          const ButtonMenu(),
        ],
      ),
    );
  }
}
