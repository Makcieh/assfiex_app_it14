import 'package:flutter/material.dart';

// ignore: camel_case_types
class Employee_ButtonMenu extends StatelessWidget {
  const Employee_ButtonMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 100),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue, // Text color
            padding: const EdgeInsets.symmetric(
                horizontal: 30, vertical: 12), // Button size and padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
            elevation: 2, // Elevation to match the "raised" effect
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/employee_try');
          },
          child: const Center(
            child: Icon(
              Icons.add,
              color: Color.fromARGB(255, 255, 255, 255),
              size: 60,
            ),
          ),
        ),
      ),
    );
  }
}
