import 'package:assfiex_app_it14/manager_side/pages/requestpages/databaseRequest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';

class RequestBottomSheet extends StatefulWidget {
  const RequestBottomSheet({Key? key}) : super(key: key);

  @override
  _RequestBottomSheetState createState() => _RequestBottomSheetState();
}

class _RequestBottomSheetState extends State<RequestBottomSheet> {
  // Controllers for input fields
  TextEditingController idController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd'); // Date format

  int selectedDays = 1; // Default to 1 day
  List<DateTime?> selectedDates = [null]; // To store selected dates

// Validate Nickname
  Future<bool> isNicknameValid(String nickname) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Employee') // Adjust collection name as necessary
        .where('Nickname', isEqualTo: nickname)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  // Function to create the bottom sheet
  void createBottomSheet(BuildContext context) {
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
              TextField(
                controller: nicknameController,
                decoration: const InputDecoration(
                  labelText: "Nickname",
                ),
              ),
              const SizedBox(height: 20),

              // Dropdown for number of days selection
              Row(
                children: [
                  const Text("Select Number of Days: "),
                  DropdownButton<int>(
                    value: selectedDays,
                    items: [1, 2, 3, 4].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text("$value day(s)"),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedDays = newValue!;
                        selectedDates =
                            List<DateTime?>.filled(selectedDays, null);
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Date pickers for each day
              Text("Select Dates"),
              Column(
                children: List.generate(
                  selectedDays,
                  (index) => Row(
                    children: [
                      Text("Day ${index + 1}: "),
                      TextButton(
                        onPressed: () => _selectDate(context, index),
                        child: Text(
                          selectedDates[index] == null
                              ? "Select Date"
                              : dateFormat.format(selectedDates[index]!),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  // Validate that all dates have been selected
                  if (selectedDates.any((date) => date == null)) {
                    Fluttertoast.showToast(
                        msg: "Please select all the dates",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
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

                  // Generate request data
                  String RequestID = randomNumeric(5);
                  Map<String, dynamic> requestInfoMap = {
                    "RequestID": RequestID,
                    "Nickname": nicknameController.text,
                    "Dates": selectedDates
                        .map((date) => dateFormat.format(date!))
                        .toList(), // Store formatted dates
                  };

                  // Add request to the database
                  await DatabaseMethods()
                      .addRequest(requestInfoMap, RequestID)
                      .then((value) {
                    Fluttertoast.showToast(
                        msg: "Request Details Added",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0);

                    // Clear the text fields and reset the form after adding the request
                    idController.clear();
                    nicknameController.clear();
                    setState(() {
                      selectedDates = [null]; // Reset selected dates
                      selectedDays = 1; // Reset the number of days
                    });
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
          ),
        );
      },
    );
  }

  // Function to select date using date picker
  Future<void> _selectDate(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDates[index] = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Request Form")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => createBottomSheet(context),
          child: const Text("Create Request"),
        ),
      ),
    );
  }
}
