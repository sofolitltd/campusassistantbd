import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/profile_data.dart';
import '../routine/routine_details.dart';

class Transports extends StatelessWidget {
  static const routeName = '/transports';

  const Transports({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileData? profileData = Get.arguments['profileData'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transports'),
        centerTitle: true,
      ),

      //
      //    floatingActionButton: userModel.role[UserRole.admin.name]
      //       ? FloatingActionButton(
      //            onPressed: () {
      //              Navigator.push(
      //                context,
      //                MaterialPageRoute(
      //                  builder: (context) => AddTransports(userModel: userModel),
      //                ),
      //              );
      //            },
      //            child: const Icon(Icons.add),
      //          )
      //        : null,
      //
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Universities')
            .doc(profileData!.university)
            .collection('Transports')
            .orderBy('time', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('some thing wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          //
          var data = snapshot.data!.docs;

          return data.isEmpty
              ? const Center(child: Text('No data found'))
              : ListView.separated(
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: MediaQuery.of(context).size.width > 1000
                        ? MediaQuery.of(context).size.width * .2
                        : 16,
                  ),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RoutineDetails(data: data[index])));
                    },
                    child: Column(
                      children: [
                        // image
                        Container(
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.grey.shade50,
                            border: Border.all(
                              color: Colors.blueGrey.withOpacity(.2),
                            ),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: data[index].get('imageUrl'),
                            fadeInDuration: const Duration(milliseconds: 500),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    const CupertinoActivityIndicator(),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                color: Colors.grey.shade100,
                              ),
                            ),
                          ),
                        ),

                        // text
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data[index]
                                        .get('title')
                                        .toString()
                                        .toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                  ),

                                  const SizedBox(height: 4),

                                  //
                                  Text(
                                    data[index]
                                        .get('time')
                                        .toString()
                                        .toLowerCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            // fontWeight: FontWeight.w100,
                                            // color: Colors.black54,
                                            ),
                                  ),
                                ],
                              ),

                              // if (userModel.role[UserRole.admin.name])
                              //   IconButton(
                              //     onPressed: () async {
                              //       //
                              //       await FirebaseFirestore.instance
                              //           .collection('Universities')
                              //           .doc(userModel.university)
                              //           .collection('Departments')
                              //           .doc(userModel.department)
                              //           .collection('Routine')
                              //           .doc(data[index].id)
                              //           .delete();
                              //
                              //       //
                              //       await FirebaseStorage.instance
                              //           .refFromURL(
                              //               data[index].get('imageUrl'))
                              //           .delete()
                              //           .then((value) {
                              //         Fluttertoast.showToast(
                              //             msg: 'Delete successfully');
                              //       });
                              //     },
                              //     icon: const Icon(
                              //       Icons.delete,
                              //       color: Colors.black,
                              //     ),
                              //   ),
                              //
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                );
        },
      ),
    );
  }
}
