// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fall_watch_app/pages/Fall%20Video%20Detail/fallVideoPage.dart';
// import 'package:fall_watch_app/pages/Patient%20Information/contactothers.dart';
// import 'package:flutter/material.dart';

// class PatientProfilePage extends StatefulWidget {
//   final String imageUrl;
//   final String name;
//   final String location;
//   final String cameraId;
//   final List<Map<String, dynamic>> fallDetections;

//   const PatientProfilePage({
//     Key? key,
//     required this.imageUrl,
//     required this.name,
//     required this.location,
//     required this.cameraId,
//     required this.fallDetections,
//   }) : super(key: key);

//   @override
//   State<PatientProfilePage> createState() => _PatientProfilePageState();
// }

// class _PatientProfilePageState extends State<PatientProfilePage> {
//   @override
//   Widget build(BuildContext context) {
//     // Filter fall detections based on location and camera ID
//     final filteredFallDetections = widget.fallDetections.where((fall) {
//       // Trim any whitespace
//       final location = (fall['room'] as String).trim();
//       final cameraId = (fall['cameraId'] as String).trim();
//       // return location == widget.location.trim() &&
//       //     cameraId == widget.cameraId.trim();
//       return location == widget.location.trim();
         
          
//     }).toList();

//     // Use filtered list instead of all fall detections
//     final fallCount = filteredFallDetections.length;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.orange,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text("Patient's Profile"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildProfileHeader(),
//             const SizedBox(height: 5),
//             _buildProfileButtons(fallCount),
//             const SizedBox(height: 20),
//             _buildFallHistorySection(filteredFallDetections, context),
//           ],
//         ),
//       ),
//     );
//   }

//   // Build the profile header
//   Widget _buildProfileHeader() {
//     return Padding(
//       padding: const EdgeInsets.all(25.0),
//       child: Expanded(
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 60,
//               backgroundImage: widget.imageUrl.isNotEmpty
//                   ? NetworkImage(widget.imageUrl)
//                   : null,
//               child: widget.imageUrl.isEmpty
//                   ? const Icon(Icons.person, size: 40)
//                   : null,
//             ),
//             const SizedBox(width: 40),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Name: ${widget.name}',
//                     style:
//                         const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     'CameraId: ${widget.cameraId}',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     'Room: ${widget.location}',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Build the profile buttons
//   Widget _buildProfileButtons(int fallCount) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             foregroundColor: Colors.white,
//             backgroundColor: Colors.orange,
//             padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
//           ),
//           onPressed: () {},
//           child: Column(
//             children: [
//               const Text('Fall Count'),
//               Text('$fallCount'), // Display fall count
//             ],
//           ),
//         ),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             foregroundColor: Colors.white,
//             backgroundColor: Colors.orange,
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//           ),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => RelativeContactPage(),
//               ),
//             );
//           },
//           child: Column(
//             children: [
//               const Text('Contact'),
//               Text('Other Relatives'),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // Build the fall history section
//   Widget _buildFallHistorySection(
//       List<Map<String, dynamic>> fallDetections, BuildContext context) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Align(
//             alignment: Alignment.center,
//             child: Text(
//               'Fall History',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.orange,
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           const Divider(),
//           Expanded(
//             child: fallDetections.isNotEmpty
//                 ? ListView.builder(
//                     itemCount: fallDetections.length,
//                     itemBuilder: (context, index) {
//                       final fall = fallDetections[index];
//                       return _buildFallHistoryItem(fall, context);
//                     },
//                   )
//                 : const Center(
//                     child: Text(
//                       'No fall history available',
//                       style: TextStyle(fontSize: 16, color: Colors.black45),
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Build individual fall history items
//   Widget _buildFallHistoryItem(
//       Map<String, dynamic> fall, BuildContext context) {
//     final String imageURL = fall['imageUrl'] ?? 'N/A';
//     final String cameraID = fall['cameraId'] ?? 'N/A';
//     final String fallLocation = fall['room'] ?? 'N/A';
//     final Timestamp dateTimestamp = fall['timestamp'] ?? Timestamp.now();
//     final String date = formatDate(dateTimestamp);
//     final String videoURL = fall['videoUrl'] ?? '';

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Flexible(
//             flex: 2,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.orange.shade200.withOpacity(0.8),
//                     blurRadius: 10,
//                     spreadRadius: 1,
//                     offset: const Offset(5, 6),
//                   ),
//                 ],
//               ),
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Camera ID: $cameraID',
//                     style: const TextStyle(
//                       fontSize: 15,
//                       color: Colors.black45,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     'Room: $fallLocation',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       color: Colors.orange,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     'Date: $date',
//                     style: const TextStyle(
//                       fontSize: 15,
//                       color: Colors.black45,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Flexible(
//             flex: 1,
//             child: AspectRatio(
//               aspectRatio: 1, // Keep a square aspect ratio for the button
//               child: TextButton(
//                 style: TextButton.styleFrom(
//                   backgroundColor: Colors.grey.shade400,
//                   padding: EdgeInsets.zero, // Remove default padding
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => FallVideoPage(
//                         videoURL: videoURL,
//                         cameraID: cameraID,
//                         location: fallLocation,
//                         date: date,
//                       ),
//                     ),
//                   );
//                 },
//                 child: imageURL.isNotEmpty
//                     ? Image.network(
//                         imageURL,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return const Icon(Icons.broken_image, size: 100);
//                         },
//                       )
//                     : const Icon(Icons.image_not_supported, size: 100),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Format the Timestamp to a readable date
//   String formatDate(Timestamp timestamp) {
//     final date = timestamp.toDate();
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }
