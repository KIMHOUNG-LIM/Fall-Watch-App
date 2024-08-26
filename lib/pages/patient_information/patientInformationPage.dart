import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PatientInformationPage extends StatelessWidget {
  final String uid;

  const PatientInformationPage({super.key, required this.uid});

  Future<List<Map<String, dynamic>>> _getPatientsInformation(String userUid) async {
    try {
      // Query the Patient Informations collection for documents where userUid matches the provided userUid
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('Patient Informations')
          .where('userUid', isEqualTo: userUid)
          .get();

      // If no patients are found, return an empty list
      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      // Map the documents to a list of maps containing the patient data
      List<Map<String, dynamic>> patients = querySnapshot.docs.map((doc) => doc.data()).toList();

      return patients;
    } catch (e) {
      print('Error fetching patients by user UID: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> _getUserInformation(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('User Informations')
          .doc(uid)
          .get();

      if (snapshot.exists) {
        return snapshot.data();
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user information: $e");
      return null;
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Patient Information',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getUserInformation(uid),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (userSnapshot.hasError) {
            return Center(child: Text('Error: ${userSnapshot.error}'));
          } else if (!userSnapshot.hasData) {
            return const Center(child: Text('No user information found.', style: TextStyle(fontWeight: FontWeight.bold)));
          }

          final userData = userSnapshot.data;

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _getPatientsInformation(uid),
            builder: (context, patientSnapshot) {
              if (patientSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (patientSnapshot.hasError) {
                return Center(child: Text('Error: ${patientSnapshot.error}'));
              } else if (!patientSnapshot.hasData || patientSnapshot.data!.isEmpty) {
                return const Center(child: Text('No patient information found.', style: TextStyle(fontWeight: FontWeight.bold)));
              }

              final patientDataList = patientSnapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                  itemCount: patientDataList.length,
                  itemBuilder: (context, index) {
                    final patientData = patientDataList[index];
                    return Card(
                      color: Colors.orange,
                      elevation: 3,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 5),
                          Column(
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 1.0),
                                ),
                                child: patientData['imageUrl_patient'] != null
                                    ? Image.network(
                                        patientData['imageUrl_patient'],
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.person_2, color: Colors.white, size: 150),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                patientData['patientName'] ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Camera: ${userData?['cameraId'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Room: ${patientData['location'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(thickness: 3, color: Colors.white),
                                  Text(
                                    "Contact Patient's ${userData?['relationship'] ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Add any other relevant patient data here
                                  const SizedBox(height: 10),
                                  Text(
                                    "Telephone: ${userData?['phoneNumber'] ?? 'N/A'}", // Updated to use phoneNumber from user data
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
