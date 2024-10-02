// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addRequest(Map<String, dynamic> requestInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('RequestLeave')
        .doc(id)
        .set(requestInfoMap);
  }

  Future<Stream<QuerySnapshot>> getRequestDetails() async {
    return await FirebaseFirestore.instance
        .collection('RequestLeave')
        .snapshots();
  }
}
