// ignore: file_names
import 'package:assfiex_app_it14/manager_side/pages/TA_pages/databaseTA.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TimeAvailPage extends StatefulWidget {
  const TimeAvailPage({super.key});

  @override
  State<TimeAvailPage> createState() => _TimeAvailPageState();
}

class _TimeAvailPageState extends State<TimeAvailPage> {
  TextEditingController nicknameController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController monController = TextEditingController();
  TextEditingController tuesController = TextEditingController();
  TextEditingController wedsController = TextEditingController();
  TextEditingController thursController = TextEditingController();
  TextEditingController friController = TextEditingController();
  TextEditingController satController = TextEditingController();
  TextEditingController sunController = TextEditingController();

  Stream? TimeAvailStream;

  getontheload() async {
    TimeAvailStream = await DatabaseMethods().getTimeAvailDetails();
    setState(() {});
  }

  searchTimeAvail(String query) {
    if (query.isEmpty) {
      getontheload(); // Load all data if query is empty
    } else {
      String field;

      // Map the selected field from dropdown to Firestore field names
      switch (selectedField) {
        case 'Monday':
          field = 'mon';
          break;
        case 'Tuesday':
          field = 'tues';
          break;
        case 'Wednesday':
          field = 'weds';
          break;
        case 'Thursday':
          field = 'thurs';
          break;
        case 'Friday':
          field = 'fri';
          break;
        case 'Saturday':
          field = 'sat';
          break;
        case 'Sunday':
          field = 'sun';
          break;
        default: // 'Nickname'
          field = 'nickname';
      }

      // Perform Firestore query on the selected field
      TimeAvailStream = FirebaseFirestore.instance
          .collection('TimeAvailability')
          .where(field, isGreaterThanOrEqualTo: query)
          .where(field, isLessThanOrEqualTo: query + '\uf8ff')
          .snapshots();

      setState(() {});
    }
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  bool isValidTimeFormat(String input) {
    // Regex for time format (e.g., "6am to 10pm" or "NA")
    final RegExp timeRegExp = RegExp(
        r'^(?:[1-9]|1[0-2])(am|pm)\s+to\s+(?:[1-9]|1[0-2])(am|pm)$|^NA$');
    return timeRegExp.hasMatch(input);
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Delete the document from Firestore
                await FirebaseFirestore.instance
                    .collection('TimeAvailability')
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

  Widget allTADetails() {
    return StreamBuilder(
      stream: TimeAvailStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No Time Availability found'));
        }
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];

                  return Container(
                      child: Material(
                    color: const Color.fromARGB(0, 75, 54, 54),
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
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
                              Text("Nickname: " + ds['nickname'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  nicknameController.text = ds["nickname"];
                                  monController.text = ds["mon"];
                                  tuesController.text = ds["tues"];
                                  wedsController.text = ds["weds"];
                                  thursController.text = ds["thurs"];
                                  friController.text = ds["fri"];
                                  satController.text = ds["sat"];
                                  sunController.text = ds["sun"];
                                  EditTimeAvailDetail(ds['Id']);
                                },
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () async {
                                  await DatabaseMethods()
                                      .deleteTimeAvailDetail(ds['Id']);
                                },
                                child: GestureDetector(
                                  onTap: () {
                                    _showDeleteConfirmationDialog(
                                        context, ds.id);
                                  },
                                  child: const Icon(
                                    Icons.delete_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Text("Monday: " + ds['mon'],
                              style: const TextStyle(color: Colors.white)),
                          Text("Tuesday: " + ds['tues'],
                              style: const TextStyle(color: Colors.white)),
                          Text("Wednesday: " + ds['weds'],
                              style: const TextStyle(color: Colors.white)),
                          Text("Thursday: " + ds['thurs'],
                              style: const TextStyle(color: Colors.white)),
                          Text("Friday: " + ds['fri'],
                              style: const TextStyle(color: Colors.white)),
                          Text("Saturday: " + ds['sat'],
                              style: const TextStyle(color: Colors.white)),
                          Text("Sunday: " + ds['sun'],
                              style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ));
                },
              )
            : const Center(child: Text('No data available'));
      },
    );
  }

// List of options for the dropdown
  List<String> searchOptions = [
    'Nickname',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  String selectedField = 'Nickname'; // Default selected option

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
        title: const Text('Time Availability',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
        padding: EdgeInsets.only(bottom: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        searchTimeAvail(value);
                      },
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255)),
                      decoration: InputDecoration(
                        labelText: 'Search Nickname',
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
                  // Dropdown Button for selecting field
                  DropdownButton<String>(
                    value: selectedField,
                    dropdownColor: Colors.grey[800],
                    iconEnabledColor: Colors.white,
                    items: searchOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          option,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedField = newValue!;
                      });
                    },
                  ),
                ],
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/addta');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: const Text('Add Time Availability',
                      style: TextStyle(letterSpacing: 1, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),

              Container(
                  height: 340,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Expanded(child: allTADetails())),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'NOTE: PLEASE DELETE CURRENT T.A WHEN CREATING NEW',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future EditTimeAvailDetail(String id) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SingleChildScrollView(
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
                    const SizedBox(width: 10),
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
                  controller: monController,
                  decoration: const InputDecoration(
                    labelText: 'Monday',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: tuesController,
                  decoration: const InputDecoration(
                    labelText: 'Tuesday',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: wedsController,
                  decoration: const InputDecoration(
                    labelText: 'Wednesday',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: thursController,
                  decoration: const InputDecoration(
                    labelText: 'Thursday',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: friController,
                  decoration: const InputDecoration(
                    labelText: 'Friday',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: satController,
                  decoration: const InputDecoration(
                    labelText: 'Saturday',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: sunController,
                  decoration: const InputDecoration(
                    labelText: 'Sunday',
                    border: OutlineInputBorder(),
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
                        // Validate time formats or "NA"
                        List<TextEditingController> controllers = [
                          monController,
                          tuesController,
                          wedsController,
                          thursController,
                          friController,
                          satController,
                          sunController,
                        ];

                        for (var controller in controllers) {
                          if (!isValidTimeFormat(controller.text.trim())) {
                            Fluttertoast.showToast(
                              msg:
                                  "Invalid time format in ${controller.text}. Please use '6am to 10pm' format or 'NA'.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            return;
                          }
                        }

                        // Update data
                        Map<String, dynamic> updateInfo = {
                          "nickname": nicknameController.text,
                          "mon": monController.text,
                          "tues": tuesController.text,
                          "weds": wedsController.text,
                          "thurs": thursController.text,
                          "fri": friController.text,
                          "sat": satController.text,
                          "sun": sunController.text,
                        };
                        await DatabaseMethods()
                            .updateTimeAvailDetail(id, updateInfo);
                        Navigator.pop(context);
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
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
