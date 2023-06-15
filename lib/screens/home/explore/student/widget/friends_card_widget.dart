// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '/models/profile_data.dart';
// import '/models/student_model.dart';
// import '/widgets/open_app.dart';
// import 'full_image.dart';
//
// class FriendsCardWidget extends StatelessWidget {
//   const FriendsCardWidget({
//     Key? key,
//     required this.profileData,
//     required this.studentModel,
//     required this.selectedBatch,
//   }) : super(key: key);
//
//   final ProfileData profileData;
//   final String selectedBatch;
//   final StudentModel studentModel;
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       margin: EdgeInsets.zero,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             //image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => FullImage(
//                           title: studentModel.name,
//                           imageUrl: studentModel.imageUrl),
//                     ),
//                   );
//                 },
//                 child: CachedNetworkImage(
//                   height: 88,
//                   width: 88,
//                   fit: BoxFit.cover,
//                   imageUrl: studentModel.imageUrl,
//                   fadeInDuration: const Duration(milliseconds: 500),
//                   progressIndicatorBuilder: (context, url, downloadProgress) =>
//                       const CupertinoActivityIndicator(),
//                   errorWidget: (context, url, error) => ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.asset(
//                       'assets/images/pp_placeholder.png',
//                       // fit: BoxFit.cover,
//                       width: 88,
//                       height: 88,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(width: 12),
//
//             //info, call
//             Expanded(
//               flex: 6,
//               child: SizedBox(
//                 height: 88,
//                 child: Stack(
//                   alignment: Alignment.centerRight,
//                   children: [
//                     //
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       // mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         //name
//                         Text(
//                           studentModel.name,
//                           overflow: TextOverflow.ellipsis,
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleMedium!
//                               .copyWith(fontWeight: FontWeight.w600),
//                         ),
//                         const SizedBox(height: 4),
//
//                         //id, blood
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             //id
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Student ID',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodySmall!
//                                       .copyWith(),
//                                 ),
//                                 Text(
//                                   studentModel.id,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .titleSmall!
//                                       .copyWith(fontWeight: FontWeight.w600),
//                                 ),
//                               ],
//                             ),
//
//                             if (studentModel.blood.isNotEmpty)
//                               const SizedBox(
//                                 height: 32,
//                                 child: VerticalDivider(
//                                   color: Colors.grey,
//                                   width: 24,
//                                 ),
//                               ),
//
//                             if (studentModel.blood.isNotEmpty)
//                               // blood
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   //id
//                                   Text(
//                                     'Blood ',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodySmall!
//                                         .copyWith(),
//                                   ),
//                                   Text(
//                                     studentModel.blood,
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleSmall!
//                                         .copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.red,
//                                         ),
//                                   ),
//                                 ],
//                               ),
//                           ],
//                         ),
//
//                         const SizedBox(height: 2),
//
//                         //hall
//                         if ((studentModel.hall != 'None'))
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Hall',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodySmall!
//                                     .copyWith(),
//                               ),
//                               Text(
//                                 studentModel.hall,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleSmall!
//                                     .copyWith(fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                       ],
//                     ),
//
//                     //call
//                     if (studentModel.phone.isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 16),
//                         child: IconButton(
//                           onPressed: () async {
//                             await OpenApp.withNumber(studentModel.phone);
//                           },
//                           icon: const Icon(
//                             Icons.call,
//                             color: Colors.green,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
