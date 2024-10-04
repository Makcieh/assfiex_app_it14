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
    return FirebaseFirestore.instance.collection('RequestLeave').snapshots();
  }

  //UPDATE
  Future updateRequestDetail(
      String id, Map<String, dynamic> updateRequestInfo) async {
    return await FirebaseFirestore.instance
        .collection('RequestLeave')
        .doc(id)
        .update(updateRequestInfo);
  }

//DELETE
  Future deleteRequestDetail(
    String id,
  ) async {
    return await FirebaseFirestore.instance
        .collection('RequestLeave')
        .doc(id)
        .delete();
  }
}
