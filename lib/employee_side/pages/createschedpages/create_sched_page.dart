import 'package:assfiex_app_it14/employee_side/pages/createschedpages/databaseCreateSched.dart';
import 'package:assfiex_app_it14/manager_side/pages/createschedpages/create_sched_fill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Employee_CreateSchedPage extends StatefulWidget {
  const Employee_CreateSchedPage({super.key});

  @override
  State<Employee_CreateSchedPage> createState() => _CreateSchedPageState();
}

class _CreateSchedPageState extends State<Employee_CreateSchedPage> {
  TextEditingController searchController = TextEditingController();
  String searchBy = 'Nickname';
  String searchQuery = '';
  Stream<QuerySnapshot>? scheduStream;

  List<String> searchOptions = [
    'Nickname',
    'Position',
    'Hours',
    'Start',
    'End'
  ];

  getSchedules() async {
    scheduStream =
        FirebaseFirestore.instance.collection('CreateSched').snapshots();
    setState(() {});
  }

  searchSchedules(String query) {
    if (query.isEmpty) {
      getSchedules();
    } else {
      if (searchBy == 'Hours' || searchBy == 'Start' || searchBy == 'End') {
        scheduStream = FirebaseFirestore.instance
            .collection('CreateSched')
            .where(searchBy, isGreaterThanOrEqualTo: query)
            .where(searchBy, isLessThanOrEqualTo: query + '\uf8ff')
            .snapshots();
      } else {
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
    getSchedules();
  }

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
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('CreateSched')
                    .doc(docId)
                    .delete();
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
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
                        Text(
                          "Scheduled Date: " + data['CreatedDate'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              "Nickname: " + data['Nickname'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
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
                      ],
                    ),
                  ),
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
          'All Schedules',
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
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: searchSchedules,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Search',
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
              SizedBox(height: 20),
              Container(
                  height: 470,
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
                    controller: nicknameController,
                    readOnly: true,
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
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: endController,
                    decoration: const InputDecoration(
                      labelText: 'End',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> updateSchedInfo = {
                            "Nickname": nicknameController.text,
                            "Position": positionController.text,
                            "Hours": hoursController.text,
                            "Start": startController.text,
                            "End": endController.text,
                          };
                          await DatabaseMethods()
                              .updateSchedDetail(id, updateSchedInfo)
                              .then((value) {
                            Navigator.pop(context);
                          });
                        },
                        child: const Text('Update')),
                  )
                ],
              ),
            ),
          ));
}
