import 'package:assfiex_app_it14/manager_side/pages/requestpages/databaseRequest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class AllRequest extends StatefulWidget {
  const AllRequest({super.key});

  @override
  State<AllRequest> createState() => _AllRequestState();
}

class _AllRequestState extends State<AllRequest> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  List<DateTime?> selectedDates = [null]; // To store the selected dates
  int selectedDays = 1; // Default to 1 day
  Stream? RequestStream;

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd'); // Date format

  getontheload() async {
    RequestStream = await DatabaseMethods().getRequestDetails();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allRequestDetails() {
    return StreamBuilder(
        stream: RequestStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot db = snapshot.data.docs[index];

                    return Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
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
                                  "Employee ID: " + db['EmployeeID'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    idController.text = db["EmployeeID"];
                                    nameController.text = db["Name"];

                                    // Fetch the dates from Firestore and convert to DateTime list
                                    selectedDates = List<DateTime>.from(
                                      db['Dates']
                                          .map((date) => DateTime.parse(date)),
                                    );
                                    selectedDays = selectedDates.length;

                                    EditRequestDetail(db['RequestID']);
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
                                        .deleteRequestDetail(db['RequestID']);
                                  },
                                  child: const Icon(
                                    Icons.delete_rounded,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              "Name: " + db['Name'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            // Display all the dates as a comma-separated string
                            Text(
                              "Dates: " + db['Dates'].join(", "),
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
            'All Request',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Expanded(child: allRequestDetails())
            ],
          ),
        ));
  }

  Future EditRequestDetail(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.cancel_rounded),
                            ),
                            const SizedBox(height: 60),
                            const Text('Edit Details:')
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: idController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Employee ID',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Dropdown for selecting number of days
                        Row(
                          children: [
                            const Text("Number of Days: "),
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
                                  selectedDates = List<DateTime?>.filled(
                                      selectedDays, null);
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Date pickers for each selected day
                        Column(
                          children: List.generate(
                            selectedDays,
                            (index) => Row(
                              children: [
                                Text("Day ${index + 1}: "),
                                TextButton(
                                  onPressed: () =>
                                      _selectDate(context, index, setState),
                                  child: Text(
                                    selectedDates[index] == null
                                        ? "Select Date"
                                        : dateFormat
                                            .format(selectedDates[index]!),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Center(
                          child: ElevatedButton(
                              onPressed: () async {
                                if (selectedDates.any((date) => date == null)) {
                                  // Ensure all dates are selected
                                  return;
                                }

                                List<String> formattedDates = selectedDates
                                    .map((date) => dateFormat.format(date!))
                                    .toList();

                                Map<String, dynamic> updateRequestInfo = {
                                  "EmployeeID": idController.text,
                                  "Name": nameController.text,
                                  "Dates":
                                      formattedDates, // Store dates list in Firestore
                                };

                                await DatabaseMethods()
                                    .updateRequestDetail(id, updateRequestInfo)
                                    .then((value) {
                                  Navigator.pop(context);
                                });
                              },
                              child: const Text('Update')),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ));

  // Function to select date using date picker
  Future<void> _selectDate(
      BuildContext context, int index, StateSetter setState) async {
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
