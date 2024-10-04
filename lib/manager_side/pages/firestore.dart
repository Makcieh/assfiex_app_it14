import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //get collection of request
  final CollectionReference request =
      FirebaseFirestore.instance.collection('requestleave');

  //create: add a new data
}
