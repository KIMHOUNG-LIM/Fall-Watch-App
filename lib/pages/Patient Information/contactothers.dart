import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RelativeContactPage extends StatefulWidget {
  final String patientDocumentId;
  const RelativeContactPage({
    Key? key,
    required this.patientDocumentId,
  }) : super(key: key);

  @override
  State<RelativeContactPage> createState() => _RelativeContactPageState();
}

class _RelativeContactPageState extends State<RelativeContactPage> {
List<Map<String, String>> families = [];

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

      for (var userUid in userUids) {
        var userDoc = await FirebaseFirestore.instance
            .collection('User Informations')
            .doc(userUid)
            .get();

        if (userDoc.exists) {
          var userData = userDoc.data();
          families.add({
            'name': userData?['userName'] ?? 'Unknown', 
            'phone': userData?['phoneNumber'] ?? '',
            'email': userData?['email'] ?? '',
          });
        }
      }
      print("Family Contacts: $families");
    } catch (e) {
      print("Failed to fetch family contact: $e");
    }
  }

  Future<List<Map<String, String>>> _getFamilyContacts() async {
    await _fetchFamilyContact(widget.patientDocumentId);
    return families;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family Contacts', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _getFamilyContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No family contacts found.'));
          } else {
            final relatives = snapshot.data!;
            return ListView.builder(
              itemCount: relatives.length,
              itemBuilder: (context, index) {
                final relative = relatives[index];
                return Card(
                  margin: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(relative['name'] ?? '', style: TextStyle(fontSize:15, fontWeight: FontWeight.bold)),
                    subtitle: Text('Phone: ${relative['phone'] ?? ''}\nEmail: ${relative['email']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.call, color: Colors.green),
                      onPressed: () {
                        _makePhoneCall(relative['phone']);
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

  void _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
       launch('tel://$phoneNumber');
      
    }
  }
}
