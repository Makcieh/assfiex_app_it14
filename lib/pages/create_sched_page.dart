import 'package:flutter/material.dart';

class CreateSchedPage extends StatelessWidget {
  const CreateSchedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      title: const Text(
        'Create Schedule',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ));
  }
}
