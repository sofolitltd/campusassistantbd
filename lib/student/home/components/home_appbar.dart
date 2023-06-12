// import 'package:flutter/material.dart';
//
// import '../notice/notice_screen.dart';
//
// AppBar homeAppbar(context) {
//   return AppBar(
//     elevation: 0,
//     titleSpacing: 8,
//     automaticallyImplyLeading: false,
//     title: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Builder(
//           builder: (context) => IconButton(
//               icon: const Icon(Icons.menu_outlined),
//               onPressed: () => Scaffold.of(context).openDrawer()),
//         ),
//         const Text.rich(
//           TextSpan(
//             text: 'CAMPUS ',
//             // style: TextStyle(color: Colors.black),
//             children: [
//               TextSpan(
//                 text: 'ASSISTANT',
//                 style: TextStyle(color: Colors.orange),
//               )
//             ],
//           ),
//           style: TextStyle(
//             fontSize: 20,
//             fontFamily: 'Lato',
//             fontWeight: FontWeight.w500,
//             letterSpacing: 1,
//           ),
//           maxLines: 1,
//         ),
//
//         //
//         IconButton(
//             icon: const Icon(Icons.notifications_none_outlined),
//             onPressed: () {
//               //
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) =>  NoticeScreen()));
//             }),
//       ],
//     ),
//   );
// }
