import 'package:flutter/material.dart';

class ButtonMenu extends StatelessWidget {
  const ButtonMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue, // Text color
            padding: const EdgeInsets.symmetric(
                horizontal: 15, vertical: 6), // Button size and padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
            elevation: 2, // Elevation to match the "raised" effect
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/try');
          },
          child: const Center(
            child: Icon(
              Icons.add_rounded,
              color: Color.fromARGB(255, 255, 255, 255),
              size: 60,
            ),
          ),
        ),
      ),
    );
  }
}
