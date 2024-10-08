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

  bool isValidTimeFormat(String input) {
    // Regex for time format (e.g., "6am to 10pm" or "NA")
    final RegExp timeRegExp = RegExp(
        r'^(?:[1-9]|1[0-2])(am|pm)\s+to\s+(?:[1-9]|1[0-2])(am|pm)$|^NA$');
    return timeRegExp.hasMatch(input);
  }

  Widget allTADetails() {
    return StreamBuilder(
      stream: TimeAvailStream,
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
                                child: const Icon(
                                  Icons.delete_rounded,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          Text("Nickname: " + ds['nickname'],
                              style: const TextStyle(color: Colors.white)),
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
                  );
                },
              )
            : Container();
      },
    );
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
        title: const Text('Time Availability',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                backgroundColor: const Color.fromARGB(255, 61, 102, 135),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: const Text('ADD Time Availability',
                  style: TextStyle(letterSpacing: 3)),
            ),
            const SizedBox(height: 30),
            Expanded(child: allTADetails())
          ],
        ),
      ),
    );
  }

  Future EditTimeAvailDetail(String id) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SingleChildScrollView(
            child: Container(
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

                  // Name Field
                  TextFormField(
                    controller: nicknameController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Nickname',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Monday Field
                  TextFormField(
                    controller: monController,
                    decoration: const InputDecoration(
                      labelText: 'Monday',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Tuesday Field
                  TextFormField(
                    controller: tuesController,
                    decoration: const InputDecoration(
                      labelText: 'Tuesday',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Wednesday Field
                  TextFormField(
                    controller: wedsController,
                    decoration: const InputDecoration(
                      labelText: 'Wednesday',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Thursday Field
                  TextFormField(
                    controller: thursController,
                    decoration: const InputDecoration(
                      labelText: 'Thursday',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Friday Field
                  TextFormField(
                    controller: friController,
                    decoration: const InputDecoration(
                      labelText: 'Friday',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Saturday Field
                  TextFormField(
                    controller: satController,
                    decoration: const InputDecoration(
                      labelText: 'Saturday',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Sunday Field
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
                      child: const Text('Update'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
