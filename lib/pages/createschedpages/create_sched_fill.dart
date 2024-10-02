import 'package:assfiex_app_it14/pages/createschedpages/databaseCreateSched.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

final TextEditingController idController = TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController positionController = TextEditingController();
final TextEditingController hoursController = TextEditingController();
final TextEditingController startController = TextEditingController();
final TextEditingController endController = TextEditingController();

void createschedFill(BuildContext context) {
  showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.blue[100],
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            right: 20,
            left: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  "Fill In Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: "ID",
                  hintText: "",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "NAME",
                  hintText: "",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: positionController,
                decoration: const InputDecoration(
                  labelText: "POSITION",
                  hintText: "",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: hoursController,
                decoration: const InputDecoration(
                  labelText: "HOURS",
                  hintText: "",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: startController,
                decoration: const InputDecoration(
                  labelText: "START",
                  hintText: "6am",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: endController,
                decoration: const InputDecoration(
                  labelText: "END",
                  hintText: "12pm",
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // ignore: non_constant_identifier_names
                  String ScheduleId = randomNumeric(5);
                  Map<String, dynamic> createSchedInfoMap = {
                    "ScheduleID": ScheduleId,
                    "Name": nameController.text,
                    "Position": positionController.text,
                    "Hours": hoursController.text,
                    "Start": startController.text,
                    "End": endController.text,
                  };
                  await DatabaseMethods()
                      .addCreateSched(createSchedInfoMap, ScheduleId)
                      .then((value) {
                    Fluttertoast.showToast(
                        msg: "Schedule Details Added",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                ),
                child: const Text('ADD'),
              ),
            ],
          ),
        );
      });
}
