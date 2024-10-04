// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addCreateSched(
      Map<String, dynamic> createSchedInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('CreateSched')
        .doc(id)
        .set(createSchedInfoMap);
  }

  Future<Stream<QuerySnapshot>> getCreateSchedDetails() async {
    return FirebaseFirestore.instance.collection('CreateSched').snapshots();
  }

  Future updateSchedDetail(
      String id, Map<String, dynamic> updateSchedInfo) async {
    return await FirebaseFirestore.instance
        .collection('CreateSched')
        .doc(id)
        .update(updateSchedInfo);
  }

//DELETE
  Future deleteSchedDetail(
    String id,
  ) async {
    return await FirebaseFirestore.instance
        .collection('CreateSched')
        .doc(id)
        .delete();
  }

  // Function to check if the employee ID exists in Firestore
  Future<bool> checkEmployeeIdInDatabase(String employeeId) async {
    try {
      // Query the employee document using the employeeId as the document ID
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Employees') // Replace with your collection name
          .doc(employeeId)
          .get();

      // Return true if the document exists, otherwise false
      return doc.exists;
    } catch (e) {
      print('Error checking employee ID: $e');
      return false;
    }
  }
}
