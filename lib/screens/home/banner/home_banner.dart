// import 'dart:developer';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import '../../../models/profile_data.dart';
//
// class HomeBanner extends StatelessWidget {
//   const HomeBanner({
//     Key? key,
//     required this.profileData,
//   }) : super(key: key);
//
//   final ProfileData profileData;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       height: MediaQuery.of(context).size.width < 800 ? 160 : 320,
//       padding: EdgeInsets.symmetric(
//         horizontal: MediaQuery.of(context).size.width > 800
//             ? MediaQuery.of(context).size.width * .2
//             : 0,
//       ),
//       child: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('Universities')
//             .doc(profileData.university)
//             .collection('Departments')
//             .doc(profileData.department)
//             .collection('banners')
//             .where('batches', arrayContainsAny: [profileData.information.batch])
//             .orderBy('time')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const Center(child: Text('Something went wrong'));
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Container(
//               height: 160,
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.blue.shade50,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             );
//           }
//           var data = snapshot.data!.docs;
//
//           //
//           String image =
//               'https://firebasestorage.googleapis.com/v0/b/campusassistantbd.appspot.com/o/Universities%2FUniversity%20of%20Chittagong%2FDepartment%20of%20Psychology%2FBanners%2F2.jpg?alt=media&token=1b024eef-7e38-4829-a6dc-ef19d002ca48';
//
//           if (data.isEmpty) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: Colors.blue.shade100.withOpacity(.2),
//                 borderRadius: BorderRadius.circular(8),
//                 image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: NetworkImage(image),
//                 ),
//               ),
//             );
//           }
//
//           return Carousel(
//             onImageTap: (index) {
//               String image = data[index].get('image');
//               String message = data[index].get('message');
//               log(message);
//             },
//             autoplay: true,
//             autoplayDuration: const Duration(seconds: 15),
//             animationDuration: const Duration(milliseconds: 1000),
//             dotPosition: DotPosition.bottomLeft,
//             dotColor: const Color(0xff6dc7b2),
//             dotIncreasedColor: const Color(0xFFf69520),
//             dotBgColor: Colors.transparent,
//             indicatorBgPadding: 10,
//             images: data
//                 .map(
//                   (banner) => CachedNetworkImage(
//                     imageUrl: banner.get('image'),
//                     imageBuilder: (context, imageProvider) => Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         image: DecorationImage(
//                           fit: BoxFit.cover,
//                           image: imageProvider,
//                         ),
//                       ),
//                     ),
//                     placeholder: (context, url) => Container(
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade50,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                     errorWidget: (context, url, error) =>
//                         const Icon(Icons.error),
//                   ),
//                 )
//                 .toList(),
//           );
//         },
//       ),
//     );
//   }
// }
