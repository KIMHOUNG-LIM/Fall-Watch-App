import 'package:cloud_firestore/cloud_firestore.dart';


String formatDate(Timestamp timestamp) {
  DateTime date = timestamp.toDate();
  return '${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute}:${date.second}';
}

Future<String?> fetchUsername(String userId) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('User Informations')
        .doc(userId)
        .get();
    if (snapshot.exists) {
      final data = snapshot.data();
      return data?['username'];
    }
  } catch (e) {
    print('Error fetching username: $e');
  }
  return null;
}



