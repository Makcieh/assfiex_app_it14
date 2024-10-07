// ignore: file_names
// import 'package:assfiex_app_it14/manager_side/pages/employees_pages/databaseEmployee.dart';
import 'package:assfiex_app_it14/manager_side/pages/TA_pages/databaseTA.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimeAvailPage extends StatefulWidget {
  const TimeAvailPage({super.key});

  @override
  State<TimeAvailPage> createState() => _TimeAvailPageState();
}

class _TimeAvailPageState extends State<TimeAvailPage> {
  TextEditingController nameController = TextEditingController();
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

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allEmployeeDetails() {
    return StreamBuilder(
        stream: TimeAvailStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];

                    //Ray Da Designer
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
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    nameController.text = ds["name"];
                                    monController.text = ds["mon"];
                                    tuesController.text = ds["tues"];
                                    wedsController.text = ds["weds"];
                                    thursController.text = ds["thurs"];
                                    friController.text = ds["fri"];
                                    satController.text = ds["sat"];
                                    sunController.text = ds["sun"];
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
                                        .deleteTimeAvailDetail(ds['name']);
                                  },
                                  child: const Icon(
                                    Icons.delete_rounded,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              "Name: " + ds['name'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Monday: " + ds['mon'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Tuesday: " + ds['tues'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Wednesday: " + ds['weds'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Thursday: " + ds['thurs'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Friday: " + ds['fri'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Saturday: " + ds['sat'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Sunday: " + ds['sun'],
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
            'Time Availability',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/addta');
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
                    'ADD Time Availability',
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
  Future EditTimeAvailDetail(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Container(
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
                    controller: monController,
                    decoration: const InputDecoration(
                      labelText: 'Monday',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Contact Number Field
                  TextFormField(
                    controller: tuesController,
                    decoration: const InputDecoration(
                      labelText: 'Tuesday',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Station Trained Field
                  TextFormField(
                    controller: wedsController,
                    decoration: const InputDecoration(
                      labelText: 'Wedsnesday',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Position Field
                  TextFormField(
                    controller: thursController,
                    decoration: const InputDecoration(
                      labelText: 'Thursday',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Date Employed Field
                  TextFormField(
                    controller: friController,
                    decoration: const InputDecoration(
                      labelText: 'Friday',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 10),

                  // Address Field
                  TextFormField(
                    controller: satController,
                    decoration: const InputDecoration(
                      labelText: 'Saturday',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: sunController,
                    decoration: const InputDecoration(
                      labelText: 'Sunday',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> updateInfo = {
                            "name": nameController.text,
                            "mon": monController.text,
                            "tues": tuesController.text,
                            "weds": wedsController.text,
                            "thurs": thursController.text,
                            "fri": friController.text,
                            "sat": satController.text,
                            "sun": sunController.text,
                          };
                          await DatabaseMethods()
                              .updateTimeAvailDetail(
                                  AutofillHints.nameSuffix, updateInfo)
                              .then((value) {
                            // ignore: use_build_context_synchronously
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
