// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import '/models/profile_data.dart';

// class BatchAllUser extends StatelessWidget {
//   final ProfileData profileData;
//
//   const BatchAllUser({Key? key, required this.profileData}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('All Users'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: MediaQuery.of(context).size.width > 800
//               ? MediaQuery.of(context).size.width * .2
//               : 16,
//           vertical: 16,
//         ),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('users')
//               .where('university', isEqualTo: profileData.university)
//               .where('department', isEqualTo: profileData.department)
//               .orderBy('name')
//               .snapshots(),
//           builder:
//               (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (snapshot.hasError) {
//               return const Text('Something went wrong');
//             }
//
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             var data = snapshot.data!.docs;
//             return ListView.separated(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: data.length,
//               itemBuilder: (BuildContext context, int index) {
//                 ProfileData profile = ProfileData.fromJson(data[index]);
//                 //
//                 return Card(
//                   margin: EdgeInsets.zero,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   elevation: 3,
//                   child: Container(
//                     height: 85,
//                     padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // image & batch
//                         Column(
//                           children: [
//                             //image
//                             CachedNetworkImage(
//                               imageUrl: profile.image,
//                               fadeInDuration: const Duration(milliseconds: 500),
//                               imageBuilder: (context, imageProvider) =>
//                                   CircleAvatar(
//                                 backgroundImage: imageProvider,
//                                 radius: 24,
//                               ),
//                               progressIndicatorBuilder:
//                                   (context, url, downloadProgress) =>
//                                       const CircleAvatar(
//                                 radius: 24,
//                                 backgroundImage: AssetImage(
//                                     'assets/images/pp_placeholder.png'),
//                                 child: CupertinoActivityIndicator(),
//                               ),
//                               errorWidget: (context, url, error) =>
//                                   const CircleAvatar(
//                                       radius: 24,
//                                       backgroundImage: AssetImage(
//                                           'assets/images/pp_placeholder.png')),
//                             ),
//
//                             //badge
//                             if (profile.information.status!.subscriber! ==
//                                 'pro')
//                               const Row(
//                                 children: [
//                                   //
//                                   Icon(
//                                     Icons.check_circle,
//                                     size: 16,
//                                     color: Colors.blue,
//                                   ),
//                                   //
//                                   Text(
//                                     'PRO',
//                                     style: TextStyle(
//                                       color: Colors.blue,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                           ],
//                         ),
//
//                         const SizedBox(width: 12),
//
//                         //name , status
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 profile.name,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleMedium!
//                                     .copyWith(fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 2),
//
//                               //
//                               Row(
//                                 children: [
//                                   Text(profile.information.batch!),
//                                   const Text(' | '),
//                                   Text(profile.information.id!),
//                                   const Text(' | '),
//                                   Text(profile.information.session!),
//                                 ],
//                               ),
//
//                               //
//                               const SizedBox(height: 2),
//                               Row(
//                                 children: [
//                                   // is admin
//                                   if (profile.information.status!.admin!) ...[
//                                     Container(
//                                         margin: const EdgeInsets.symmetric(
//                                             vertical: 4),
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 8,
//                                           vertical: 2,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           // border: Border.all(color: Colors.grey.shade400),
//                                           borderRadius:
//                                               BorderRadius.circular(4),
//                                           color: Colors.greenAccent.shade100,
//                                         ),
//                                         child: const Text('Admin')),
//                                     const SizedBox(width: 8),
//                                   ],
//
//                                   // is moderator
//                                   if (profile
//                                       .information.status!.moderator!) ...[
//                                     Container(
//                                         margin: const EdgeInsets.symmetric(
//                                             vertical: 4),
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 8,
//                                           vertical: 2,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           // border: Border.all(color: Colors.grey.shade400),
//                                           borderRadius:
//                                               BorderRadius.circular(4),
//                                           color: Colors.blue.shade100,
//                                         ),
//                                         child: const Text('Moderator')),
//                                     const SizedBox(width: 8),
//                                   ],
//
//                                   // is cr
//                                   if (profile.information.status!.cr!) ...[
//                                     Container(
//                                         margin: const EdgeInsets.symmetric(
//                                             vertical: 4),
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 8,
//                                           vertical: 2,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           // border: Border.all(color: Colors.grey.shade400),
//                                           borderRadius:
//                                               BorderRadius.circular(4),
//                                           color: Colors.orange.shade100,
//                                         ),
//                                         child: const Text('CR')),
//                                     const SizedBox(width: 8),
//                                   ],
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         //
//                         PopupMenuButton(
//                           itemBuilder: (context) => [
//                             //admin
//                             PopupMenuItem(
//                               value: 1,
//                               onTap: () async {
//                                 //
//                                 if (profile.information.status!.admin!) {
//                                   //remove as admin
//                                   data[index].reference.update({
//                                     'role': {
//                                       'admin': false,
//                                       'cr': data[index].get('role')['cr'],
//                                     },
//                                   });
//                                 } else {
//                                   //add as admin
//                                   data[index].reference.update({
//                                     'role': {
//                                       'admin': true,
//                                       'cr': data[index].get('role')['cr'],
//                                     },
//                                   });
//                                 }
//                               },
//                               child: data[index].get('role')['admin'] == true
//                                   ? const Text('Remove as admin')
//                                   : const Text('Add as admin'),
//                             ),
//
//                             //cr
//                             PopupMenuItem(
//                               value: 2,
//                               onTap: () {
//                                 //
//                                 //
//                                 if (data[index].get('role')['cr'] == true) {
//                                   //remove as admin
//                                   data[index].reference.update({
//                                     'role': {
//                                       'admin': data[index].get('role')['admin'],
//                                       'cr': false,
//                                     },
//                                   });
//                                 } else {
//                                   //add as admin
//                                   data[index].reference.update({
//                                     'role': {
//                                       'admin': data[index].get('role')['admin'],
//                                       'cr': true,
//                                     },
//                                   });
//                                 }
//                               },
//                               child: data[index].get('role')['cr'] == true
//                                   ? const Text('Remove as moderator')
//                                   : const Text('Add as moderator'),
//                             ),
//
//                             //cr
//                             PopupMenuItem(
//                               value: 3,
//                               onTap: () {
//                                 //
//                                 //
//                                 if (data[index].get('status') == 'Pro') {
//                                   //remove as admin
//                                   data[index].reference.update({
//                                     'status': 'Basic',
//                                   });
//                                 } else {
//                                   //add as admin
//                                   data[index].reference.update({
//                                     'status': 'Pro',
//                                   });
//                                 }
//                               },
//                               child: data[index].get('status') == 'Pro'
//                                   ? const Text('Remove as Pro user')
//                                   : const Text('Add as Pro user'),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//               separatorBuilder: (BuildContext context, int index) =>
//                   const SizedBox(height: 15),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BatchAllUser extends StatefulWidget {
  const BatchAllUser({
    Key? key,
    required this.university,
    required this.department,
  }) : super(key: key);
  final String university;
  final String department;

  @override
  State<BatchAllUser> createState() => _BatchAllUserState();
}

class _BatchAllUserState extends State<BatchAllUser> {
  String search = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('All Users')),
        body: Column(
          children: [
            //
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width * .2
                    : 16,
                vertical: 8,
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                    hintText: 'Search by Student ID'),
                onChanged: (val) {
                  setState(() {
                    search = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 4),

            //
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('university', isEqualTo: widget.university)
                  .where('department', isEqualTo: widget.department)
                  .orderBy('name')
                  .snapshots(),
              builder: (context, snapshots) {
                if ((snapshots.connectionState == ConnectionState.waiting)) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Flexible(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width > 800
                              ? MediaQuery.of(context).size.width * .2
                              : 16,
                          vertical: 0,
                        ),
                        itemCount: snapshots.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data =
                              snapshots.data!.docs[index].data()
                                  as Map<String, dynamic>;

                          if (search.isEmpty) {
                            return card(data);
                          }
                          if (data['information']['id']
                              .toString()
                              .toLowerCase()
                              .startsWith(search.toLowerCase())) {
                            return card(data);
                          }
                          return Container();
                        }),
                  );
                }
              },
            ),
          ],
        ));
  }

  //
  card(Map<String, dynamic> profile) {
    return Container(
      // height: 86,
      padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: .5, color: Colors.blueGrey.shade100),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image & batch
          Column(
            children: [
              //image
              CachedNetworkImage(
                imageUrl: profile['image'],
                fadeInDuration: const Duration(milliseconds: 500),
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundImage: imageProvider,
                  radius: 24,
                ),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    const CircleAvatar(
                  radius: 24,
                  backgroundImage:
                      AssetImage('assets/images/pp_placeholder.png'),
                  child: CupertinoActivityIndicator(),
                ),
                errorWidget: (context, url, error) => const CircleAvatar(
                    radius: 24,
                    backgroundImage:
                        AssetImage('assets/images/pp_placeholder.png')),
              ),

              //badge
              if (profile['information']['status']['subscriber'] == 'pro')
                const Row(
                  children: [
                    //
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.blue,
                    ),
                    //
                    Text(
                      'PRO',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(width: 12),

          //name , status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile['name'],
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),

                //
                Row(
                  children: [
                    Text(profile['information']['batch']),
                    const Text(' | '),
                    Text(
                      profile['information']['id'],
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(' | '),
                    Text(profile['information']['session']),
                  ],
                ),

                //
                const SizedBox(height: 2),
                Text('~ ${profile['email']}'),

                //
                const SizedBox(height: 2),
                Row(
                  children: [
                    // is admin
                    if (profile['information']['status']['admin']) ...[
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.greenAccent.shade100,
                          ),
                          child: const Text('Admin')),
                      const SizedBox(width: 8),
                    ],

                    // is moderator
                    if (profile['information']['status']['moderator']) ...[
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.blue.shade100,
                          ),
                          child: const Text('Moderator')),
                      const SizedBox(width: 8),
                    ],

                    // is cr
                    if (profile['information']['status']['cr']) ...[
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.orange.shade100,
                          ),
                          child: const Text('CR')),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ],
            ),
          ),

          //
          PopupMenuButton(
            itemBuilder: (context) => [
              //admin
              PopupMenuItem(
                value: 1,
                onTap: () async {
                  //
                  if (profile['information']['status']['admin']) {
                    //remove as moderator
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(profile['uid'])
                        .update({
                      'information': {
                        'batch': profile['information']['batch'],
                        'id': profile['information']['id'],
                        'session': profile['information']['session'],
                        'hall': profile['information']['hall'],
                        'blood': profile['information']['blood'],
                        'status': {
                          'admin': false,
                          'moderator': profile['information']['status']
                              ['moderator'],
                          'cr': profile['information']['status']['cr'],
                          'subscriber': profile['information']['status']
                              ['subscriber'],
                        }
                      },
                    });
                  } else {
                    //add as admin
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(profile['uid'])
                        .update({
                      'information': {
                        'batch': profile['information']['batch'],
                        'id': profile['information']['id'],
                        'session': profile['information']['session'],
                        'hall': profile['information']['hall'],
                        'blood': profile['information']['blood'],
                        'status': {
                          'admin': true,
                          'moderator': profile['information']['status']
                              ['moderator'],
                          'cr': profile['information']['status']['cr'],
                          'subscriber': profile['information']['status']
                              ['subscriber'],
                        }
                      },
                    });
                  }
                },
                child: (profile['information']['status']['admin'])
                    ? const Text('Remove as Admin')
                    : const Text('Add as Admin'),
              ),

              //moderator
              PopupMenuItem(
                value: 2,
                onTap: () async {
                  //
                  if (profile['information']['status']['moderator']) {
                    //remove as moderator
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(profile['uid'])
                        .update({
                      'information': {
                        'batch': profile['information']['batch'],
                        'id': profile['information']['id'],
                        'session': profile['information']['session'],
                        'hall': profile['information']['hall'],
                        'blood': profile['information']['blood'],
                        'status': {
                          'admin': profile['information']['status']['admin'],
                          'moderator': false,
                          'cr': profile['information']['status']['cr'],
                          'subscriber': profile['information']['status']
                              ['subscriber'],
                        }
                      },
                    });
                  } else {
                    //add as admin
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(profile['uid'])
                        .update({
                      'information': {
                        'batch': profile['information']['batch'],
                        'id': profile['information']['id'],
                        'session': profile['information']['session'],
                        'hall': profile['information']['hall'],
                        'blood': profile['information']['blood'],
                        'status': {
                          'admin': profile['information']['status']['admin'],
                          'moderator': true,
                          'cr': profile['information']['status']['cr'],
                          'subscriber': profile['information']['status']
                              ['subscriber'],
                        }
                      },
                    });
                  }
                },
                child: (profile['information']['status']['moderator'])
                    ? const Text('Remove as Moderator')
                    : const Text('Add as Moderator'),
              ),

              //cr
              PopupMenuItem(
                value: 3,
                onTap: () async {
                  // cr
                  if (profile['information']['status']['cr']) {
                    //remove as moderator
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(profile['uid'])
                        .update({
                      'information': {
                        'batch': profile['information']['batch'],
                        'id': profile['information']['id'],
                        'session': profile['information']['session'],
                        'hall': profile['information']['hall'],
                        'blood': profile['information']['blood'],
                        'status': {
                          'admin': profile['information']['status']['admin'],
                          'moderator': profile['information']['status']
                              ['moderator'],
                          'cr': false,
                          'subscriber': profile['information']['status']
                              ['subscriber'],
                        }
                      },
                    });
                  } else {
                    //add as admin
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(profile['uid'])
                        .update({
                      'information': {
                        'batch': profile['information']['batch'],
                        'id': profile['information']['id'],
                        'session': profile['information']['session'],
                        'hall': profile['information']['hall'],
                        'blood': profile['information']['blood'],
                        'status': {
                          'admin': profile['information']['status']['admin'],
                          'moderator': profile['information']['status']
                              ['moderator'],
                          'cr': true,
                          'subscriber': profile['information']['status']
                              ['subscriber'],
                        }
                      },
                    });
                  }
                },
                child: (profile['information']['status']['cr'])
                    ? const Text('Remove as CR')
                    : const Text('Add as CR'),
              ),

              //pro/basic
              PopupMenuItem(
                value: 4,
                onTap: () async {
                  // cr
                  if (profile['information']['status']['subscriber'] == 'pro') {
                    //remove as moderator
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(profile['uid'])
                        .update({
                      'information': {
                        'batch': profile['information']['batch'],
                        'id': profile['information']['id'],
                        'session': profile['information']['session'],
                        'hall': profile['information']['hall'],
                        'blood': profile['information']['blood'],
                        'status': {
                          'admin': profile['information']['status']['admin'],
                          'moderator': profile['information']['status']
                              ['moderator'],
                          'cr': profile['information']['status']['cr'],
                          'subscriber': 'basic',
                        }
                      },
                    });
                  } else {
                    //add as admin
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(profile['uid'])
                        .update({
                      'information': {
                        'batch': profile['information']['batch'],
                        'id': profile['information']['id'],
                        'session': profile['information']['session'],
                        'hall': profile['information']['hall'],
                        'blood': profile['information']['blood'],
                        'status': {
                          'admin': profile['information']['status']['admin'],
                          'moderator': profile['information']['status']
                              ['moderator'],
                          'cr': profile['information']['status']['cr'],
                          'subscriber': 'pro',
                        }
                      },
                    });
                  }
                },
                child: (profile['information']['status']['subscriber'] == 'pro')
                    ? const Text('Remove as Pro')
                    : const Text('Add as Pro'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
