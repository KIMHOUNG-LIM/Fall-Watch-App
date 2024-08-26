import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> getPatientNameByUserUid(String userUid) async {
  try {
    QuerySnapshot patientSnapshot = await FirebaseFirestore.instance
        .collection('Patient Informations')
        .where('userUid', isEqualTo: userUid)
        .get();

    if (patientSnapshot.docs.isNotEmpty) {
      var patientData = patientSnapshot.docs.first.data() as Map<String, dynamic>;
      return patientData['patientName'] ?? '';
    }
  } catch (e) {
    print('Error fetching patient name: $e');
  }
  return null;
}

String formatDate(Timestamp timestamp) {
  DateTime date = timestamp.toDate();
  return '${date.year}/${date.month}/${date.day}';
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



