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
    return await FirebaseFirestore.instance
        .collection('CreateSched')
        .snapshots();
  }
}
