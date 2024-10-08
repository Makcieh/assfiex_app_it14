// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

//CREATE
class DatabaseMethods {
  Future addTimeAvailDetails(
      Map<String, dynamic> timeAvailInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('TimeAvailability')
        .doc(id)
        .set(timeAvailInfoMap);
  }

//READ
  Future<Stream<QuerySnapshot>> getTimeAvailDetails() async {
    return FirebaseFirestore.instance
        .collection('TimeAvailability')
        .snapshots();
  }

//UPDATE
  Future updateTimeAvailDetail(
      String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection('TimeAvailability')
        .doc(id)
        .update(updateInfo);
  }

//DELETE
  Future deleteTimeAvailDetail(
    String id,
  ) async {
    return await FirebaseFirestore.instance
        .collection('TimeAvailability')
        .doc(id)
        .delete();
  }
}
