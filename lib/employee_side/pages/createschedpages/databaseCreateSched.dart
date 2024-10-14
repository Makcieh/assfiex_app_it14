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

  Future<bool> checkEmployeeIdInDatabase(String employeeId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Employees')
          .doc(employeeId)
          .get();

      return doc.exists;
    } catch (e) {
      print('Error checking employee ID: $e');
      return false;
    }
  }
}
