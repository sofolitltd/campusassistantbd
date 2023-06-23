import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/models/profile_data.dart';
import 'routine_add.dart';
import 'routine_details.dart';

class Routine extends StatelessWidget {
  const Routine({super.key, required this.profileData});

  final ProfileData profileData;

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(profileData.university)
        .collection('Departments')
        .doc(profileData.department)
        .collection('routines');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Routine'),
        centerTitle: true,
      ),

      //
      floatingActionButton: profileData.information.status!.moderator!
          ? Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: FloatingActionButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddRoutine(profileData: profileData),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            )
          : null,

      body: StreamBuilder<QuerySnapshot>(
        stream: ref.orderBy('time', descending: false).snapshots(),
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
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: MediaQuery.of(context).size.width > 800
                        ? MediaQuery.of(context).size.width * .2
                        : 16,
                  ),
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
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade50,
                            border: Border.all(
                              color: Colors.blueGrey.withOpacity(.2),
                            ),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: data[index].get('image'),
                            fadeInDuration: const Duration(milliseconds: 500),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
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
                                borderRadius: BorderRadius.circular(8),
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
                                        .titleMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
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

                              if (profileData.information.status!.moderator!)
                                IconButton(
                                  onPressed: () async {
                                    //
                                    await ref.doc(data[index].id).delete();

                                    //
                                    await FirebaseStorage.instance
                                        .refFromURL(data[index].get('image'))
                                        .delete()
                                        .then((value) {
                                      Fluttertoast.showToast(
                                          msg: 'Delete successfully');
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.grey,
                                    size: 22,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                );
        },
      ),
    );
  }
}
