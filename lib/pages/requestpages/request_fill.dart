import 'package:assfiex_app_it14/pages/requestpages/databaseRequest.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

final TextEditingController idController = TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController dateController = TextEditingController();

void createBottomSheet(BuildContext context) {
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
                  labelText: "Employee ID",
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
                keyboardType: TextInputType.datetime,
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: "DATE",
                  hintText: "",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  // ignore: non_constant_identifier_names
                  String RequestID = randomNumeric(5);
                  Map<String, dynamic> requestInfoMap = {
                    "RequestID": RequestID,
                    "EmployeeID": idController.text,
                    "Name": nameController.text,
                    "Date": dateController.text,
                  };
                  await DatabaseMethods()
                      .addRequest(requestInfoMap, RequestID)
                      .then((value) {
                    Fluttertoast.showToast(
                        msg: "Request Details Added",
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
