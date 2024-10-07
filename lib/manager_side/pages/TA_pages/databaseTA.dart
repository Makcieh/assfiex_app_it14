// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

//CREATE
class DatabaseMethods {
  Future addTimeAvailDetails(
      Map<String, dynamic> timeAvailInfoMap, String name) async {
    return await FirebaseFirestore.instance
        .collection('TimeAvailability')
        .doc(name)
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
      String name, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection('TimeAvailability')
        .doc(name)
        .update(updateInfo);
  }

//DELETE
  Future deleteTimeAvailDetail(
    String name,
  ) async {
    return await FirebaseFirestore.instance
        .collection('TimeAvailability')
        .doc(name)
        .delete();
  }
}
