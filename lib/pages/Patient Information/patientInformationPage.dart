import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fall_watch_app/pages/Patient%20Information/patient_profile.dart';
import 'package:flutter/material.dart';

class PatientInformationPage extends StatefulWidget {
  final String uid;

  const PatientInformationPage({super.key, required this.uid});

  @override
  State<PatientInformationPage> createState() => _PatientInformationPageState();
}

class _PatientInformationPageState extends State<PatientInformationPage> {
  List<String> _patientIds = [];
  Map<String, List<Map<String, String>>> families = {};

  @override
  void initState() {
    super.initState();
    _fetchPatientsIdList(widget.uid);
  }

  // Fetch family contacts and their details
  Future<void> _fetchFamilyContact(String patientDocumentId) async {
    try {
      var familyContacts = await FirebaseFirestore.instance
          .collection('Patient Family')
          .where('patientDocumentId', isEqualTo: patientDocumentId)
          .get();

      List<String> userUids = familyContacts.docs
          .map((doc) => doc['userUid'] as String)
          .toList();

      List<Map<String, String>> familyList = [];

      for (var userUid in userUids) {
        var userDoc = await FirebaseFirestore.instance
            .collection('User Informations')
            .doc(userUid)
            .get();

        if (userDoc.exists) {
          var userData = userDoc.data();
          familyList.add({
            'name': userData?['userName'] ?? 'Unknown',
            'phone': userData?['phoneNumber'] ?? '',
            'email': userData?['email'] ?? '',
          });
        }
      }

      setState(() {
        families[patientDocumentId] = familyList;
      });
    } catch (e) {
      print("Failed to fetch family contact: $e");
    }
  }

  Future<void> _fetchPatientsIdList(String userUid) async {
    try {
      var patients = await FirebaseFirestore.instance
          .collection('Patient Family')
          .where('userUid', isEqualTo: userUid)
          .get();

      for (var doc in patients.docs) {
        _patientIds.add(doc['patientDocumentId']);
      }

      // Fetch family contacts for each patient
      for (var patientId in _patientIds) {
        await _fetchFamilyContact(patientId);
      }

      setState(() {
        print("PatientID List: $_patientIds");
      });
    } catch (e) {
      print("Error Fetching Patients: $e");
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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: _patientIds.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Patient Informations')
                    .where(FieldPath.documentId, whereIn: _patientIds)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                            color: Colors.orange));
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No Patients Data Found'));
                  }

                  final patientDatas = snapshot.data!.docs;
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                      itemCount: patientDatas.length,
                      itemBuilder: (context, index) {
                        final patientDoc = patientDatas[index];
                        final patientData =
                            patientDoc.data() as Map<String, dynamic>;
                        final patientDocId = patientDoc.id;

                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.shade200
                                        .withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    offset: const Offset(5, 6),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PatientProfilePage(
                                        patientDocId: patientDocId,
                                        imageUrl: patientData[
                                            'imageUrl_patient'],
                                        name: patientData['patientName'],
                                        location: patientData['room'],
                                        cameraId: patientData['cameraId'],
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(width: 5),
                                        Column(
                                          children: [
                                            Container(
                                              width: 150,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1.0),
                                              ),
                                              child: patientData[
                                                          'imageUrl_patient'] !=
                                                      null
                                                  ? Image.network(
                                                      patientData[
                                                          'imageUrl_patient'],
                                                      fit: BoxFit.cover,
                                                    )
                                                  : const Icon(
                                                      Icons.person_2,
                                                      color: Colors.grey,
                                                      size: 150,
                                                    ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              patientData['patientName'] ??
                                                  'N/A',
                                              style: const TextStyle(
                                                fontSize: 25,
                                                color: Colors.orangeAccent,
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Camera: ${patientData?['cameraId'] ?? 'N/A'}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'Room: ${patientData['room'] ?? 'N/A'}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                const Divider(
                                                    thickness: 3,
                                                    color: Colors.grey),
                                                Text(
                                                  "Contact Patient's Family",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                // Display family phone numbers
                                                families[patientDocId] != null
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: families[
                                                                patientDocId]!
                                                            .map((family) =>
                                                                Text(
                                                                  '${family['phone']}',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ))
                                                            .toList(),
                                                      )
                                                    : const Text(
                                                        'No family contacts available',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 35),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
