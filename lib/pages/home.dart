import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

DateTime today = DateTime.now();

class Home extends StatelessWidget {
  Home({super.key});

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              onPressed: signUserOut,
              icon: const Icon(Icons.logout),
            )
          ],
          title: const Center(
            child: Text(
              'WELCOME TO ASFIEX',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Column(
          children: [
            const Text('Bruh'),
            TableCalendar(
                focusedDay: today,
                firstDay: DateTime.utc(2024, 9, 24),
                lastDay: DateTime.utc(2030, 5, 6)),
          ],
        ));
  }
}
