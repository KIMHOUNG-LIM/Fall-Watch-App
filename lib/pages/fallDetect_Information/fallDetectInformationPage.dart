import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fall_watch_app/pages/fallDetect_Information/fetchInformation.dart';
import 'package:fall_watch_app/pages/fallVideo/fallVideoPage.dart';
import 'package:fall_watch_app/pages/patient_information/patientInformationPage.dart';
import 'package:fall_watch_app/services/auth_EmailAndPass.dart';
import 'package:fall_watch_app/services/firestore_fallDetection.dart';


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FallDetectInformationPage extends StatefulWidget {
  const FallDetectInformationPage({super.key});

  @override
  State<FallDetectInformationPage> createState() =>
      _FallDetectInformationPageState();
}

class _FallDetectInformationPageState extends State<FallDetectInformationPage> {
  final FallDetectionService _firestoreService = FallDetectionService();
  final AuthService _authService = AuthService();
  Future<List<Map<String, dynamic>>>? _fallDetections;
  String _username = '';
  String? cameraId;
  String? _patientName;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      cameraId = await _firestoreService.getCameraId();
      if (cameraId != null) {
        setState(() {
          _fallDetections = _firestoreService.getFallDetectionData(cameraId!);
        });
        _patientName = await getPatientNameByUserUid(user.uid); // Fetch patient name
      } else {
        setState(() {
          _fallDetections = Future.value([]); // No cameraId found, return empty list
        });
      }
      _getUsername(user.uid); // Fetch the username
    } else {
      setState(() {
        _fallDetections = Future.value([]); // Initialize as empty if user is null
      });
    }
  }

  Future<void> _getUsername(String userId) async {
    final username = await fetchUsername(userId);
    if (username != null) {
      setState(() {
        _username = username;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fall Detection Information',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Container(
              color: Colors.orangeAccent,
            ),
            ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Icon(
                        Icons.person,
                        size: 67,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        _username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.info, color: Colors.white),
                  title: const Text(
                    'Patient Information',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientInformationPage(
                          uid: FirebaseAuth.instance.currentUser!.uid,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    await _authService.signOut();
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _fallDetections,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No fall detections found.'));
              }

              final fallDetections = snapshot.data!;

              return ListView.builder(
                itemCount: fallDetections.length,
                itemBuilder: (context, index) {
                  final fallDetection = fallDetections[index];
                  final String imageURL = fallDetection['imageUrl'] ?? '';
                  final String cameraID = fallDetection['cameraId'] ?? 'Unknown';
                  final String location = fallDetection['location'] ?? 'Unknown';
                  final Timestamp dateTimestamp = fallDetection['timestamp'] ?? Timestamp.now();
                  final String date = formatDate(dateTimestamp);
                  final String videoURL = fallDetection['videoUrl'] ?? '';

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FallVideoPage(
                            videoURL: videoURL,
                            cameraID: cameraID,
                            location: location,
                            date: date,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Card(
                        elevation: 2,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              child: Image.network(
                                imageURL,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image, size: 100);
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Camera ID: $cameraID',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Room: $location',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Color.fromRGBO(230, 81, 0, 1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Date: $date',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
