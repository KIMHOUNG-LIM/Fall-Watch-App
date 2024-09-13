import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class AssociatedUsersPage extends StatefulWidget {
  final String userUid;

  AssociatedUsersPage({required this.userUid});

  @override
  _AssociatedUsersPageState createState() => _AssociatedUsersPageState();
}

class _AssociatedUsersPageState extends State<AssociatedUsersPage> {
  Set<String> userUidSet = {}; // To keep track of unique userUids
  List<Map<String, String>> associatedUsers = [];

  Future<void> _fetchAssociatedUsers(String userUid) async {
    try {
      // Step 1: Get all patientDocumentId associated with the userUid
      var patientDocuments = await FirebaseFirestore.instance
          .collection('Patient Family')
          .where('userUid', isEqualTo: userUid)
          .get();

      List<String> patientDocumentIds = patientDocuments.docs
          .map((doc) => doc['patientDocumentId'] as String)
          .toList();

      // Step 2: Get all userUid associated with the patientDocumentIds
      for (var patientDocumentId in patientDocumentIds) {
        var familyContacts = await FirebaseFirestore.instance
            .collection('Patient Family')
            .where('patientDocumentId', isEqualTo: patientDocumentId)
            .get();

        for (var doc in familyContacts.docs) {
          userUidSet.add(doc['userUid'] as String);
        }
      }

      // Step 3: Fetch user information for each unique userUid
      for (var uid in userUidSet) {
        var userDoc = await FirebaseFirestore.instance
            .collection('User Informations')
            .doc(uid)
            .get();

        if (userDoc.exists) {
          var userData = userDoc.data();
          associatedUsers.add({
            'name': userData?['userName'] ?? 'Unknown',
            'phone': userData?['phoneNumber'] ?? '',
            'email': userData?['email'] ?? '',
          });
        }
      }
      print("Associated Users: $associatedUsers");
    } catch (e) {
      print("Failed to fetch associated users: $e");
    }
  }

  Future<List<Map<String, String>>> _getAssociatedUsers() async {
    await _fetchAssociatedUsers(widget.userUid);
    return associatedUsers;
  }

  void _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
       launch('tel://$phoneNumber');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family Contacts', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _getAssociatedUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No associated users found.'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(user['name'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    subtitle: Text('Phone: ${user['phone'] ?? ''}\nEmail: ${user['email']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.call, color: Colors.green),
                      onPressed: () {
                        _makePhoneCall(user['phone']);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
