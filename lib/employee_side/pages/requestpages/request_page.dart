import 'package:assfiex_app_it14/employee_side/pages/requestpages/request_fill.dart';
import 'package:flutter/material.dart';

class Employee_RequestPage extends StatelessWidget {
  const Employee_RequestPage({super.key});

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
        title: const Text(
          'Request Leave',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),

            //see all request buttom
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      const Color.fromARGB(255, 61, 102, 135), // Text color
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 12), // Button size and padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  elevation: 2, // Elevation to match the "raised" effect
                ),
                child: const Text(
                  'SEE ALL REQUEST',
                  style: TextStyle(
                    letterSpacing: 3,
                  ),
                )),

            const SizedBox(
              height: 30,
            ),

            //text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 150, 195, 232),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color.fromARGB(255, 140, 185, 223),
                        width: 2)),
                child: const Text(
                  '\u2022 I would like to request a day the following dates:',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),

            //fill in details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Container(
                width: 280,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      width: 2.0,
                    )),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[
                            300], // Background color (light grey or any color)
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      child: const Text(
                        'FILL IN DETAILS',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ID:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " 123",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "NAME:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " MICHAEL",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "M O N T H | D A Y  | Y E A R",
                      style: TextStyle(
                          letterSpacing: 1,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "07",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "|",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "07",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "|",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "2024",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => createBottomSheet(context),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue, // Text color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12), // Button size and padding
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Rounded corners
                          ),
                          elevation:
                              2, // Elevation to match the "raised" effect
                        ),
                        child: const Text(
                          "ADD REQUEST",
                          style: TextStyle(
                            fontSize: 14, // Font size
                            fontWeight: FontWeight.bold, // Bold text
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            //note for client
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                'NOTE: ALL REQUEST SHOULD BE DONE AT LEAST  3 DAYS IN ADVANCE',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
