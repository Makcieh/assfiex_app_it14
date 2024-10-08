import 'package:assfiex_app_it14/manager_side/pages/createschedpages/create_sched_fill.dart';
import 'package:assfiex_app_it14/manager_side/pages/createschedpages/databaseCreateSched.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateSchedPage extends StatefulWidget {
  const CreateSchedPage({super.key});

  @override
  State<CreateSchedPage> createState() => _CreateSchedPageState();
}

class _CreateSchedPageState extends State<CreateSchedPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  Stream? scheduStream;

  getontheload() async {
    scheduStream = await DatabaseMethods().getCreateSchedDetails();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allCreateSchedDetails() {
    return StreamBuilder(
        stream: scheduStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data.docs[index];

                    // Ray Da Designer
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
                                  "Nickname: " + data['Nickname'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    idController.text = data["EmployeeID"];
                                    nameController.text = data["Nickname"];
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
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await DatabaseMethods()
                                        .deleteSchedDetail(data['ScheduleID']);
                                  },
                                  child: const Icon(
                                    Icons.delete_rounded,
                                    color: Colors.white,
                                  ),
                                )
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
            'Schedules',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => createschedFill(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // Text color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12), // Button size and padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    elevation: 2, // Elevation to match the "raised" effect
                  ),
                  child: const Text(
                    "CREATE SCHEDULE",
                    style: TextStyle(
                      fontSize: 14, // Font size
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(child: allCreateSchedDetails())
            ],
          ),
        ));
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
                    style: TextStyle(color: Colors.grey),
                    controller: nameController,
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
                            "EmployeeID": idController.text,
                            "Name": nameController.text,
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
