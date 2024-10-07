// import 'package:assfiex_app_it14/manager_side/pages/employees_pages/databaseEmployee.dart';
import 'package:assfiex_app_it14/manager_side/pages/TA_pages/databaseTA.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:random_string/random_string.dart';  // Remove this if not using random numbers anymore.

class TimeAvailFill extends StatefulWidget {
  const TimeAvailFill({super.key});

  @override
  State<TimeAvailFill> createState() => _TimeAvailState();
}

class _TimeAvailState extends State<TimeAvailFill> {
  // Controllers to retrieve user inputs
  TextEditingController nameController = TextEditingController();
  TextEditingController monController = TextEditingController();
  TextEditingController tuesController = TextEditingController();
  TextEditingController wedsController = TextEditingController();
  TextEditingController thursController = TextEditingController();
  TextEditingController friController = TextEditingController();
  TextEditingController satController = TextEditingController();
  TextEditingController sunController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
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
            'Add Time Availability',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "FILL IN DETAILS",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(221, 255, 255, 255),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20),

                          // Name Field
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Nickname Field
                          TextFormField(
                            controller: monController,
                            decoration: const InputDecoration(
                              labelText: 'Mon',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Contact Number Field
                          TextFormField(
                            controller: tuesController,
                            decoration: const InputDecoration(
                              labelText: 'Tues',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Station Trained Field
                          TextFormField(
                            controller: wedsController,
                            decoration: const InputDecoration(
                              labelText: 'Weds',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Position Field
                          TextFormField(
                            controller: thursController,
                            decoration: const InputDecoration(
                              labelText: 'Thurs',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Date Employed Field
                          TextFormField(
                            controller: friController,
                            decoration: const InputDecoration(
                              labelText: 'Fri',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.datetime,
                          ),
                          const SizedBox(height: 10),

                          // Address Field
                          TextFormField(
                            controller: satController,
                            decoration: const InputDecoration(
                              labelText: 'Sat',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: sunController,
                            decoration: const InputDecoration(
                              labelText: 'Sun',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Add Employee Button
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                // Create the time avail info map
                                Map<String, dynamic> timeAvailInfoMap = {
                                  "name": nameController.text,
                                  "mon": monController.text,
                                  "tues": tuesController.text,
                                  "weds": wedsController.text,
                                  "thurs": thursController.text,
                                  "fri": friController.text,
                                  "sat": satController.text,
                                  "sun": sunController.text
                                };

                                // Save employee details to the database
                                await DatabaseMethods()
                                    .addTimeAvailDetails(timeAvailInfoMap,
                                        AutofillHints.nameSuffix)
                                    .then((value) {
                                  Fluttertoast.showToast(
                                      msg: "Time Availability  Added",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 24.0),
                              ),
                              child: const Text('ADD'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
