import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryListServices {
  Stream<QuerySnapshot> getCategoryList() {
    return FirebaseFirestore.instance.collection('categories').snapshots();
  }
}
