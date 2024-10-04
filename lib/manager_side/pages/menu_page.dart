import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Menu',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/createschedpage');
                },
                child: const Text('createsched')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/timeavailpage');
                },
                child: const Text('TimeAvail')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/requestpage');
                },
                child: const Text('Request')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/employeepage');
                },
                child: const Text('Employees')),
          ],
        ));
  }
}
