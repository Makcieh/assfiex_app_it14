import 'package:flutter/material.dart';

final TextEditingController nameController = TextEditingController();
final TextEditingController snController = TextEditingController();
final TextEditingController addressController = TextEditingController();

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
                  "FILL THE DETAILS",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextField(
                controller: nameController,
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
                keyboardType: TextInputType.number,
                controller: snController,
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
                controller: snController,
                decoration: const InputDecoration(
                  labelText: "HOURS",
                  hintText: "",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: "START",
                  hintText: "",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: "END",
                  hintText: "",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    final id = DateTime.now().microsecond.toString();
                    // ignore: prefer_typing_uninitialized_variables
                    var databaseReference;
                    databaseReference.child(id).set({
                      'name': nameController.text.toString(),
                      'sn': snController.text.toString(),
                      'address': addressController.text.toString(),
                      'id': id //It's give the unique id every time.
                    });
                    // For clear the controller
                    nameController.clear();
                    snController.clear();
                    addressController.clear();
                    //For Dismiss the keyboard afte adding items
                    Navigator.pop(context);
                  },
                  child: const Text("ADD SCHEDULE"))
            ],
          ),
        );
      });
}
