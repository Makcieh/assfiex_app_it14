import 'package:assfiex_app_it14/manager_side/pages/createschedpages/databaseCreateSched.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final TextEditingController nicknameController = TextEditingController();
final TextEditingController positionController = TextEditingController();
final TextEditingController hoursController = TextEditingController();
final TextEditingController startController = TextEditingController();
final TextEditingController endController = TextEditingController();

List<String> nicknameSuggestions = [];

void clearTextFields() {
  nicknameController.clear();
  positionController.clear();
  hoursController.clear();
  startController.clear();
  endController.clear();
}

void getNicknameSuggestions(String query) async {
  if (query.isEmpty) {
    nicknameSuggestions.clear();
    return;
  }

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Employee')
      .where('Nickname', isGreaterThanOrEqualTo: query)
      .where('Nickname', isLessThanOrEqualTo: query + '\uf8ff')
      .get();

  nicknameSuggestions =
      snapshot.docs.map((doc) => doc['Nickname'] as String).toList();
}

Future<bool> isNicknameValid(String nickname) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Employee')
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
                  TextField(
                    controller: nicknameController,
                    decoration: const InputDecoration(
                      labelText: "Nickname",
                      hintText: "",
                    ),
                    onChanged: (value) {
                      setState(() {
                        getNicknameSuggestions(value);
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

                      String scheduleId = randomNumeric(5);
                      Map<String, dynamic> createSchedInfoMap = {
                        "ScheduleID": scheduleId,
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
                            backgroundColor:
                                const Color.fromARGB(255, 37, 123, 39),
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
