import 'package:assfiex_app_it14/manager_side/pages/TA_pages/databaseTA.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

class TimeAvailFill extends StatefulWidget {
  const TimeAvailFill({super.key});

  @override
  State<TimeAvailFill> createState() => _TimeAvailState();
}

class _TimeAvailState extends State<TimeAvailFill> {
  TextEditingController nicknameController = TextEditingController();
  TextEditingController monController = TextEditingController();
  TextEditingController tuesController = TextEditingController();
  TextEditingController wedsController = TextEditingController();
  TextEditingController thursController = TextEditingController();
  TextEditingController friController = TextEditingController();
  TextEditingController satController = TextEditingController();
  TextEditingController sunController = TextEditingController();

  void clearTextField() {
    nicknameController.clear();
    monController.clear();
    tuesController.clear();
    wedsController.clear();
    thursController.clear();
    friController.clear();
    satController.clear();
    sunController.clear();
  }

  Future<bool> isNicknameValid(String nickname) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Employee')
        .where('Nickname', isEqualTo: nickname)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  bool isValidTimeFormat(String input) {
    // Regex for time format (e.g., "6am to 10pm" or "NA")
    final RegExp timeRegExp = RegExp(
        r'^(?:[1-9]|1[0-2])(am|pm)\s+to\s+(?:[1-9]|1[0-2])(am|pm)$|^NA$');
    return timeRegExp.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
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
                  const SizedBox(height: 30),
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
                          controller: nicknameController,
                          decoration: const InputDecoration(
                            labelText: 'Nickname',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Mon Field
                        TextFormField(
                          controller: monController,
                          decoration: const InputDecoration(
                            labelText: 'Mon',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Tues Field
                        TextFormField(
                          controller: tuesController,
                          decoration: const InputDecoration(
                            labelText: 'Tues',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Weds Field
                        TextFormField(
                          controller: wedsController,
                          decoration: const InputDecoration(
                            labelText: 'Weds',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Thurs Field
                        TextFormField(
                          controller: thursController,
                          decoration: const InputDecoration(
                            labelText: 'Thurs',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Fri Field
                        TextFormField(
                          controller: friController,
                          decoration: const InputDecoration(
                            labelText: 'Fri',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Sat Field
                        TextFormField(
                          controller: satController,
                          decoration: const InputDecoration(
                            labelText: 'Sat',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Sun Field
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
                              // Check if all fields are filled or contain "NA"
                              if (nicknameController.text.isEmpty ||
                                  monController.text.isEmpty ||
                                  tuesController.text.isEmpty ||
                                  wedsController.text.isEmpty ||
                                  thursController.text.isEmpty ||
                                  friController.text.isEmpty ||
                                  satController.text.isEmpty ||
                                  sunController.text.isEmpty) {
                                Fluttertoast.showToast(
                                  msg: "Please fill in all fields",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                return;
                              }

                              // Validate time formats or "NA"
                              List<TextEditingController> controllers = [
                                monController,
                                tuesController,
                                wedsController,
                                thursController,
                                friController,
                                satController,
                                sunController,
                              ];

                              for (var controller in controllers) {
                                if (!isValidTimeFormat(
                                    controller.text.trim())) {
                                  Fluttertoast.showToast(
                                    msg:
                                        "Invalid time format in ${controller.text}. Please use '6am to 10pm' format or 'NA'.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                  return;
                                }
                              }

                              // Validate nickname from Firestore
                              bool isValidNickname = await isNicknameValid(
                                  nicknameController.text.trim());

                              if (!isValidNickname) {
                                Fluttertoast.showToast(
                                  msg: "Nickname not found",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                return;
                              }

                              // Create the time avail info map
                              String TimeAvailID = randomNumeric(4);
                              Map<String, dynamic> timeAvailInfoMap = {
                                "Id": TimeAvailID,
                                "nickname": nicknameController.text,
                                "mon": monController.text,
                                "tues": tuesController.text,
                                "weds": wedsController.text,
                                "thurs": thursController.text,
                                "fri": friController.text,
                                "sat": satController.text,
                                "sun": sunController.text,
                              };

                              clearTextField();

                              // Save employee details to the database
                              await DatabaseMethods()
                                  .addTimeAvailDetails(
                                      timeAvailInfoMap, TimeAvailID)
                                  .then((value) {
                                Fluttertoast.showToast(
                                  msg: "Time Availability Added",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      const Color.fromARGB(255, 17, 255, 49),
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
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
      ),
    );
  }
}
