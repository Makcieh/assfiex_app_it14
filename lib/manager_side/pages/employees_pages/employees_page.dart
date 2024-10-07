import 'package:assfiex_app_it14/manager_side/pages/employees_pages/databaseEmployee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  TextEditingController searchController = TextEditingController();
  String searchField = 'Name'; // Default search field
  String searchQuery = '';
  Stream? EmployeeStream;

  List<String> searchOptions = [
    'Name',
    'Nickname',
    'Station',
    'Position'
  ]; // Search by Name, Nickname, Station, or Position

  getontheload() async {
    EmployeeStream = await DatabaseMethods().getEmployeeDetails();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  // Function to handle search input change
  void handleSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  // Filter function based on the selected search option
  bool searchFilter(DocumentSnapshot ds) {
    return ds[searchField]
        .toString()
        .toLowerCase()
        .contains(searchQuery); // Filter logic
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

                    // Apply the search filter
                    if (!searchFilter(ds)) {
                      return const SizedBox
                          .shrink(); // Hide non-matching results
                    }

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
                                    // Edit employee details
                                    EditEmployeeDetail(ds['Id'], ds);
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
              : const Center(child: CircularProgressIndicator());
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
                      fillColor: const Color.fromARGB(255, 6, 33, 55),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: searchField,
                  dropdownColor: const Color.fromARGB(255, 6, 33, 55),
                  style: const TextStyle(color: Colors.white),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
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
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addemploye');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    const Color.fromARGB(255, 61, 102, 135), // Text color
                padding: const EdgeInsets.symmetric(
                    horizontal: 30, vertical: 12), // Button size and padding
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
              ),
            ),
            const SizedBox(height: 30),
            Expanded(child: allEmployeeDetails()),
          ],
        ),
      ),
    );
  }

  Future EditEmployeeDetail(String id, DocumentSnapshot ds) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Adjusts height based on content
                children: [
                  TextFormField(
                    controller: TextEditingController(text: ds['Name']),
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextFormField(
                    controller: TextEditingController(text: ds['Nickname']),
                    decoration: const InputDecoration(labelText: 'Nickname'),
                  ),
                  TextFormField(
                    controller: TextEditingController(text: ds['Contact']),
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Contact'),
                  ),
                  TextFormField(
                    controller: TextEditingController(text: ds['Station']),
                    decoration:
                        const InputDecoration(labelText: 'Station Trained'),
                  ),
                  TextFormField(
                    controller: TextEditingController(text: ds['Position']),
                    decoration: const InputDecoration(labelText: 'Position'),
                  ),
                  TextFormField(
                    controller: TextEditingController(text: ds['DateEmployed']),
                    decoration:
                        const InputDecoration(labelText: 'Date Employed'),
                  ),
                  TextFormField(
                    controller: TextEditingController(text: ds['Address']),
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      Map<String, dynamic> updateInfo = {
                        "Name": ds['Name'],
                        "Nickname": ds['Nickname'],
                        "Contact": ds['Contact'],
                        "Station": ds['Station'],
                        "Position": ds['Position'],
                        "DateEmployed": ds['DateEmployed'],
                        "Address": ds['Address'],
                      };
                      await DatabaseMethods()
                          .updateEmployeeDetail(id, updateInfo);
                      Navigator.pop(context);
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            ),
          ));
}
