import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FallDetectionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference fallDetectionCollection =
      FirebaseFirestore.instance.collection('Fall Detections');
  final CollectionReference cameraAccessCollection = 
          FirebaseFirestore.instance.collection('Camera Access');

  Future<List<String>> getCameraIdsByUserUid(String userUid) async {
    List<String> cameraIds = [];

    try {
      // Query to find all documents with the specified userUid
      QuerySnapshot querySnapshot = await cameraAccessCollection
          .where('userUid', isEqualTo: userUid)
          .get();
      
      // Loop through the query results and add camera IDs to the list
      for (var doc in querySnapshot.docs) {
        cameraIds.add(doc['cameraId']);
      }
    } catch (e) {
      print('Error fetching camera IDs: $e');
    }

    return cameraIds;
  }
  // Fetch fall detections by camera ID
  Future<List<Map<String, dynamic>>> getFallDetectionData(String cameraId) async {
    try {
      QuerySnapshot fallDetectionSnapshot = await fallDetectionCollection
          .where('cameraId', isEqualTo: cameraId)
          .get();

      return fallDetectionSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching fall detection data: $e');
      return [];
    }
  }

  Future<String?> getCameraId() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      DocumentSnapshot userDoc = await _firestore
          .collection('User Informations')
          .doc(user.uid)
          .get();

      return userDoc['cameraId'] as String?;
    } catch (e) {
      print('Error fetching camera ID: $e');
      return null;
    }
  }
  Future<String?> getPatientName() async {
  try {
    final user = FirebaseAuth.instance.currentUser; // Get the current logged-in user
    if (user != null) {
      QuerySnapshot patientSnapshot = await FirebaseFirestore.instance
          .collection('Patient Informations')
          .where('userUid', isEqualTo: user.uid) // Filter by userUid
          .get();

      if (patientSnapshot.docs.isNotEmpty) {
        // Assuming the document contains patientName field
        var patientData = patientSnapshot.docs.first.data() as Map<String, dynamic>;
        return patientData['patientName'] ?? 'No Name'; // Return patientName if available
      } else {
        return 'No Patient Found';
      }
    } else {
      return 'No User Logged In';
    }
  } catch (e) {
    print('Error fetching patient name: $e');
    return null;
  }
}
  
}
