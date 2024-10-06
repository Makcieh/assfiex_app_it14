// ignore: file_names
import 'package:assfiex_app_it14/manager_side/pages/employees_pages/databaseEmployee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController stationController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  Stream? EmployeeStream;

  getontheload() async {
    EmployeeStream = await DatabaseMethods().getEmployeeDetails();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allEmployeeDetails() {
    return StreamBuilder(
        stream: EmployeeStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];

                    return Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 6, 33, 55),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Employee ID: " + ds['Id'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    nameController.text = ds["Name"];
                                    nicknameController.text = ds["Nickname"];
                                    contactController.text = ds["Contact"];
                                    stationController.text = ds["Station"];
                                    positionController.text = ds["Position"];
                                    dateController.text = ds["DateEmployed"];
                                    addressController.text = ds["Address"];
                                    EditEmployeeDetail(ds["Id"]);
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await DatabaseMethods()
                                        .deleteEmployeeDetail(ds['Id']);
                                  },
                                  child: const Icon(
                                    Icons.delete_rounded,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              "Name: " + ds['Name'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Nickname: " + ds['Nickname'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Contact: " + ds['Contact'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Station Trained: " + ds['Station'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Position: " + ds['Position'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Date Employed: " + ds['DateEmployed'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Address: " + ds['Address'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            'Employees',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/addemploye');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        const Color.fromARGB(255, 61, 102, 135), // Text color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12), // Button size and padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    elevation: 2, // Elevation to match the "raised" effect
                  ),
                  child: const Text(
                    'ADD EMPLOYEE',
                    style: TextStyle(
                      letterSpacing: 3,
                    ),
                  )),
              const SizedBox(
                height: 30,
              ),
              Expanded(child: allEmployeeDetails())
            ],
          ),
        ));
  }

  // ignore: non_constant_identifier_names
  Future EditEmployeeDetail(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Adjusts height based on content
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.cancel_rounded),
                        ),
                        const SizedBox(
                            width: 8), // Spacing between icon and text
                        const Text('Edit Details:')
                      ],
                    ),
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

                    // Date Employed Field with Date Picker
                    TextFormField(
                      controller: dateController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: 'Date Employed',
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
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                          onPressed: () async {
                            Map<String, dynamic> updateInfo = {
                              "Name": nameController.text,
                              "Nickname": nicknameController.text,
                              "Contact": contactController.text,
                              "Station": stationController.text,
                              "Position": positionController.text,
                              "DateEmployed": dateController.text,
                              "Address": addressController.text,
                            };
                            await DatabaseMethods()
                                .updateEmployeeDetail(id, updateInfo)
                                .then((value) {
                              Navigator.pop(context);
                            });
                          },
                          child: const Text('Update')),
                    )
                  ],
                ),
              ),
            ),
          ));

  // Function to open date picker and format the selected date
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }
}
