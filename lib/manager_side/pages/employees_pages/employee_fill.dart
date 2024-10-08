import 'package:assfiex_app_it14/manager_side/pages/employees_pages/databaseEmployee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class EmployeeFill extends StatefulWidget {
  const EmployeeFill({super.key});

  @override
  State<EmployeeFill> createState() => _EmployeeState();
}

class _EmployeeState extends State<EmployeeFill> {
  TextEditingController nameController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController stationController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  void clearTextFields() {
    nameController.clear();
    nicknameController.clear();
    stationController.clear();
    positionController.clear();
    contactController.clear();
    dateController.clear();
    addressController.clear();
  }

  // Employee ID counter
  int employeeIdCounter = 100;

  Future<int> getStoredEmployeeId() async {
    return employeeIdCounter;
  }

  Future<void> saveEmployeeId(int newId) async {
    setState(() {
      employeeIdCounter = newId;
    });
  }

  // Date Picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        dateController.text =
            formattedDate; // Set formatted date in the controller
      });
    }
  }

  // Checking for duplicate nicknames
  Future<bool> _checkDuplicateNickname(String nickname) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Employee') // Use your Firestore collection name
        .where('Nickname', isEqualTo: nickname)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
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
          'Add Employees',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: 750,
        padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 25, right: 25, top: 0, bottom: 10),
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
                            color: Color.fromARGB(221, 0, 0, 0),
                            letterSpacing: 1.8),
                      ),
                      Container(
                        color: const Color.fromARGB(0, 255, 255, 255),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 30),

                            TextFormField(
                              controller: nicknameController,
                              decoration: const InputDecoration(
                                labelText: 'Nickname: ',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Name Field
                            TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'Name: ',
                                // labelStyle: TextStyle(
                                //   color: Color.fromARGB(255, 0, 0, 0),
                                // ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Nickname Field

                            // Contact Number Field
                            TextFormField(
                              controller: contactController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                labelText: 'Contact No:',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Station Trained Field
                            TextFormField(
                              controller: stationController,
                              decoration: const InputDecoration(
                                labelText: 'Station Trained:',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Position Field
                            TextFormField(
                              controller: positionController,
                              decoration: const InputDecoration(
                                labelText: 'Position:',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Date Employed Field
                            TextFormField(
                              controller: dateController,
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                labelText: 'Date Employed:',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () =>
                                      _selectDate(context), // Opens date picker
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Address Field
                            TextFormField(
                              controller: addressController,
                              decoration: const InputDecoration(
                                labelText: 'Address:',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Add Employee Button and will check if the nickname duplicates
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          child: ElevatedButton(
                            onPressed: () async {
                              // Check if any required field is empty
                              if (nameController.text.isEmpty ||
                                  nicknameController.text.isEmpty ||
                                  contactController.text.isEmpty ||
                                  stationController.text.isEmpty ||
                                  positionController.text.isEmpty ||
                                  dateController.text.isEmpty ||
                                  addressController.text.isEmpty) {
                                // Show error message if any field is empty
                                Fluttertoast.showToast(
                                  msg: "Please fill in all fields.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                return; // Stop execution if any field is empty
                              }

                              // Get the nickname from the input
                              String nickname = nicknameController.text.trim();

                              // Check if the nickname already exists
                              bool isDuplicate =
                                  await _checkDuplicateNickname(nickname);

                              if (isDuplicate) {
                                // Show error message if nickname already exists
                                Fluttertoast.showToast(
                                  msg:
                                      "Nickname already exists. Please choose another one.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              } else {
                                // If the nickname is unique, proceed to add the employee
                                String employeeaydi = randomNumeric(3);
                                Map<String, dynamic> employeeInfoMap = {
                                  "Id": employeeaydi,
                                  "Name": nameController.text,
                                  "Nickname": nickname,
                                  "Contact": contactController.text,
                                  "Station": stationController.text,
                                  "Position": positionController.text,
                                  "DateEmployed": dateController.text,
                                  "Address": addressController.text
                                };

                                clearTextFields();

                                await DatabaseMethods()
                                    .addEmployeeDetails(
                                        employeeInfoMap, employeeaydi)
                                    .then((value) {
                                  Fluttertoast.showToast(
                                    msg: "Employee Details Added",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 30.0),
                            ),
                            child: const Text(
                              'Add',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
