import 'package:assfiex_app_it14/employee_side/pages/createschedpages/databaseCreateSched.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting dates

final TextEditingController nicknameController = TextEditingController();
final TextEditingController positionController = TextEditingController();
final TextEditingController hoursController = TextEditingController();
final TextEditingController startController = TextEditingController();
final TextEditingController endController = TextEditingController();
final TextEditingController dateController =
    TextEditingController(); // New controller for date

List<String> nicknameSuggestions = []; // List to store nickname suggestions

void clearTextFields() {
  nicknameController.clear();
  positionController.clear();
  hoursController.clear();
  startController.clear();
  endController.clear();
  dateController.clear(); // Clear the date input field as well
}

// Function to fetch nickname suggestions from Firebase
void getNicknameSuggestions(String query) async {
  if (query.isEmpty) {
    nicknameSuggestions.clear();
    return;
  }

  // Fetch nicknames from Firestore based on input
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Employee')
      .where('Nickname', isGreaterThanOrEqualTo: query)
      .where('Nickname', isLessThanOrEqualTo: query + '\uf8ff')
      .get();

  nicknameSuggestions =
      snapshot.docs.map((doc) => doc['Nickname'] as String).toList();
}

// Function to validate if the entered nickname exists in Firestore
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
              // Date Picker inside StatefulBuilder
              Future<void> _selectDate(BuildContext context) async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    dateController.text =
                        formattedDate; // Set formatted date in the controller
                  });
                }
              }

              return SingleChildScrollView(
                child: Column(
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
                    const SizedBox(height: 20),

                    // TextField for nickname
                    TextField(
                      controller: nicknameController,
                      decoration: const InputDecoration(
                        labelText: "Nickname",
                      ),
                    ),
                    const SizedBox(height: 20),

                    // TextField for position
                    TextField(
                      controller: positionController,
                      decoration: const InputDecoration(
                        labelText: "Position",
                      ),
                    ),
                    const SizedBox(height: 20),

                    // TextField for hours
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: hoursController,
                      decoration: const InputDecoration(
                        labelText: "Hours",
                      ),
                    ),
                    const SizedBox(height: 20),

                    // TextField for start time
                    TextField(
                      controller: startController,
                      decoration: const InputDecoration(
                        labelText: "Start",
                        hintText: "6am",
                      ),
                    ),
                    const SizedBox(height: 20),

                    // TextField for end time
                    TextField(
                      controller: endController,
                      decoration: const InputDecoration(
                        labelText: "End",
                        hintText: "12pm",
                      ),
                    ),
                    const SizedBox(height: 20),

                    // TextField for custom date input (new field)
                    TextField(
                      controller: dateController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: 'Schedule Date:',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Add Schedule Button
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 6, 83, 146),
                            Color.fromARGB(255, 100, 206, 255),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.all(3.0),
                      child: ElevatedButton(
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

                          // Validate the date format entered by the user
                          String enteredDate = dateController.text.trim();
                          if (enteredDate.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "Date is required",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            return;
                          }
                          // Parse the entered date to check validity
                          try {
                            DateFormat('yyyy-MM-dd').parseStrict(enteredDate);
                          } catch (e) {
                            Fluttertoast.showToast(
                              msg:
                                  "Invalid date format. Please use yyyy-MM-dd.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            return;
                          }

                          // Proceed with adding the schedule
                          String scheduleId = randomNumeric(5);
                          Map<String, dynamic> createSchedInfoMap = {
                            "ScheduleID": scheduleId,
                            "Nickname": nicknameController.text,
                            "Position": positionController.text,
                            "Hours": hoursController.text,
                            "Start": startController.text,
                            "End": endController.text,
                            "CreatedDate": enteredDate, // Use the entered date
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
                              fontSize: 16.0,
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'ADD',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      });
}
