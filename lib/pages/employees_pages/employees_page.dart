// ignore: file_names
import 'package:assfiex_app_it14/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
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
                        margin: EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Id : " + ds['Id'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Name: " + ds['Name'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Nickname : " + ds['Nickname'],
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
          margin: EdgeInsets.only(left: 20, right: 20, top: 30),
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
}
