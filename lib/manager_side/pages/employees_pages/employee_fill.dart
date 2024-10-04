import 'package:assfiex_app_it14/manager_side/pages/employees_pages/databaseEmployee.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:random_string/random_string.dart';  // Remove this if not using random numbers anymore.

class EmployeeFill extends StatefulWidget {
  const EmployeeFill({super.key});

  @override
  State<EmployeeFill> createState() => _EmployeeState();
}

class _EmployeeState extends State<EmployeeFill> {
  // Controllers to retrieve user inputs
  TextEditingController nameController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController stationController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  // Replace the random number with an ID counter, starting at a given number
  int employeeIdCounter = 100; // Example starting point

  // Simulated storage for the employee ID counter
  Future<int> getStoredEmployeeId() async {
    // In a real implementation, you would retrieve this value from persistent storage (database/shared preferences)
    // For now, returning a static value to simulate storage
    return employeeIdCounter;
  }

  Future<void> saveEmployeeId(int newId) async {
    // In a real implementation, you would save this value to persistent storage (database/shared preferences)
    // Updating the counter in this simulation
    setState(() {
      employeeIdCounter = newId;
    });
  }

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

                          // Add Employee Button
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                // Retrieve the current ID counter from storage
                                int currentId = await getStoredEmployeeId();

                                // Increment the counter for the new employee
                                currentId++;

                                // Save the updated ID counter for future use
                                await saveEmployeeId(currentId);

                                // Use the updated counter as the employee ID
                                String employeeId = currentId.toString();

                                // Create the employee info map
                                Map<String, dynamic> employeeInfoMap = {
                                  "Id": employeeId,
                                  "Name": nameController.text,
                                  "Nickname": nicknameController.text,
                                  "Contact": contactController.text,
                                  "Station": stationController.text,
                                  "Position": positionController.text,
                                  "DateEmployed": dateController.text,
                                  "Address": addressController.text
                                };

                                // Save employee details to the database
                                await DatabaseMethods()
                                    .addEmployeeDetails(
                                        employeeInfoMap, employeeId)
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
