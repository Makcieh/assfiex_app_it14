import 'package:flutter/material.dart';

class ButtonMenu extends StatelessWidget {
  const ButtonMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 100),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/try');
          },
          child: const Center(
            child: Icon(
              Icons.add_box_rounded,
              color: Colors.blue,
              size: 60,
            ),
          ),
        ),
      ),
    );
  }
}
