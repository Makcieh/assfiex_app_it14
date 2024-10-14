import 'package:assfiex_app_it14/manager_side/pages/requestpages/databaseRequest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';

class RequestFill extends StatefulWidget {
  const RequestFill({super.key});

  @override
  State<RequestFill> createState() => _RequestState();
}

class _RequestState extends State<RequestFill> {
  TextEditingController idController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  int selectedDays = 1;
  List<DateTime?> selectedDates = [null];

  Future<bool> isNicknameValid(String nickname) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Employee')
        .where('Nickname', isEqualTo: nickname)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Add Request Leave',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
        child: Container(
          padding: const EdgeInsets.all(50),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color.fromARGB(255, 255, 255, 255),
                width: 2.0,
              )),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "FILL IN DETAILS",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nicknameController,
                  decoration: const InputDecoration(
                    labelText: "NICKNAME",
                    hintText: "",
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      "Select Number of Days:  ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
                const SizedBox(height: 10),
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
                  child: ElevatedButton(
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

                      String RequestID = randomNumeric(5);
                      Map<String, dynamic> requestInfoMap = {
                        "RequestID": RequestID,
                        "EmployeeID": idController.text,
                        "Nickname": nicknameController.text,
                        "Dates": selectedDates
                            .map((date) => dateFormat.format(date!))
                            .toList(),
                      };

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

                        setState(() {
                          idController.clear();
                          nicknameController.clear();
                          selectedDates = [null];
                          selectedDays = 1;
                        });
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
                      'Add Request',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
}
