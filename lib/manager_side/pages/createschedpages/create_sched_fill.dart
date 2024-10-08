import 'package:assfiex_app_it14/manager_side/pages/createschedpages/databaseCreateSched.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firebase Firestore

final TextEditingController idController = TextEditingController();
final TextEditingController nicknameController = TextEditingController();
final TextEditingController positionController = TextEditingController();
final TextEditingController hoursController = TextEditingController();
final TextEditingController startController = TextEditingController();
final TextEditingController endController = TextEditingController();

List<String> nicknameSuggestions = []; // List to store nickname suggestions

void clearTextFields() {
  idController.clear();
  nicknameController.clear();
  positionController.clear();
  hoursController.clear();
  startController.clear();
  endController.clear();
}

// Function to fetch nickname suggestions from Firebase
void getNicknameSuggestions(String query) async {
  if (query.isEmpty) {
    nicknameSuggestions.clear();
    return;
  }

  // Fetch nicknames from Firestore based on input
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection(
          'Employee') // Replace 'nicknames' with your actual collection name
      .where('Nickname', isGreaterThanOrEqualTo: query)
      .where('Nickname',
          isLessThanOrEqualTo:
              query + '\uf8ff') // Ensure range query works correctly
      .get();

  // Map the results to a list of nicknames
  nicknameSuggestions =
      snapshot.docs.map((doc) => doc['Nickname'] as String).toList();
}

// Function to validate if the entered nickname exists in Firestore
Future<bool> isNicknameValid(String nickname) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Employee') // Adjust collection name as necessary
      .where('Nickname', isEqualTo: nickname)
      .limit(1)
      .get();

  return snapshot.docs.isNotEmpty;
}

void createschedFill(BuildContext context) {
  showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.blue[100],
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            right: 20,
            left: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: Text(
                      "Fill In Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // TextField for nickname with dynamic suggestions
                  TextField(
                    controller: nicknameController,
                    decoration: const InputDecoration(
                      labelText: "Nickname",
                      hintText: "",
                    ),
                    onChanged: (value) {
                      setState(() {
                        getNicknameSuggestions(
                            value); // Fetch suggestions on every change
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: positionController,
                    decoration: const InputDecoration(
                      labelText: "POSITION",
                      hintText: "",
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: hoursController,
                    decoration: const InputDecoration(
                      labelText: "HOURS",
                      hintText: "",
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: startController,
                    decoration: const InputDecoration(
                      labelText: "START",
                      hintText: "6am",
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: endController,
                    decoration: const InputDecoration(
                      labelText: "END",
                      hintText: "12pm",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Check if the nickname is empty
                      if (nicknameController.text.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "Nickname is required",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        return;
                      }

                      // Validate nickname from Firestore
                      bool isValidNickname =
                          await isNicknameValid(nicknameController.text.trim());

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

                      // Proceed with adding the schedule if validation passes
                      String scheduleId = randomNumeric(5);
                      Map<String, dynamic> createSchedInfoMap = {
                        "ScheduleID": scheduleId,
                        "EmployeeID": idController.text,
                        "Nickname": nicknameController.text,
                        "Position": positionController.text,
                        "Hours": hoursController.text,
                        "Start": startController.text,
                        "End": endController.text,
                      };

                      clearTextFields();

                      await DatabaseMethods()
                          .addCreateSched(createSchedInfoMap, scheduleId)
                          .then((value) {
                        Fluttertoast.showToast(
                            msg: "Schedule Details Added",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.green,
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
                ],
              );
            },
          ),
        );
      });
}
