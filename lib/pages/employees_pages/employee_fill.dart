import 'package:assfiex_app_it14/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

class EmployeeFill extends StatefulWidget {
  const EmployeeFill({super.key});

  @override
  State<EmployeeFill> createState() => _EmployeeState();

  // Controllers to retrieve user inputs

  // Clear all fields
  // void _clearFields() {
  //   idController.clear();
  //   nameController.clear();
  //   nicknameController.clear();
  //   contactController.clear();
  //   stationController.clear();
  //   positionController.clear();
  //   dateController.clear();
  //   addressController.clear();
}

class _EmployeeState extends State<EmployeeFill> {
  TextEditingController nameController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController stationController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController addressController = TextEditingController();
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
            'Add Employees',
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
                    SizedBox(
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
                            controller: nicknameController,
                            decoration: const InputDecoration(
                              labelText: 'Nickname',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Contact Number Field
                          TextFormField(
                            controller: contactController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Contact No',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Station Trained Field
                          TextFormField(
                            controller: stationController,
                            decoration: const InputDecoration(
                              labelText: 'Station Trained',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Position Field
                          TextFormField(
                            controller: positionController,
                            decoration: const InputDecoration(
                              labelText: 'Position',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Date Employed Field
                          TextFormField(
                            controller: dateController,
                            decoration: const InputDecoration(
                              labelText: 'Date Employed',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.datetime,
                          ),
                          const SizedBox(height: 10),

                          // Address Field
                          TextFormField(
                            controller: addressController,
                            decoration: const InputDecoration(
                              labelText: 'Address',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Clear and Add Buttons
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                // ignore: non_constant_identifier_names
                                String Id = randomNumeric(5);
                                Map<String, dynamic> employeeInfoMap = {
                                  "Id": Id,
                                  "Name": nameController.text,
                                  "Nickname": nicknameController.text,
                                  "Contact": contactController.text,
                                  "Station": stationController.text,
                                  "Position": positionController.text,
                                  "DateEmployed": dateController.text,
                                  "Address": addressController.text
                                };
                                await DatabaseMethods()
                                    .addEmployeeDetails(employeeInfoMap, Id)
                                    .then((value) {
                                  Fluttertoast.showToast(
                                      msg: "Employee Details Added",
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
