import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '/models/profile_data.dart';
import '../../../../widgets/open_app.dart';

class Emergency extends StatelessWidget {
  const Emergency({super.key, required this.profileData});

  final ProfileData profileData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contact'),
        centerTitle: true,
      ),

      //
      // floatingActionButton: userModel.role[UserRole.admin.name]
      //     ? Padding(
      //         padding: const EdgeInsets.only(bottom: 32),
      //         child: FloatingActionButton(
      //           onPressed: () async {
      //             //
      //             Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (context) =>
      //                         AddEmergency(userModel: userModel)));
      //           },
      //           child: const Icon(Icons.add),
      //         ),
      //       )
      //     : null,
      //
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Universities')
            .doc(profileData.university)
            .collection('Emergency')
            .orderBy('serial')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!.docs;
          //
          return data.isEmpty
              ? const Center(child: Text('No data found'))
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width > 800
                        ? MediaQuery.of(context).size.width * .2
                        : 16,
                    vertical: 16,
                  ),
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    //
                    return GestureDetector(
                      // onLongPress: userModel.role[UserRole.admin.name]
                      //     ? () async {
                      //         showDialog(
                      //           context: context,
                      //           builder: (context) => AlertDialog(
                      //             title: const Text("Delete?"),
                      //             content:
                      //                 const Text('Are you sure to delete?'),
                      //             actions: [
                      //               //delete
                      //               TextButton(
                      //                 onPressed: () => Navigator.pop(context),
                      //                 child: const Text('Cancel'),
                      //               ),
                      //
                      //               //delete
                      //               TextButton(
                      //                   onPressed: () async {
                      //                     //
                      //                     await data[index]
                      //                         .reference
                      //                         .delete()
                      //                         .then((value) {
                      //                       //
                      //                       Fluttertoast.showToast(
                      //                           msg: 'Delete successfully');
                      //                       //
                      //                       Navigator.pop(context);
                      //                     });
                      //                   },
                      //                   child: const Text('Delete')),
                      //
                      //               const SizedBox(width: 4)
                      //             ],
                      //           ),
                      //         );
                      //       }
                      //     : null,
                      child: Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              //
                              Row(
                                children: [
                                  //name, post, phone
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //serial, name
                                      Row(
                                        children: [
                                          //name
                                          Text(
                                            data[index].get('title'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ],
                                      ),

                                      //post
                                      Text(
                                        data[index].get('address'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: Colors.grey),
                                      ),

                                      const SizedBox(height: 8),

                                      //
                                      GestureDetector(
                                        onTap: () async {
                                          String shareableText =
                                              '${data[index].get('title')}\n${data[index].get('address')}\n\n${data[index].get('phone')}\n';

                                          //
                                          await Share.share(shareableText,
                                              subject: 'Emergency Numbers');
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 4, 16, 4),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .dividerColor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Row(
                                            children: [
                                              //
                                              const Icon(
                                                Icons.share_outlined,
                                                size: 18,
                                              ),

                                              const SizedBox(width: 8),
                                              //
                                              Text(
                                                data[index].get('phone'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //
                                    ],
                                  ),
                                ],
                              ),

                              //
                              IconButton(
                                onPressed: () {
                                  OpenApp.withNumber(data[index].get('phone'));
                                },
                                icon: const Icon(
                                  Icons.call_outlined,
                                  color: Colors.green,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 15),
                );
        },
      ),
    );
  }
}
