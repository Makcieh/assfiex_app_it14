import 'package:assfiex_app_it14/manager_side/pages/employees_pages/databaseEmployee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

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

  TextEditingController searchController = TextEditingController();
  String searchField = 'Name'; // Default search field
  String searchQuery = '';
  Stream? EmployeeStream;

  List<String> searchOptions = [
    'Name',
    'Nickname',
    'Station',
    'Position',
    'Date Employed', // Add Date Employed
    'Address', // Add Address
  ];

  getontheload() async {
    EmployeeStream = await DatabaseMethods().getEmployeeDetails();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
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
                    .collection('Employee')
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

  // Function to handle search input change
  void handleSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  // Filter function based on the selected search option
  bool searchFilter(DocumentSnapshot ds) {
    switch (searchField) {
      case 'Name':
        return ds['Name'].toString().toLowerCase().contains(searchQuery);
      case 'Nickname':
        return ds['Nickname'].toString().toLowerCase().contains(searchQuery);
      case 'Station':
        return ds['Station'].toString().toLowerCase().contains(searchQuery);
      case 'Position':
        return ds['Position'].toString().toLowerCase().contains(searchQuery);
      case 'Date Employed':
        return ds['DateEmployed']
            .toString()
            .toLowerCase()
            .contains(searchQuery);
      case 'Address':
        return ds['Address'].toString().toLowerCase().contains(searchQuery);
      default:
        return false;
    }
  }

  Widget allEmployeeDetails() {
    return StreamBuilder(
        stream: EmployeeStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Employee found'));
          }
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];

                    // Apply the search filter
                    if (!searchFilter(ds)) {
                      return const SizedBox
                          .shrink(); // Hide non-matching results
                    }

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
                                  Text(
                                    "Nickname: " + ds['Nickname'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      nameController.text = ds["Name"];
                                      nicknameController.text = ds["Nickname"];
                                      contactController.text = ds["Contact"];
                                      stationController.text = ds["Station"];
                                      positionController.text = ds["Position"];
                                      dateController.text = ds['DateEmployed'];
                                      addressController.text = ds['Address'];
                                      EditEmployeeDetail(ds['Id']);
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
                                    onTap: () {
                                      _showDeleteConfirmationDialog(
                                          context, ds.id);
                                    },
                                    child: const Icon(
                                      Icons.delete_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Name: " + ds['Name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Contact: " + ds['Contact'],
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Station Trained: " + ds['Station'],
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Position: " + ds['Position'],
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Date Employed: " + ds['DateEmployed'],
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Address: " + ds['Address'],
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : const Center(child: CircularProgressIndicator());
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
          'Employees',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: .3),
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
                      onChanged: handleSearch,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 71, 71, 71),
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
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
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
                    Navigator.pushNamed(context, '/addemploye');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Add Employee',
                    style: TextStyle(letterSpacing: 1, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                  height: 440,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Expanded(child: allEmployeeDetails())),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future EditEmployeeDetail(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
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
                      const SizedBox(height: 60),
                      const Text('Edit Details:')
                    ],
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nicknameController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Nickname",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                      controller: contactController,
                      decoration: const InputDecoration(
                        labelText: "Contact",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: stationController,
                    decoration: const InputDecoration(
                      labelText: "Station Trained",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: positionController,
                    decoration: const InputDecoration(
                      labelText: "Position",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: "Address",
                      border: OutlineInputBorder(),
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
                    padding: const EdgeInsets.all(3.0),
                    child: ElevatedButton(
                      onPressed: () async {
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

                        Map<String, dynamic> updateInfo = {
                          "Name": nameController.text,
                          "Nickname": nicknameController.text,
                          "Contact": contactController.text,
                          "Station": stationController.text,
                          "Position": positionController.text,
                          "DateEmployed": dateController.text,
                          "Address": addressController.text
                        };
                        await DatabaseMethods()
                            .updateEmployeeDetail(id, updateInfo);
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
                      child: const Text('Update',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ));
}
