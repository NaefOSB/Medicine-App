import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  static getUserDetails(String userId) async {
    try {
      var userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userData != null) {
        return userData;
      }
    } catch (e) {}
  }
}
