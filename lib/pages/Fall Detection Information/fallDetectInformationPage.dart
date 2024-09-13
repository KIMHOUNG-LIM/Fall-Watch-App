import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fall_watch_app/pages/Fall%20Detection%20Information/familyOfUserPage.dart';
import 'package:fall_watch_app/pages/Fall%20Detection%20Information/fetchInformation.dart';
import 'package:fall_watch_app/pages/Fall%20Video%20Detail/fallVideoPage.dart';
import 'package:fall_watch_app/pages/Notification%20Utils/local_notification.dart';
import 'package:fall_watch_app/pages/Patient%20Information/patientInformationPage.dart';
import 'package:fall_watch_app/pages/Welcome/welcomePage.dart';
import 'package:fall_watch_app/services/auth_EmailAndPass.dart';
import 'package:fall_watch_app/services/firestore_fallDetection.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class FallDetectInformationPage extends StatefulWidget {
  const FallDetectInformationPage({super.key});

  @override
  State<FallDetectInformationPage> createState() =>
      _FallDetectInformationPageState();
}

class _FallDetectInformationPageState extends State<FallDetectInformationPage> {
  final FallDetectionService _firestoreService = FallDetectionService();
  final AuthService _authService = AuthService();

  String _username = '';
  List<String> _cameraId = [];
  final List<String> _existingIds = [];
  bool _isFirstLoad = true; // Flag to suppress notifications initially

  @override
  void initState() {
    super.initState();
    _fetchCameraIds();
    _fetchUserName();
    LocalNotifications.init();

    // Set a delay to suppress notifications for a short period after login
    Future.delayed(const Duration(seconds: 25), () {
      setState(() {
        _isFirstLoad = false; // Allow notifications after the delay
      });
    });
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      var userName = await FirebaseFirestore.instance.collection('User Informations')
          .doc(user?.uid)
          .get();
      setState(() {
        _username = userName.get('userName');
      });
    } catch (e) {
      print("Error Fetching Username : $e");
    }
  }

  Future<void> _fetchCameraIds() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      var cameraIds = await FirebaseFirestore.instance.collection('Camera Access')
          .where('userUid', isEqualTo: user?.uid).get();
      setState(() {
        for (var doc in cameraIds.docs) {
          _cameraId.add(doc['cameraId']);
        }
        print("CameraID $_cameraId");
      });
    } catch (e) {
      print("Error fetching camera IDs: $e");
    }
  }

  void _showNotification(String title, String body) {
    if (!_isFirstLoad) {  // Only show notifications after the first load
      LocalNotifications.showSimpleNotification(
        title: title,
        body: body,
        payload: 'New Fall Detection',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
              color: Colors.white,
              
            ),
            Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.shade200.withOpacity(0.8),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    offset: Offset(5, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'CAREVUE2.0',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Welcome $_username!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width:250,height:66,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.orange.shade200.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(5, 6),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.contact_emergency, color: Colors.grey),
                    title: const Text(
                      'Patient Information',
                      style: TextStyle(color: Colors.grey),
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
                ),
                const SizedBox(height: 15),
                Container(
                  width:250,height:66,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.orange.shade200.withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 1,
                        offset: Offset(5, 6),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.contact_phone, color: Colors.grey),
                    title: const Text(
                      'Family Contacts',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssociatedUsersPage(userUid:  FirebaseAuth.instance.currentUser!.uid)
                        ),
                      );
                      
                      
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width:250,height:66,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.orange.shade200.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(5, 6),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.emergency, color: Colors.grey),
                    title: const Text(
                      'Emergency Call',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () async{
                      launch('tel://119');
                      // await FlutterPhoneDirectCaller.callNumber("119");
                      
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width:250,height:66,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.orange.shade200.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(5, 6),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.grey),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () async {
                      try {
                        await _authService.signOut();
                        // After signing out, navigate back to the login screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => WelcomePage()), 
                        );
                      } catch (e) {
                        print("Error during logout: $e");
                      }
                    },
                  ),
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
          child: _cameraId.isEmpty
              ? const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          )
              : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Fall Detections')
                .where('cameraId', whereIn: _cameraId.toList())
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No fall detections found.'));
              }

              final fallDetections = snapshot.data!.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();
              final documents = snapshot.data!.docs;

              for (var doc in documents) {
                if (!_existingIds.contains(doc.id)) {
                  _existingIds.add(doc.id); // Add document ID to existing list
                  _showNotification(
                    "New Fall Detection",
                    "A new fall detection was recorded in room ${doc['room']}",
                  );
                }
              }
              return ListView.builder(
                itemCount: fallDetections.length,
                itemBuilder: (context, index) {
                  final fallDetection = fallDetections[index];
                  final String imageURL = fallDetection['imageUrl'] ?? '';
                  final String cameraID =
                  fallDetection['cameraId'] ?? 'Unknown';
                  final String room = fallDetection['room'] ?? 'Unknown';
                  final Timestamp dateTimestamp =
                      fallDetection['timestamp'] ?? Timestamp.now();
                  final String date = formatDate(dateTimestamp);
                  final String videoURL = fallDetection['videoUrl'] ?? '';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 230,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.shade200.withOpacity(0.8),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: Offset(5, 6),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 20.0),
                          child: Column(
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
                                'Room: $room',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.orange,
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
                        ),
                        SizedBox(width: 8), // Small space between the container and button
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FallVideoPage(
                                  videoURL: videoURL,
                                  cameraID: cameraID,
                                  location: room,
                                  date: date,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SizedBox(
                              width: 110,
                              height: 110,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageURL,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.broken_image, size: 50);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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