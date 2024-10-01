import 'package:flutter/material.dart';

class EmployeeFill extends StatelessWidget {
  EmployeeFill({super.key});

  final _formKey = GlobalKey<FormState>();

  // Controllers to retrieve user inputs
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController stationController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Clear all fields
  void _clearFields() {
    idController.clear();
    nameController.clear();
    nicknameController.clear();
    contactController.clear();
    stationController.clear();
    positionController.clear();
    dateController.clear();
    addressController.clear();
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
          'Add Employees',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
          child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(10),
              color: Colors.blue,
              child: Text('SEE ALL EMPLOYEES')),
          Text(
            "FILL IN DETAILS",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(221, 255, 255, 255),
            ),
          ),
          Container(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),

                // ID Field
                TextFormField(
                  controller: idController,
                  decoration: InputDecoration(
                    labelText: 'ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),

                // Name Field
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),

                // Nickname Field
                TextFormField(
                  controller: nicknameController,
                  decoration: InputDecoration(
                    labelText: 'Nickname',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),

                // Contact Number Field
                TextFormField(
                  controller: contactController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Contact No',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),

                // Station Trained Field
                TextFormField(
                  controller: stationController,
                  decoration: InputDecoration(
                    labelText: 'Station Trained',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),

                // Position Field
                TextFormField(
                  controller: positionController,
                  decoration: InputDecoration(
                    labelText: 'Position',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),

                // Date Employed Field
                TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Date Employed',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                SizedBox(height: 10),

                // Address Field
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Clear and Add Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _clearFields,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 24.0),
                      ),
                      child: Text('CLEAR'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Handle form submission
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Details Added')));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[900],
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 24.0),
                      ),
                      child: Text('ADD'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
