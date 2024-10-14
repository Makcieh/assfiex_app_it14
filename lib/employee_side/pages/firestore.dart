import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference request =
      FirebaseFirestore.instance.collection('requestleave');
}
