import 'package:assfiex_app_it14/employee_side/pages/createschedpages/databaseCreateSched.dart';
import 'package:assfiex_app_it14/manager_side/pages/createschedpages/create_sched_fill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CreateSchedPage extends StatefulWidget {
  const CreateSchedPage({super.key});

  @override
  State<CreateSchedPage> createState() => _CreateSchedPageState();
}

class _CreateSchedPageState extends State<CreateSchedPage> {
  TextEditingController searchController = TextEditingController();
  String searchBy = 'Nickname'; // Default search by Nickname
  String searchQuery = '';
  Stream<QuerySnapshot>? scheduStream;

  // Updated search options without 'Station' but with 'Hours', 'Start', and 'End'
  List<String> searchOptions = [
    'Nickname',
    'Position',
    'Hours',
    'Start',
    'End',
    'Created Date'
  ];

  // Load schedules without search
  getSchedules() async {
    scheduStream =
        FirebaseFirestore.instance.collection('CreateSched').snapshots();
    setState(() {});
  }

  searchSchedules(String query) {
    if (query.isEmpty) {
      // If search bar is empty, load all schedules
      getSchedules();
    } else {
      if (searchBy == 'Hours' || searchBy == 'Start' || searchBy == 'End') {
        // Numeric or string comparisons for Hours, Start, End
        scheduStream = FirebaseFirestore.instance
            .collection('CreateSched')
            .where(searchBy, isGreaterThanOrEqualTo: query)
            .where(searchBy, isLessThanOrEqualTo: query + '\uf8ff')
            .snapshots();
      } else if (searchBy == 'CreatedDate') {
        // Handle date query for CreatedDate
        // If only year is provided (e.g., '2024')
        if (RegExp(r"^\d{4}$").hasMatch(query)) {
          // Search by the entire year
          String startOfYear = query + '-01-01';
          String endOfYear = query + '-12-31';
          scheduStream = FirebaseFirestore.instance
              .collection('CreateSched')
              .where('CreatedDate', isGreaterThanOrEqualTo: startOfYear)
              .where('CreatedDate', isLessThanOrEqualTo: endOfYear)
              .snapshots();
        }
        // If year and month are provided (e.g., '2024-05')
        else if (RegExp(r"^\d{4}-\d{2}$").hasMatch(query)) {
          // Search by the entire month
          String startOfMonth = query + '-01';
          String endOfMonth = query + '-31'; // Simplified for all months
          scheduStream = FirebaseFirestore.instance
              .collection('CreateSched')
              .where('CreatedDate', isGreaterThanOrEqualTo: startOfMonth)
              .where('CreatedDate', isLessThanOrEqualTo: endOfMonth)
              .snapshots();
        }
        // If full date is provided (e.g., '2024-05-15')
        else if (RegExp(r"^\d{4}-\d{2}-\d{2}$").hasMatch(query)) {
          // Search for the exact date
          scheduStream = FirebaseFirestore.instance
              .collection('CreateSched')
              .where('CreatedDate', isEqualTo: query)
              .snapshots();
        } else {
          // Invalid date format, show nothing
          scheduStream = null;
        }
      } else {
        // Handle text fields (Nickname, Position)
        scheduStream = FirebaseFirestore.instance
            .collection('CreateSched')
            .where(searchBy, isGreaterThanOrEqualTo: query)
            .where(searchBy, isLessThanOrEqualTo: query + '\uf8ff')
            .snapshots();
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    // Load all schedules initially
    getSchedules();
  }

  // Confirming Delete
  void _showDeleteConfirmationDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this schedule?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Delete the document from Firestore
                await FirebaseFirestore.instance
                    .collection('CreateSched')
                    .doc(docId)
                    .delete();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

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

  Widget allCreateSchedDetails() {
    return StreamBuilder<QuerySnapshot>(
        stream: scheduStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No schedules found'));
          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot data = snapshot.data!.docs[index];

                return Material(
                  color: const Color.fromARGB(0, 75, 54, 54),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topLeft,
                          colors: [
                            Color.fromARGB(255, 6, 83, 146),
                            Color.fromARGB(255, 100, 206, 255),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Scheduled Date: " + data['CreatedDate'],
                                style: const TextStyle(color: Colors.white),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  nicknameController.text = data["Nickname"];
                                  positionController.text = data["Position"];
                                  hoursController.text = data["Hours"];
                                  startController.text = data["Start"];
                                  endController.text = data["End"];
                                  editSchedDetail(data["ScheduleID"]);
                                },
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  // Show confirmation dialog before deletion
                                  _showDeleteConfirmationDialog(
                                      context, data.id);
                                },
                                child: const Icon(
                                  Icons.delete_rounded,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          Text(
                            "Nickname: " + data['Nickname'],
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Position: " + data['Position'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            "Hours: " + data['Hours'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            "Start: " + data['Start'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            "End: " + data['End'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          // Display CreatedDate
                        ],
                      )),
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
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
          'Schedules',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        padding: EdgeInsets.only(bottom: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  // Search Bar
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: searchSchedules,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Search',
                        hintText: searchBy == 'CreatedDate' ? 'yyyy-MM-dd' : '',
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 71, 71, 71),
                        labelStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Dropdown for search filter
                  DropdownButton<String>(
                    value: searchBy,
                    items: searchOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        searchBy = newValue!;
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                    dropdownColor: const Color.fromARGB(255, 6, 33, 55),
                  ),
                  const SizedBox(width: 10),
                ],
              ),

              const SizedBox(height: 30),

              // Create Schedule Button
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
                  onPressed: () =>
                      createschedFill(context), // Call the method here
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
                    "Create Schedule",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                  height: 440,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Expanded(child: allCreateSchedDetails())),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future editSchedDetail(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Column(
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
                  const SizedBox(height: 10),
                  TextFormField(
                    style: const TextStyle(color: Colors.grey),
                    readOnly: true,
                    controller: nicknameController,
                    decoration: const InputDecoration(
                      labelText: 'Nickname',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: positionController,
                    decoration: const InputDecoration(
                      labelText: 'Station Trained',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: hoursController,
                    decoration: const InputDecoration(
                      labelText: 'Hours',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: startController,
                    decoration: const InputDecoration(
                      labelText: 'Start',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: endController,
                    decoration: const InputDecoration(
                      labelText: 'End',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: dateController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: 'Schedule Date:',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
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
                            Map<String, dynamic> updateSchedInfo = {
                              "Nickname": nicknameController.text,
                              "Position": positionController.text,
                              "Hours": hoursController.text,
                              "Start": startController.text,
                              "End": endController.text,
                              "CreatedDate": enteredDate,
                            };
                            await DatabaseMethods()
                                .updateSchedDetail(id, updateSchedInfo)
                                .then((value) {
                              Navigator.pop(context);
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
                            'Update',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  )
                ],
              ),
            ),
          ));
}
