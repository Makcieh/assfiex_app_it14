import 'package:assfiex_app_it14/manager_side/pages/requestpages/databaseRequest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllRequest extends StatefulWidget {
  const AllRequest({super.key});

  @override
  State<AllRequest> createState() => _AllRequestState();
}

class _AllRequestState extends State<AllRequest> {
  TextEditingController nicknameController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  String searchField = 'Nickname';
  String searchQuery = '';
  Stream? requestStream;

  List<DateTime?> selectedDates = [null];
  int selectedDays = 1;

  List<String> searchOptions = ['Nickname', 'Dates', 'Reason'];
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  getRequestStream() async {
    requestStream = await DatabaseMethods().getRequestDetails();
    setState(() {});
  }

  @override
  void initState() {
    getRequestStream();
    super.initState();
  }

  void handleSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  bool searchFilter(DocumentSnapshot ds) {
    if (searchField == 'Dates') {
      return ds['Dates'].toString().toLowerCase().contains(searchQuery);
    }
    return ds[searchField].toString().toLowerCase().contains(searchQuery);
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
                    .collection('RequestLeave')
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

  Widget allRequestDetails() {
    return StreamBuilder(
        stream: requestStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Requests found'));
          }

          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot db = snapshot.data.docs[index];

              if (!searchFilter(db)) {
                return const SizedBox.shrink();
              }

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
                            "Nickname: " + db['Nickname'],
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              nicknameController.text = db["Nickname"];
                              reasonController.text = db["Reason"];

                              selectedDates = List<DateTime>.from(
                                db['Dates'].map((date) {
                                  if (date is Timestamp) {
                                    return date.toDate();
                                  } else {
                                    return DateTime.parse(date);
                                  }
                                }),
                              );
                              selectedDays = selectedDates.length;

                              EditRequestDetail(db['RequestID']);
                            },
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              _showDeleteConfirmationDialog(context, db.id);
                            },
                            child: const Icon(
                              Icons.delete_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Reason: " + db['Reason'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Dates: " + db['Dates'].join(", "),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
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
            'All Request',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      // Search Bar
                      child: TextField(
                        controller: searchController,
                        onChanged: handleSearch,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search',
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
                      value: searchField,
                      dropdownColor: const Color.fromARGB(255, 6, 33, 55),
                      style: const TextStyle(color: Colors.white),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.white),
                      onChanged: (String? newValue) {
                        setState(() {
                          searchField = newValue!;
                        });
                      },
                      items: searchOptions
                          .map<DropdownMenuItem<String>>((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                    height: 530,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: Expanded(child: allRequestDetails()))
              ],
            ),
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
                        style: TextStyle(color: Colors.grey),
                        controller: nicknameController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Nickname',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        controller: reasonController,
                        decoration: const InputDecoration(
                          labelText: 'Reason',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
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
                                if (selectedDates.any((date) => date == null)) {
                                  return;
                                }

                                List<String> formattedDates = selectedDates
                                    .map((date) => dateFormat.format(date!))
                                    .toList();

                                Map<String, dynamic> updateRequestInfo = {
                                  "Nickname": nicknameController.text,
                                  "Reason": reasonController.text,
                                  "Dates": formattedDates,
                                };

                                await DatabaseMethods()
                                    .updateRequestDetail(id, updateRequestInfo)
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
                );
              },
            ),
          ),
        ),
      );

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
